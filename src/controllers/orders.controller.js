const db = require('../config/db');

const ordersController = {
    getMeusPedidos: async (req, res) => {
        const usuarioId = req.session.usuarioId;

        try {
            // Busca todos os pedidos deste cliente
            const [pedidosRows] = await db.query(
                `SELECT id, codigo, status, total_pedido, taxa_entrega, forma_pagamento, data, cep
                 FROM pedidos
                 WHERE id_usuario = ?
                 ORDER BY data DESC`,
                [usuarioId]
            );

            const pedidos = [];
            
            // Para cada pedido, busca os produtos (itens) que foram comprados
            for (const p of pedidosRows) {
                const dataObj = new Date(p.data);

                const [itensRows] = await db.query(
                    `SELECT pi.quantidade, pi.preco_unitario as preco, pr.nome, pr.imagem
                     FROM pedido_itens pi
                     INNER JOIN produtos pr ON pi.id_produto = pr.id
                     WHERE pi.id_pedido = ?`,
                    [p.id]
                );

                pedidos.push({
                    id: p.codigo, // Mostramos o código no lugar do ID para ficar mais bonito
                    status: p.status,
                    data: dataObj.toLocaleString('pt-PT'), // Formato de data e hora
                    endereco: p.cep, 
                    total: (parseFloat(p.total_pedido) + parseFloat(p.taxa_entrega)).toFixed(2),
                    itens: itensRows
                });
            }

            res.render('pedidos', {
                cssPage: 'pedidos',
                pedidos: pedidos,
                usuarioLogado: req.session.usuarioLogado || false,
                usuarioNome: req.session.usuarioNome || null,
                userAdmin: req.session.userAdmin || false
            });
        } catch (error) {
            console.error('Erro ao buscar pedidos:', error);
            res.status(500).send('Erro interno ao carregar os pedidos.');
        }
    }
};

module.exports = ordersController;