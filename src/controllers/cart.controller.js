const db = require('../config/db');

const cartController = {
    // Exibe a página do carrinho (Páginas 5 e 14 do Figma)
    renderCart: (req, res) => {
        // Inicializa o carrinho na sessão se não existir
        if (!req.session.cart) {
            req.session.cart = [];
        }

        const itens = req.session.cart;

        // Calcula o total unificado somando o subtotal de cada pastel/bebida
        let total = 0;
        itens.forEach(item => {
            total += parseFloat(item.subtotal);
        });

        res.render('carrinho', {
            cssPage: 'carrinho',
            itens: itens,
            total: total.toFixed(2),
            usuarioLogado: req.session.usuarioLogado || false,
            usuarioNome: req.session.usuarioNome || null,
            userAdmin: req.session.userAdmin || false
        });
    },

    // Adiciona um item ao carrinho (Vindo da Home ou Detalhes do Produto)
    addItem: async (req, res) => {
        const { id } = req.params;
        const quantidade = parseInt(req.body.quantidade) || 1;

        if (!req.session.cart) {
            req.session.cart = [];
        }

        try {
            // Busca os dados do produto no banco de dados
            const [rows] = await db.query('SELECT * FROM produtos WHERE id = ?', [id]);
            if (rows.length === 0) {
                return res.status(404).send('Produto não encontrado.');
            }

            const produto = rows[0];

            // Verifica se o item já existe no carrinho da sessão
            const itemExistente = req.session.cart.find(item => item.id === parseInt(id));

            if (itemExistente) {
                // Atualiza a quantidade e o subtotal se o pastel já estiver lá
                itemExistente.quantidade += quantidade;
                itemExistente.subtotal = (itemExistente.quantidade * parseFloat(produto.preco)).toFixed(2);
            } else {
                // Insere um novo item no carrinho
                req.session.cart.push({
                    id: produto.id,
                    nome: produto.nome,
                    preco: parseFloat(produto.preco).toFixed(2),
                    descricao: produto.descricao,
                    imagem: produto.imagem,
                    quantidade: quantidade,
                    subtotal: (quantidade * parseFloat(produto.preco)).toFixed(2)
                });
            }

            // Redireciona o usuário para visualizar o carrinho
            res.redirect('/cart');

        } catch (error) {
            console.error('Erro ao adicionar item ao carrinho:', error);
            res.status(500).send('Erro interno no servidor.');
        }
    },

    // Atualiza a quantidade via botões + e - da tela do carrinho
    updateItem: (req, res) => {
        const { id } = req.params;
        const { action } = req.query; // 'plus' ou 'minus'

        if (!req.session.cart) return res.redirect('/cart');

        const item = req.session.cart.find(item => item.id === parseInt(id));

        if (item) {
            if (action === 'plus') {
                item.quantidade += 1;
            } else if (action === 'minus') {
                item.quantidade -= 1;
            }

            // Se a quantidade chegar a 0, removemos o produto automaticamente
            if (item.quantidade <= 0) {
                req.session.cart = req.session.cart.filter(i => i.id !== parseInt(id));
            } else {
                item.subtotal = (item.quantidade * parseFloat(item.preco)).toFixed(2);
            }
        }

        res.redirect('/cart');
    },

    // Remove um produto específico clicando no botão REMOVER
    removeItem: (req, res) => {
        const { id } = req.params;

        if (req.session.cart) {
            req.session.cart = req.session.cart.filter(item => item.id !== parseInt(id));
        }

        res.redirect('/cart');
    },

    // Limpa o carrinho por inteiro clicando em "limpar carrinho"
    clearCart: (req, res) => {
        req.session.cart = [];
        res.redirect('/cart');
    }
};

module.exports = cartController;