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

                      
            // LÓGICA DOS RELATÓRIOS GERENCIAIS COM FILTROS AVANÇADOS (ABA 6)

            const { tipoRelatorio, data_inicio, data_fim, id_categoria } = req.query;

            let relatorioFaturamento = null;
            let relatorioPedidos = null;
            
            // Mantém as datas preenchidas nos inputs após clicar em filtrar
            const filtrosSalvos = { data_inicio, data_fim };

            // Mapeia as categorias criadas pelo operador para o select do relatório
            const categoriasModificadas = categorias.map(cat => ({
                ...cat,
                selectedRelatorio: cat.id == id_categoria
            }));

            // CARD 1: Filtro de Faturamento Bruto por período e categoria
            if (tipoRelatorio === 'faturamento' && data_inicio && data_fim) {
                let queryFaturamento = `
                    SELECT SUM(pi.quantidade * pi.preco_unitario) AS total_bruto, SUM(pi.quantidade) AS total_itens
                    FROM pedido_itens pi
                    INNER JOIN pedidos pe ON pi.id_pedido = pe.id
                    INNER JOIN produtos pr ON pi.id_produto = pr.id
                    WHERE pe.status = 'entregue' 
                    AND pe.data BETWEEN ? AND ?`;
                
                let queryParams = [`${data_inicio} 00:00:00`, `${data_fim} 23:59:59`];

                if (id_categoria && id_categoria !== 'todas') {
                    queryFaturamento += ` AND pr.id_categoria = ?`;
                    queryParams.push(id_categoria);
                }

                const [fatResult] = await db.query(queryFaturamento, queryParams);
                
                relatorioFaturamento = {
                    total: (parseFloat(fatResult.total_bruto) || 0).toFixed(2),
                    itensVendidos: parseInt(fatResult.total_itens) || 0
                };
            }

            // CARD 2: Filtro de Total de Pedidos Entregues por período
            if (tipoRelatorio === 'pedidos' && data_inicio && data_fim) {
                const [pedResult] = await db.query(
                    `SELECT COUNT(id) AS total_entregas, SUM(total_pedido + taxa_entrega) AS total_faturado
                     FROM pedidos
                     WHERE status = 'entregue'
                     AND data BETWEEN ? AND ?`,
                    [`${data_inicio} 00:00:00`, `${data_fim} 23:59:59`]
                );

                const totalEntregas = parseInt(pedResult.total_entregas) || 0;
                const totalDinheiro = parseFloat(pedResult.total_faturado) || 0;
                const ticketMedio = totalEntregas > 0 ? (totalDinheiro / totalEntregas) : 0;

                relatorioPedidos = {
                    total: totalEntregas,
                    ticketMedio: ticketMedio.toFixed(2)
                };
            }

            res.render('admin/dashboard', {
                cssPage: 'admin',
                pedidos: pedidos,
                categorias: categorias,
                todosProdutos: produtosRows,
                todosIngredientes: ingredientesRows,
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
        const { nome, preco, id_categoria, ingredientes } = req.body; // descricao removida
        
        try {
            if (!req.file) return res.status(400).send('Envie uma foto.');
            const nomeImagem = req.file.filename;

            // INSERT sem a coluna descricao
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
        const { nome, preco, id_categoria, ingredientes } = req.body; // descricao removida

        try {
            // UPDATE sem a coluna descricao
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
            const [pedidoRows] = await db.query(`SELECT p.codigo, u.nome, u.email FROM pedidos p INNER JOIN usuario u ON p.id_usuario = u.id WHERE p.id = ?`, [id]);
            if (pedidoRows.length > 0 && pedidoRows[0].email) {
                let txt = `Olá, ${pedidoRows[0].nome}!\nSeu pedido ${pedidoRows[0].codigo} mudou para: ${status.toUpperCase()}`;
                await notificacaoService.enviarEmail(pedidoRows[0].email, `Atualização: ${pedidoRows[0].codigo}`, txt);
            }
            res.redirect('/admin/dashboard');
        } catch (error) {
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
    }
};

module.exports = adminController;