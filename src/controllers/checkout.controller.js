const db = require('../config/db');
const gerarCodigoPedido = require('../utils/gerarCodigoPedido');

const checkoutController = {
    // Renderiza a página de resumo do pedido (Páginas 6 a 10 do Figma)
    renderCheckout: (req, res) => {
        const itens = req.session.cart || [];

        // Se o carrinho estiver vazio, impede o checkout e manda de volta pro carrinho
        if (itens.length === 0) {
            return res.redirect('/cart');
        }

        // Calcula os valores dinamicamente
        let totalPedido = 0;
        itens.forEach(item => {
            totalPedido += parseFloat(item.subtotal);
        });

        const taxaEntrega = 5.00; // Taxa de entrega unificada fixa do Figma
        const totalGeral = totalPedido + taxaEntrega;

        res.render('checkout', {
            cssPage: 'checkout',
            itens: itens,
            totalPedido: totalPedido.toFixed(2),
            taxaEntrega: taxaEntrega.toFixed(2),
            totalGeral: totalGeral.toFixed(2),
            usuarioLogado: req.session.usuarioLogado || false,
            usuarioNome: req.session.usuarioNome || null,
            userAdmin: req.session.userAdmin || false
        });
    },

    // Processa o formulário de finalização do pedido gravando tudo no MySQL
    finalizarPedido: async (req, res) => {
        const { cep, forma_pagamento, troco } = req.body;
        const itens = req.session.cart || [];
        const usuarioId = req.session.usuarioId;

        if (itens.length === 0) return res.redirect('/cart');

        try {
            // Recalcula os totais para gravação segura no banco
            let totalPedido = 0;
            itens.forEach(item => {
                totalPedido += parseFloat(item.subtotal);
            });
            const taxaEntrega = 5.00;

            const codigoPedido = gerarCodigoPedido();
            
            // Registra observação de troco se houver
            let pagamentoFinal = forma_pagamento;
            if (forma_pagamento === 'Dinheiro' && troco) {
                pagamentoFinal = `Dinheiro (${troco})`;
            }

            // 1. Insere o pedido na tabela principal 'pedidos'
            const [resultPedido] = await db.query(
                `INSERT INTO pedidos (id_usuario, codigo, status, total_pedido, taxa_entrega, forma_pagamento, cep) 
                 VALUES (?, ?, ?, ?, ?, ?, ?)`,
                [usuarioId, codigoPedido, 'recebido', totalPedido, taxaEntrega, pagamentoFinal, cep]
            );

            const pedidoId = resultPedido.insertId;

            // 2. Insere cada item do carrinho na tabela relacional 'pedido_itens'
            for (const item of itens) {
                await db.query(
                    `INSERT INTO pedido_itens (id_pedido, id_produto, quantidade, preco_unitario) 
                     VALUES (?, ?, ?, ?)`,
                    [pedidoId, item.id, item.quantidade, item.preco]
                );
            }

            // 3. Limpa o carrinho da sessão após o pedido ser salvo com sucesso
            req.session.cart = [];

            // 4. Renderiza a tela de sucesso com o resumo final
            res.render('pedido_finalizado', {
                codigoPedido: codigoPedido,
                totalGeral: (totalPedido + taxaEntrega).toFixed(2),
                formaPagamento: pagamentoFinal,
                usuarioLogado: req.session.usuarioLogado || false,
                usuarioNome: req.session.usuarioNome || null,
                userAdmin: req.session.userAdmin || false
            });

        } catch (error) {
            console.error('Erro ao finalizar o pedido:', error);
            res.status(500).send('Erro interno ao processar o seu pedido.');
        }
    }
};

module.exports = checkoutController;