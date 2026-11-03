const db = require('../config/db');

const ordersController = {
    getMeusPedidos: async (req, res) => {
        const usuarioId = req.session.usuarioId;
        const { data_inicio, data_fim } = req.query; // Captura os filtros por período da URL

        try {
            // Base da busca de todos os pedidos deste cliente específico
            let query = `
                SELECT id, codigo, status, total_pedido, taxa_entrega, forma_pagamento, data, cep
                FROM pedidos
                WHERE id_usuario = ?
            `;
            const queryParams = [usuarioId];

            // Injeta os filtros de período dinamicamente se as datas forem fornecidas
            if (data_inicio && data_fim) {
                query += ` AND data BETWEEN ? AND ?`;
                queryParams.push(`${data_inicio} 00:00:00`, `${data_fim} 23:59:59`);
            } else if (data_inicio) {
                query += ` AND data >= ?`;
                queryParams.push(`${data_inicio} 00:00:00`);
            } else if (data_fim) {
                query += ` AND data <= ?`;
                queryParams.push(`${data_fim} 23:59:59`);
            }

            // Mantém a ordenação do mais recente para o mais antigo
            query += ` ORDER BY data DESC`;

            const [pedidosRows] = await db.query(query, queryParams);
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
                    id: p.codigo, // Exibe o código amigável no lugar do ID sequencial
                    status: p.status,
                    data: dataObj.toLocaleString('pt-BR'), // Ajustado para o padrão brasileiro
                    endereco: p.cep, 
                    total: (parseFloat(p.total_pedido) + parseFloat(p.taxa_entrega)).toFixed(2),
                    itens: itensRows
                });
            }

            res.render('pedidos', {
                cssPage: 'pedidos',
                pedidos: pedidos,
                filtros: { data_inicio, data_fim }, // Retorna as datas para manter os inputs preenchidos
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
