const db = require('../config/db');
const notificacaoService = require('../services/notificacao.service');

const adminController = {
    renderDashboard: async (req, res) => {
        try {
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

            const [categorias] = await db.query('SELECT * FROM categorias ORDER BY id ASC');
            
            const [produtosRows] = await db.query('SELECT * FROM produtos ORDER BY nome ASC');

            const [ingredientesRows] = await db.query('SELECT * FROM ingredientes ORDER BY nome ASC');

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
        const { nome, preco, id_categoria, descricao } = req.body;
        
        try {
            if (!req.file) {
                return res.status(400).send('Por favor, envie uma foto do produto.');
            }

            const nomeImagem = req.file.filename;

            const [result] = await db.query(
                `INSERT INTO produtos (nome, preco, id_categoria, descricao, imagem) 
                 VALUES (?, ?, ?, ?, ?)`,
                [nome, preco, id_categoria, descricao, nomeImagem]
            );

            const novoProdutoId = result.insertId;

            const [ingredientes] = await db.query('SELECT id, nome FROM ingredientes');
            const descricaoMinuscula = descricao.toLowerCase();

            for (const ingrediente of ingredientes) {
                const nomeIngredienteMinusculo = ingrediente.nome.toLowerCase();
                const palavrasChave = nomeIngredienteMinusculo.split(' ').filter(p => p.length > 3);

                const contemIngrediente = descricaoMinuscula.includes(nomeIngredienteMinusculo) || 
                                          palavrasChave.some(palavra => descricaoMinuscula.includes(palavra));

                if (contemIngrediente) {
                    await db.query(
                        'INSERT INTO produto_ingredientes (id_produto, id_ingrediente) VALUES (?, ?)',
                        [novoProdutoId, ingrediente.id]
                    );
                }
            }

            res.redirect('/admin/dashboard');

        } catch (error) {
            console.error('Erro ao cadastrar produto:', error);
            res.status(500).send('Erro interno do servidor.');
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
            const [rows] = await db.query('SELECT em_estoque FROM ingredientes WHERE id = ?', [id]);
            if (rows.length === 0) return res.status(404).send('Ingrediente não encontrado.');

            const novoStatus = rows[0].em_estoque === 1 ? 0 : 1;
            await db.query('UPDATE ingredientes SET em_estoque = ? WHERE id = ?', [novoStatus, id]);

            res.redirect('/admin/dashboard');
        } catch (error) {
            console.error('Erro ao alterar estoque do ingrediente:', error);
            res.status(500).send('Erro interno ao atualizar estoque.');
        }
    },

    deleteProduct: async (req, res) => {
        const { id } = req.params;

        try {
            await db.query('DELETE FROM produtos WHERE id = ?', [id]);
            res.redirect('/admin/dashboard');
        } catch (error) {
            console.error('Erro ao excluir produto:', error);
            res.status(500).send('Erro interno ao excluir o item do cardápio.');
        }
    },

    updateProduct: async (req, res) => {
        const { id } = req.params;
        const { nome, preco, id_categoria, descricao } = req.body;

        try {
            if (req.file) {
                const novaImagem = req.file.filename;
                await db.query(
                    `UPDATE produtos SET nome = ?, preco = ?, id_categoria = ?, descricao = ?, imagem = ? WHERE id = ?`,
                    [nome, preco, id_categoria, descricao, novaImagem, id]
                );
            } else {
                await db.query(
                    `UPDATE produtos SET nome = ?, preco = ?, id_categoria = ?, descricao = ? WHERE id = ?`,
                    [nome, preco, id_categoria, descricao, id]
                );
            }

            res.redirect('/admin/dashboard');
        } catch (error) {
            console.error('Erro ao atualizar produto:', error);
            res.status(500).send('Erro ao salvar modificações.');
        }
    },
 
    addCategory: async (req, res) => {
        const { nome } = req.body;

        if (!nome || !nome.trim()) {
            return res.redirect('/admin/dashboard');
        }

        try {
            await db.query('INSERT INTO categorias (nome) VALUES (?)', [nome.trim()]);
            res.redirect('/admin/dashboard');
        } catch (error) {
            console.error('Erro ao cadastrar categoria:', error);
            res.status(500).send('Erro interno ao cadastrar categoria.');
        }
    },

    updateCategory: async (req, res) => {
        const { id } = req.params;
        const { nome } = req.body;

        if (!nome || !nome.trim()) {
            return res.redirect('/admin/dashboard');
        }

        try {
            await db.query('UPDATE categorias SET nome = ? WHERE id = ?', [nome.trim(), id]);
            res.redirect('/admin/dashboard');
        } catch (error) {
            console.error('Erro ao atualizar categoria:', error);
            res.status(500).send('Erro interno ao atualizar categoria.');
        }
    },

    deleteCategory: async (req, res) => {
        const { id } = req.params;

        try {
            await db.query('UPDATE produtos SET id_categoria = NULL WHERE id_categoria = ?', [id]);
            await db.query('DELETE FROM categorias WHERE id = ?', [id]);
            res.redirect('/admin/dashboard');
        } catch (error) {
            console.error('Erro ao excluir categoria:', error);
            res.status(500).send('Erro interno ao excluir categoria.');
        }
    }
};

module.exports = adminController;