const db = require('../config/db');
const notificacaoService = require('../services/notificacao.service');

const adminController = {
    renderDashboard: async (req, res) => {
        try {
            const [pedidosRows] = await db.query(
                `SELECT id, codigo, status, total_pedido, taxa_entrega, forma_pagamento, data 
                 FROM pedidos WHERE status != 'entregue' ORDER BY data DESC`
            );

            const pedidos = pedidosRows.map(p => {
                const dataObj = new Date(p.data);
                return {
                    ...p,
                    total_geral: (parseFloat(p.total_pedido) + parseFloat(p.taxa_entrega)).toFixed(2),
                    data_formatada: dataObj.toLocaleString('pt-BR')
                };
            });

            const [categorias] = await db.query('SELECT * FROM categorias ORDER BY id ASC');
            const [produtosRows] = await db.query('SELECT * FROM produtos ORDER BY nome ASC');
            const [ingredientesRows] = await db.query('SELECT * FROM ingredientes ORDER BY nome ASC');
            
            // LÓGICA DOS RELATÓRIOS GERENCIAIS
            const { tipoRelatorio, data_inicio, data_fim, id_categoria } = req.query;
            
            if (tipoRelatorio) {
                console.log('[DEBUG RELATÓRIO] Parâmetros recebidos:', req.query);
            }

            let relatorioFaturamento = null;
            let relatorioPedidos = null;
            const filtrosSalvos = { data_inicio, data_fim };

            const categoriasModificadas = categorias.map(cat => ({
                ...cat,
                selectedRelatorio: String(cat.id) === String(id_categoria)
            }));

            // CARD 1: Filtro de Faturamento Bruto + Lista Detalhada de Produtos Vendidos
            if (tipoRelatorio === 'faturamento' && data_inicio && data_fim) {
                let filtroCategoriaSQL = '';
                let queryParams = [`${data_inicio} 00:00:00`, `${data_fim} 23:59:59`];

                if (id_categoria && id_categoria !== 'todas') {
                    filtroCategoriaSQL = ` AND pr.id_categoria = ?`;
                    queryParams.push(id_categoria);
                }

                // 1.1 Busca o total geral do período
                const queryFaturamento = `
                    SELECT 
                        COALESCE(SUM(pi.quantidade * pi.preco_unitario), 0) AS total_bruto, 
                        COALESCE(SUM(pi.quantidade), 0) AS total_itens
                    FROM pedido_itens pi
                    INNER JOIN pedidos pe ON pi.id_pedido = pe.id
                    INNER JOIN produtos pr ON pi.id_produto = pr.id
                    WHERE pe.status = 'entregue' 
                    AND pe.data BETWEEN ? AND ?` + filtroCategoriaSQL;

                const [fatResult] = await db.query(queryFaturamento, queryParams);
                const dadosFat = fatResult[0] || { total_bruto: 0, total_itens: 0 };

                // 1.2 Busca o detalhamento agrupado por produto
                const queryProdutosDetalhados = `
                    SELECT 
                        pr.nome,
                        SUM(pi.quantidade) AS qtd_vendida,
                        pi.preco_unitario,
                        SUM(pi.quantidade * pi.preco_unitario) AS subtotal
                    FROM pedido_itens pi
                    INNER JOIN pedidos pe ON pi.id_pedido = pe.id
                    INNER JOIN produtos pr ON pi.id_produto = pr.id
                    WHERE pe.status = 'entregue'
                    AND pe.data BETWEEN ? AND ?` + filtroCategoriaSQL + `
                    GROUP BY pr.id, pr.nome, pi.preco_unitario
                    ORDER BY qtd_vendida DESC`;

                const [produtosDetalhadosRows] = await db.query(queryProdutosDetalhados, queryParams);

                const listaProdutos = produtosDetalhadosRows.map(item => ({
                    nome: item.nome,
                    qtd_vendida: item.qtd_vendida,
                    preco_unitario: parseFloat(item.preco_unitario).toFixed(2),
                    subtotal: parseFloat(item.subtotal).toFixed(2)
                }));
                
                relatorioFaturamento = {
                    total: (parseFloat(dadosFat.total_bruto) || 0).toFixed(2),
                    itensVendidos: parseInt(dadosFat.total_itens) || 0,
                    produtos: listaProdutos // <-- Envia a lista detalhada para a View
                };
            }

            // CARD 2: Filtro de Total de Pedidos Entregues + Lista de Pedidos c/ Produtos
            if (tipoRelatorio === 'pedidos' && data_inicio && data_fim) {
                const paramsPedidos = [`${data_inicio} 00:00:00`, `${data_fim} 23:59:59`];

                // 2.1 Busca o resumo de entregas
                const [pedResult] = await db.query(
                    `SELECT 
                        COUNT(id) AS total_entregas, 
                        COALESCE(SUM(total_pedido + taxa_entrega), 0) AS total_faturado
                     FROM pedidos
                     WHERE status = 'entregue'
                     AND data BETWEEN ? AND ?`,
                    paramsPedidos
                );

                const dadosPed = pedResult[0] || { total_entregas: 0, total_faturado: 0 };
                const totalEntregas = parseInt(dadosPed.total_entregas) || 0;
                const totalDinheiro = parseFloat(dadosPed.total_faturado) || 0;
                const ticketMedio = totalEntregas > 0 ? (totalDinheiro / totalEntregas) : 0;

                // 2.2 Busca cada pedido entregue e concatena os produtos daquele pedido
                const [listaPedidosRows] = await db.query(
                    `SELECT 
                        pe.codigo,
                        pe.data,
                        pe.forma_pagamento,
                        (pe.total_pedido + pe.taxa_entrega) AS total_geral,
                        GROUP_CONCAT(CONCAT(pi.quantidade, 'x ', pr.nome) SEPARATOR ', ') AS resumo_itens
                     FROM pedidos pe
                     INNER JOIN pedido_itens pi ON pe.id = pi.id_pedido
                     INNER JOIN produtos pr ON pi.id_produto = pr.id
                     WHERE pe.status = 'entregue'
                     AND pe.data BETWEEN ? AND ?
                     GROUP BY pe.id
                     ORDER BY pe.data DESC`,
                    paramsPedidos
                );

                const listaPedidos = listaPedidosRows.map(p => ({
                    codigo: p.codigo,
                    data_formatada: new Date(p.data).toLocaleString('pt-BR'),
                    forma_pagamento: p.forma_pagamento,
                    total_geral: parseFloat(p.total_geral).toFixed(2),
                    resumo_itens: p.resumo_itens
                }));

                relatorioPedidos = {
                    total: totalEntregas,
                    ticketMedio: ticketMedio.toFixed(2),
                    pedidosLista: listaPedidos
                };
            }

            res.render('admin/dashboard', {
                cssPage: 'admin',
                pedidos: pedidos,
                categorias: categoriasModificadas,
                todosProdutos: produtosRows,
                todosIngredientes: ingredientesRows,
                relatorioFaturamento: relatorioFaturamento,
                relatorioPedidos: relatorioPedidos,
                filtrosSalvos: filtrosSalvos,
                usuarioLogado: req.session.usuarioLogado || false,
                usuarioNome: req.session.usuarioNome || null,
                userAdmin: req.session.userAdmin || false
            });
        } catch (error) {
            console.error('Erro ao carregar Dashboard:', error);
            res.status(500).send('Erro interno do servidor.');
        }
    },

    addProduct: async (req, res) => {
        const { nome, preco, id_categoria, ingredientes } = req.body;
        
        try {
            if (!req.file) return res.status(400).send('Envie uma foto.');
            const nomeImagem = req.file.filename;

            
            const [result] = await db.query(
                `INSERT INTO produtos (nome, preco, id_categoria, imagem) VALUES (?, ?, ?, ?)`,
                [nome, preco, id_categoria, nomeImagem]
            );

            const novoProdutoId = result.insertId;

            if (ingredientes) {
                const listaIngredientes = Array.isArray(ingredientes) ? ingredientes : [ingredientes];
                for (const idIngrediente of listaIngredientes) {
                    await db.query('INSERT INTO produto_ingredientes (id_produto, id_ingrediente) VALUES (?, ?)', [novoProdutoId, idIngrediente]);
                }
            }

            res.redirect('/admin/dashboard');
        } catch (error) {
            console.error('Erro ao cadastrar produto:', error);
            res.status(500).send('Erro interno do servidor.');
        }
    },

    updateProduct: async (req, res) => {
        const { id } = req.params;
        const { nome, preco, id_categoria, ingredientes } = req.body; 

        try {
            
            if (req.file) {
                const novaImagem = req.file.filename;
                await db.query(
                    `UPDATE produtos SET nome = ?, preco = ?, id_categoria = ?, imagem = ? WHERE id = ?`,
                    [nome, preco, id_categoria, novaImagem, id]
                );
            } else {
                await db.query(
                    `UPDATE produtos SET nome = ?, preco = ?, id_categoria = ? WHERE id = ?`,
                    [nome, preco, id_categoria, id]
                );
            }

            await db.query('DELETE FROM produto_ingredientes WHERE id_produto = ?', [id]);

            if (ingredientes) {
                const listaIngredientes = Array.isArray(ingredientes) ? ingredientes : [ingredientes];
                for (const idIngrediente of listaIngredientes) {
                    await db.query('INSERT INTO produto_ingredientes (id_produto, id_ingrediente) VALUES (?, ?)', [id, idIngrediente]);
                }
            }

            res.redirect('/admin/dashboard');
        } catch (error) {
            console.error('Erro ao atualizar produto:', error);
            res.status(500).send('Erro ao salvar modificações.');
        }
    },

    getProductIngredients: async (req, res) => {
        const { id } = req.params;
        try {
            const [rows] = await db.query('SELECT id_ingrediente FROM produto_ingredientes WHERE id_produto = ?', [id]);
            res.json(rows.map(r => r.id_ingrediente));
        } catch (error) {
            console.error('Erro ao buscar ingredientes:', error);
            res.status(500).json([]);
        }
    },

    deleteProduct: async (req, res) => {
        const { id } = req.params;
        try {
            await db.query('DELETE FROM produtos WHERE id = ?', [id]);
            res.redirect('/admin/dashboard');
        } catch (error) {
            console.error('Erro ao excluir produto:', error);
            res.status(500).send('Erro interno.');
        }
    },

        updateOrderStatus: async (req, res) => {
        const { id } = req.params;
        const { status } = req.body;

        try {
            await db.query('UPDATE pedidos SET status = ? WHERE id = ?', [status, id]);

            const [pedidoRows] = await db.query(
                `SELECT p.codigo, u.nome, u.email 
                 FROM pedidos p 
                 INNER JOIN usuario u ON p.id_usuario = u.id 
                 WHERE p.id = ?`, 
                [id]
            );

            if (pedidoRows.length > 0 && pedidoRows[0].email) {
                const clienteNome = pedidoRows[0].nome;
                const pedidoCodigo = pedidoRows[0].codigo;
                const statusFormatado = status.toUpperCase();

                let txt = `Olá, ${clienteNome}!\nSeu pedido ${pedidoCodigo} mudou para: ${statusFormatado}`;

                const logoUrl = 'https://raw.githubusercontent.com/cristianojunior-dev/Pastelaria_Filhas_Da_Maria/main/public/images/LOGO.transparente.png';

                let html = `
                <div style="font-family: 'Montserrat', Arial, sans-serif; max-width: 600px; margin: 0 auto; border: 1px solid #FFE1E5; border-radius: 12px; overflow: hidden; box-shadow: 0 4px 15px rgba(0,0,0,0.05); background-color: #FFFFFF;">
                    
                    <!-- Cabeçalho com a Logo -->
                    <div style="background-color: #FFF0F2; padding: 25px 20px; text-align: center; border-bottom: 3px solid #FF8838;">
                        <img src="${logoUrl}" alt="Pastelaria Filhas da Maria" style="max-height: 80px; width: auto; object-fit: contain;">
                    </div>
                    
                    <!-- Corpo do E-mail -->
                    <div style="padding: 40px 30px; text-align: center; color: #2D2D2D;">
                        <h2 style="color: #FF8838; margin-top: 0; font-size: 24px;">Atualização do seu pedido!</h2>
                        
                        <p style="font-size: 16px; line-height: 1.6; color: #777777;">Olá, <strong style="color: #2D2D2D;">${clienteNome}</strong>!</p>
                        
                        <p style="font-size: 16px; line-height: 1.6; color: #777777;">
                            Passando para avisar que o status do seu pedido <strong style="color: #FF8838;">${pedidoCodigo}</strong> acabou de ser atualizado para:
                        </p>
                        
                        <!-- Badge de Status -->
                        <div style="display: inline-block; background-color: #FFD2B2; color: #E06E1F; padding: 12px 25px; border-radius: 30px; font-weight: bold; font-size: 18px; margin: 25px 0; text-transform: uppercase; border: 1px solid #FF8838;">
                            ${statusFormatado}
                        </div>
                        
                        <p style="font-size: 15px; color: #777777; line-height: 1.6; margin-top: 10px;">
                            Prepare-se para saborear o melhor pastel da região. Feito com amor! ❤️
                        </p>
                    </div>
                    
                    <!-- Rodapé do E-mail -->
                    <div style="background-color: #0E1630; color: #FFFFFF; text-align: center; padding: 25px 20px; font-size: 13px;">
                        <h4 style="margin: 0 0 10px 0; font-size: 16px; color: #FF8838;">Pastelaria Filhas da Maria</h4>
                        <p style="margin: 5px 0 0 0; color: #CDD3CE;">Avenida Walter Tatoni, nº 623 - Vila Santana</p>
                        <p style="margin: 5px 0 0 0; color: #CDD3CE;">De quarta a sexta-feira, das 17h00 às 22h00</p>
                    </div>
                </div>
                `;

                await notificacaoService.enviarEmail(
                    pedidoRows[0].email, 
                    `Atualização do Pedido: ${pedidoCodigo}`, 
                    txt, 
                    html
                );
            }

            res.redirect('/admin/dashboard');

        } catch (error) {
            console.error(error);
            res.redirect('/admin/dashboard');
        }
    },


    toggleIngredientStatus: async (req, res) => {
        const { id } = req.params;
        try {
            const [rows] = await db.query('SELECT em_estoque FROM ingredientes WHERE id = ?', [id]);
            if (rows.length > 0) {
                await db.query('UPDATE ingredientes SET em_estoque = ? WHERE id = ?', [rows[0].em_estoque === 1 ? 0 : 1, id]);
            }
            res.redirect('/admin/dashboard');
        } catch (error) {
            res.status(500).send('Erro.');
        }
    },

    addIngredient: async (req, res) => {
        const { nome } = req.body;
        if (nome && nome.trim()) {
            try {
                // Insere o novo ingrediente e define-o como disponível (em_estoque = 1)
                await db.query('INSERT INTO ingredientes (nome, em_estoque) VALUES (?, 1)', [nome.trim()]);
            } catch (error) {
                console.error('Erro ao adicionar ingrediente:', error);
            }
        }
        res.redirect('/admin/dashboard');
    },

    updateIngredient: async (req, res) => {
        const { id } = req.params;
        const { nome } = req.body;
        
        if (nome && nome.trim()) {
            try {
                await db.query('UPDATE ingredientes SET nome = ? WHERE id = ?', [nome.trim(), id]);
            } catch (error) {
                console.error('Erro ao editar ingrediente:', error);
            }
        }
        res.redirect('/admin/dashboard');
    },

    toggleIngredientStatus: async (req, res) => {
        const { id } = req.params;
        try {
            const [rows] = await db.query('SELECT em_estoque FROM ingredientes WHERE id = ?', [id]);
            if (rows.length > 0) {
                await db.query('UPDATE ingredientes SET em_estoque = ? WHERE id = ?', [rows[0].em_estoque === 1 ? 0 : 1, id]);
            }
            res.redirect('/admin/dashboard');
        } catch (error) {
            res.status(500).send('Erro.');
        }
    },

    deleteIngredient: async (req, res) => {
        const { id } = req.params;
        try {
            await db.query('DELETE FROM ingredientes WHERE id = ?', [id]);
            res.redirect('/admin/dashboard');
        } catch (error) {
            console.error('Erro ao excluir ingrediente:', error);
            res.redirect('/admin/dashboard');
        }
    },

    addCategory: async (req, res) => {
        const { nome } = req.body;
        if (nome && nome.trim()) {
            await db.query('INSERT INTO categorias (nome) VALUES (?)', [nome.trim()]);
        }
        res.redirect('/admin/dashboard');
    },

    updateCategory: async (req, res) => {
        const { id } = req.params;
        const { nome } = req.body;
        if (nome && nome.trim()) {
            await db.query('UPDATE categorias SET nome = ? WHERE id = ?', [nome.trim(), id]);
        }
        res.redirect('/admin/dashboard');
    },

    deleteCategory: async (req, res) => {
        const { id } = req.params;
        await db.query('UPDATE produtos SET id_categoria = NULL WHERE id_categoria = ?', [id]);
        await db.query('DELETE FROM categorias WHERE id = ?', [id]);
        res.redirect('/admin/dashboard');
    },

    // GET: Retorna os produtos, endereço e nome do cliente para a comanda
    getPedidoDetalhes: async (req, res) => {
        const { id } = req.params;
        try {
            // 1. Busca os produtos e quantidades vinculados ao pedido
            const [itens] = await db.query(
                `SELECT pr.nome, pi.quantidade 
                 FROM pedido_itens pi
                 INNER JOIN produtos pr ON pi.id_produto = pr.id
                 WHERE pi.id_pedido = ?`,
                [id]
            );

            // 2. Busca o endereço completo e o nome do cliente cruzando as tabelas
            const [pedidoInfoRows] = await db.query(
                `SELECT u.nome AS cliente_nome, e.rua, e.numero, e.bairro, e.cidade 
                 FROM pedidos p
                 INNER JOIN usuario u ON p.id_usuario = u.id
                 LEFT JOIN enderecos e ON u.id = e.id_usuario
                 WHERE p.id = ?
                 LIMIT 1`,
                [id]
            );

            let nomeCliente = 'Cliente Não Identificado';
            let enderecoFormatado = 'Retirar no Local / Não cadastrado';

            if (pedidoInfoRows.length > 0) {
                const info = pedidoInfoRows[0];
                nomeCliente = info.cliente_nome;
                
                if (info.rua) {
                    enderecoFormatado = `${info.rua}, Nº ${info.numero} - Bairro: ${info.bairro}, ${info.cidade}`;
                }
            }

            
            res.json({ itens, endereco: enderecoFormatado, cliente: nomeCliente });
        } catch (error) {
            console.error('Erro ao buscar detalhes do pedido para a comanda:', error);
            res.status(500).json({ itens: [], endereco: 'Erro ao carregar', cliente: 'Erro' });
        }
    }

};

module.exports = adminController;