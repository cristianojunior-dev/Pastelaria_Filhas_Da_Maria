const db = require('../config/db');
const notificacaoService = require('../services/notificacao.service');

const adminController = {
    // Renderiza o Painel de Controle Principal
    renderDashboard: async (req, res) => {
        try {
            // 1. Busca todos os pedidos ordenados pelos mais recentes
            const [pedidosRows] = await db.query(
                `SELECT id, codigo, status, total_pedido, taxa_entrega, forma_pagamento, data 
                 FROM pedidos
                 WHERE status != 'entregue'
                 ORDER BY data DESC`
            );

            const pedidos = pedidosRows.map(p => {
                const dataObj = new Date(p.data);
                return {
                    ...p,
                    total_geral: (parseFloat(p.total_pedido) + parseFloat(p.taxa_entrega)).toFixed(2),
                    data_formatada: dataObj.toLocaleString('pt-BR')
                };
            });

            // 2. Busca as categorias disponíveis
            const [categorias] = await db.query('SELECT * FROM categorias');
            
            // 3. Busca todos os produtos cadastrados
            const [produtosRows] = await db.query('SELECT * FROM produtos ORDER BY nome ASC');

            // =========================================================================
            // NOVA QUERY: Busca todos os ingredientes cadastrados para a Aba 4
            // =========================================================================
            const [ingredientesRows] = await db.query('SELECT * FROM ingredientes ORDER BY nome ASC');

            res.render('admin/dashboard', {
                cssPage: 'admin',
                pedidos: pedidos,
                categorias: categorias,
                todosProdutos: produtosRows,
                todosIngredientes: ingredientesRows, // Abastece a Aba 4 de Estoque
                usuarioLogado: req.session.usuarioLogado || false,
                usuarioNome: req.session.usuarioNome || null,
                userAdmin: req.session.userAdmin || false
            });

        } catch (error) {
            console.error('Erro ao carregar Dashboard:', error);
            res.status(500).send('Erro interno do servidor.');
        }
    },

    // Processa o cadastro de um novo produto (Com vínculo inteligente de ingredientes)
    addProduct: async (req, res) => {
        const { nome, preco, id_categoria, descricao } = req.body;
        
        try {
            if (!req.file) {
                return res.status(400).send('Por favor, envie uma foto do produto.');
            }

            const nomeImagem = req.file.filename;

            // 1. Insere o produto normalmente na tabela 'produtos'
            const [result] = await db.query(
                `INSERT INTO produtos (nome, preco, id_categoria, descricao, imagem) 
                 VALUES (?, ?, ?, ?, ?)`,
                [nome, preco, id_categoria, descricao, nomeImagem]
            );

            const novoProdutoId = result.insertId;

            // =========================================================================
            // LÓGICA INTELIGENTE (OPÇÃO B): Busca todos os ingredientes do banco
            // =========================================================================
            const [ingredientes] = await db.query('SELECT id, nome FROM ingredientes');

            // Converte a descrição digitada para letras minúsculas para facilitar a busca
            const descricaoMinuscula = descricao.toLowerCase();

            for (const ingrediente of ingredientes) {
                // Converte o nome do ingrediente do banco para minúsculo (ex: "Goiabada Cremosa" vira "goiabada cremosa")
                const nomeIngredienteMinusculo = ingrediente.nome.toLowerCase();
                
                // Quebra o nome do ingrediente para buscar por palavras-chave principais (ex: foca em "goiabada")
                // Filtra palavras muito curtas como "de", "com", "e"
                const palavrasChave = nomeIngredienteMinusculo.split(' ').filter(p => p.length > 3);

                // Verifica se a descrição do produto contém o nome inteiro ou alguma das palavras-chave principais
                const contemIngrediente = descricaoMinuscula.includes(nomeIngredienteMinusculo) || 
                                          palavrasChave.some(palavra => descricaoMinuscula.includes(palavra));

                if (contemIngrediente) {
                    // Se encontrou a palavra no texto, faz o vínculo na tabela relacional automaticamente!
                    await db.query(
                        'INSERT INTO produto_ingredientes (id_produto, id_ingrediente) VALUES (?, ?)',
                        [novoProdutoId, ingrediente.id]
                    );
                }
            }
            // =========================================================================

            // Redireciona de volta para o dashboard com tudo atualizado
            res.redirect('/admin/dashboard');

        } catch (error) {
            console.error('Erro ao cadastrar produto:', error);
            res.status(500).send('Erro interno do servidor.');
        }
    },

    // Altera o status do pedido acompanhando a fila de entrada e envia NOTIFICAÇÃO NO WHATSAPP
    updateOrderStatus: async (req, res) => {
    const { id } = req.params;
    const { status } = req.body;
    try {
        // 1. Atualiza o status do pedido no MySQL
        await db.query('UPDATE pedidos SET status = ? WHERE id = ?', [status, id]);

        // 2. Busca o e-mail do cliente e o código do pedido para a mensagem
        const [pedidoRows] = await db.query(
            `SELECT p.codigo, u.nome, u.email
              FROM pedidos p
             INNER JOIN usuario u ON p.id_usuario = u.id
             WHERE p.id = ?`,
             [id]
        );

        if (pedidoRows.length > 0) {
            const dadosPedido = pedidoRows[0];

            if (dadosPedido.email) {
                let textoMensagem = `Olá, ${dadosPedido.nome}!\nSeu pedido ${dadosPedido.codigo} teve uma atualização: `;

                if (status === 'recebido') {
                    textoMensagem += `Ele foi RECEBIDO e já está na nossa fila de entrada.`;
                } else if (status === 'em preparação') {
                    textoMensagem += `Ele já está EM PREPARAÇÃO na cozinha! Seus pastéis estão sendo fritos na hora.`;
                } else if (status === 'enviado') {
                    textoMensagem += `Ele foi ENVIADO! O motoboy já está a caminho da sua residência.`;
                } else if (status === 'entregue') {
                    textoMensagem += `Ele foi ENTREGUE! Muito obrigado pela preferência e bom apetite!`;
                }

                // Envia o e-mail usando o serviço criado
                await notificacaoService.enviarEmail(
                    dadosPedido.email,
                    `Atualização do seu pedido: ${dadosPedido.codigo}`,
                    textoMensagem
                );
            }
        }

        res.redirect('/admin/dashboard');
    } catch (error) {
        console.error('Erro ao atualizar status ou enviar E-mail:', error);
        res.redirect('/admin/dashboard');
    }
},

    toggleIngredientStatus: async (req, res) => {
        const { id } = req.params;

        try {
            // 1. Busca o status atual do ingrediente no banco
            const [rows] = await db.query('SELECT em_estoque FROM ingredientes WHERE id = ?', [id]);
            if (rows.length === 0) return res.status(404).send('Ingrediente não encontrado.');

            // Inverte o valor booleano (se for 1 vira 0, se for 0 vira 1)
            const novoStatus = rows[0].em_estoque === 1 ? 0 : 1;

            // 2. Dá o comando UPDATE no MySQL
            await db.query('UPDATE ingredientes SET em_estoque = ? WHERE id = ?', [novoStatus, id]);

            // 3. Redireciona de volta para atualizar a tela instantaneamente
            res.redirect('/admin/dashboard');

        } catch (error) {
            console.error('Erro ao alterar estoque do ingrediente:', error);
            res.status(500).send('Erro interno ao atualizar estoque.');
        }
    },

    // POST: Remove permanentemente um produto do cardápio
    deleteProduct: async (req, res) => {
        const { id } = req.params;

        try {
            // Executa a query de remoção no MySQL
            await db.query('DELETE FROM produtos WHERE id = ?', [id]);

            // Redireciona de volta para atualizar a lista na tela instantaneamente
            res.redirect('/admin/dashboard');

        } catch (error) {
            console.error('Erro ao excluir produto:', error);
            res.status(500).send('Erro interno ao excluir o item do cardápio.');
        }
    },

    // POST: Recebe os novos dados e salva a alteração no MySQL
    updateProduct: async (req, res) => {
        const { id } = req.params;
        const { nome, preco, id_categoria, descricao } = req.body;

        try {
            // Se o usuário fez upload de uma nova foto, atualiza com a foto nova
            if (req.file) {
                const novaImagem = req.file.filename;
                await db.query(
                    `UPDATE produtos SET nome = ?, preco = ?, id_categoria = ?, descricao = ?, imagem = ? WHERE id = ?`,
                    [nome, preco, id_categoria, descricao, novaImagem, id]
                );
            } else {
                // Se não enviou foto nova, mantém a imagem antiga intacta no banco
                await db.query(
                    `UPDATE produtos SET nome = ?, preco = ?, id_categoria = ?, descricao = ? WHERE id = ?`,
                    [nome, preco, id_categoria, descricao, id]
                );
            }

            // Redireciona para o dashboard recarregando a lista atualizada
            res.redirect('/admin/dashboard');
        } catch (error) {
            console.error('Erro ao atualizar produto:', error);
            res.status(500).send('Erro ao salvar modificações.');
        }
    }
};

module.exports = adminController;