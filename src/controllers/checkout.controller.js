const db = require('../config/db');
const gerarCodigoPedido = require('../utils/gerarCodigoPedido');

const checkoutController = {
    // Renderiza a página de resumo do pedido + endereços salvos do usuário
    renderCheckout: async (req, res) => {
        const itens = req.session.cart || [];
        const usuarioId = req.session.usuarioId;

        if (itens.length === 0) {
            return res.redirect('/cart');
        }

        try {
            let totalPedido = 0;
            itens.forEach(item => {
                totalPedido += parseFloat(item.subtotal);
            });

            const taxaEntrega = 5.00;
            const totalGeral = totalPedido + taxaEntrega;

            // Busca todos os endereços já salvos por este usuário
            const [enderecosSalvos] = await db.query(
                'SELECT * FROM enderecos WHERE id_usuario = ? ORDER BY id DESC',
                [usuarioId]
            );

            res.render('checkout', {
                cssPage: 'checkout',
                itens: itens,
                enderecos: enderecosSalvos,
                temEnderecos: enderecosSalvos.length > 0,
                totalPedido: totalPedido.toFixed(2),
                taxaEntrega: taxaEntrega.toFixed(2),
                totalGeral: totalGeral.toFixed(2),
                usuarioLogado: req.session.usuarioLogado || false,
                usuarioNome: req.session.usuarioNome || null,
                userAdmin: req.session.userAdmin || false
            });
        } catch (error) {
            console.error('Erro ao carregar o checkout:', error);
            res.status(500).send('Erro interno ao carregar o checkout.');
        }
    },

    // Remove um endereço salvo do usuário e recarrega o checkout
    removerEndereco: async (req, res) => {
        const { id } = req.params;
        const usuarioId = req.session.usuarioId;

        try {
            // O "AND id_usuario = ?" garante que um usuário só possa deletar o próprio endereço
            await db.query('DELETE FROM enderecos WHERE id = ? AND id_usuario = ?', [id, usuarioId]);
            res.redirect('/checkout');
        } catch (error) {
            console.error('Erro ao remover endereço:', error);
            res.status(500).send('Erro ao remover endereço.');
        }
    },

    // Processa o formulário de finalização do pedido
    finalizarPedido: async (req, res) => {
        const { endereco_selecionado, cep, rua, numero, bairro, cidade, uf, forma_pagamento, troco } = req.body;
        const itens = req.session.cart || [];
        const usuarioId = req.session.usuarioId;

        if (itens.length === 0) return res.redirect('/cart');

        try {
            let enderecoCompleto = '';

            // CENÁRIO 1: Usuário escolheu um endereço que já estava salvo
            if (endereco_selecionado && endereco_selecionado !== 'novo') {
                const [endRows] = await db.query(
                    'SELECT * FROM enderecos WHERE id = ? AND id_usuario = ?',
                    [endereco_selecionado, usuarioId]
                );

                if (endRows.length === 0) {
                    return res.status(400).send('Endereço selecionado não encontrado.');
                }

                const end = endRows[0];
                enderecoCompleto = `${end.rua}, Nº ${end.numero} - ${end.bairro}, ${end.cidade}/${end.uf} (CEP: ${end.cep})`;
            } 
            // CENÁRIO 2: Usuário escolheu cadastrar um novo endereço
            else {
                if (!cep || !rua || !numero || !bairro || !cidade || !uf) {
                    return res.status(400).send('Preencha todos os campos do novo endereço.');
                }

                // Verifica se o usuário já não tem exatamente esse CEP + Número salvo para evitar duplicatas
                const [existeRows] = await db.query(
                    'SELECT id FROM enderecos WHERE id_usuario = ? AND cep = ? AND numero = ?',
                    [usuarioId, cep, numero]
                );

                if (existeRows.length === 0) {
                    await db.query(
                        `INSERT INTO enderecos (id_usuario, cep, rua, numero, bairro, cidade, uf)
                         VALUES (?, ?, ?, ?, ?, ?, ?)`,
                        [usuarioId, cep, rua, numero, bairro, cidade, uf]
                    );
                }

                enderecoCompleto = `${rua}, Nº ${numero} - ${bairro}, ${cidade}/${uf} (CEP: ${cep})`;
            }

            // Calcula os totais
            let totalPedido = 0;
            itens.forEach(item => {
                totalPedido += parseFloat(item.subtotal);
            });

            const taxaEntrega = 5.00;
            const codigoPedido = gerarCodigoPedido();
            
            let pagamentoFinal = forma_pagamento;
            if (forma_pagamento === 'Dinheiro' && troco) {
                pagamentoFinal = `Dinheiro (${troco})`;
            }

            // 1. Insere o pedido na tabela 'pedidos'
            const [resultPedido] = await db.query(
                `INSERT INTO pedidos (id_usuario, codigo, status, total_pedido, taxa_entrega, forma_pagamento, cep) 
                 VALUES (?, ?, ?, ?, ?, ?, ?)`,
                [usuarioId, codigoPedido, 'recebido', totalPedido, taxaEntrega, pagamentoFinal, enderecoCompleto]
            );

            const pedidoId = resultPedido.insertId;

            // 2. Insere cada item na tabela 'pedido_itens'
            for (const item of itens) {
                await db.query(
                    `INSERT INTO pedido_itens (id_pedido, id_produto, quantidade, preco_unitario) 
                     VALUES (?, ?, ?, ?)`,
                    [pedidoId, item.id, item.quantidade, item.preco]
                );
            }

            // 3. Limpa o carrinho da sessão
            req.session.cart = [];

            // 4. Renderiza a tela de pedido finalizado exibindo o endereço escolhido/cadastrado
            res.render('pedido_finalizado', {
                codigoPedido: codigoPedido,
                totalGeral: (totalPedido + taxaEntrega).toFixed(2),
                formaPagamento: pagamentoFinal,
                enderecoEntrega: enderecoCompleto,
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