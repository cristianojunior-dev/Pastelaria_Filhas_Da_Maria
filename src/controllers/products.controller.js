const db = require('../config/db');

const productsController = {
    // Exibe os detalhes de um produto específico (Páginas 3 e 13 do Figma)
    getProductDetail: async (req, res) => {
        const { id } = req.params;

        try {
            const [productRows] = await db.query(
                `SELECT p.*, GROUP_CONCAT(i.nome SEPARATOR ', ') AS ingredientes_lista
                 FROM produtos p
                 LEFT JOIN produto_ingredientes pi ON pi.id_produto = p.id
                 LEFT JOIN ingredientes i ON pi.id_ingrediente = i.id
                 WHERE p.id = ?
                 GROUP BY p.id`,
                [id]
            );

            if (productRows.length === 0) {
                return res.status(404).send('Produto não encontrado.');
            }

            const produto = productRows[0];

            const [ingredientesEstoque] = await db.query(
                `SELECT i.em_estoque 
                 FROM ingredientes i
                 INNER JOIN produto_ingredientes pi ON pi.id_ingrediente = i.id
                 WHERE pi.id_produto = ?`,
                [id]
            );
            
            produto.disponivel = ingredientesEstoque.every(ing => ing.em_estoque === 1);

            const [recRows] = await db.query(
                'SELECT * FROM produtos WHERE id_categoria = ? AND id != ? LIMIT 5',
                [produto.id_categoria, id]
            );

            const recomendacoes = [];
            for (const rec of recRows) {
                const [recIngredientes] = await db.query(
                    `SELECT i.em_estoque 
                     FROM ingredientes i
                     INNER JOIN produto_ingredientes pi ON pi.id_ingrediente = i.id
                     WHERE pi.id_produto = ?`,
                    [rec.id]
                );
                
                recomendacoes.push({
                    ...rec,
                    disponivel: recIngredientes.every(ing => ing.em_estoque === 1)
                });
            }

            res.render('produto', {
                cssPage: 'produto',
                produto: produto,
                recomendacoes: recomendacoes,
                usuarioLogado: req.session.usuarioLogado || false,
                usuarioNome: req.session.usuarioNome || null,
                userAdmin: req.session.userAdmin || false
            });

        } catch (error) {
            console.error('Erro ao carregar detalhes do produto:', error);
            res.status(500).send('Erro interno do servidor.');
        }
    },

    // NOVA FUNÇÃO: Processa a busca digitada na barra de pesquisa
    searchProducts: async (req, res) => {
        const queryBusca = req.query.q; // Pega o termo digitado (ex: ?q=carne)

        if (!queryBusca) {
            return res.redirect('/');
        }

        try {
            // Busca produtos pelo nome ou descrição contendo o termo pesquisado
            const [produtosRows] = await db.query(
                "SELECT * FROM produtos WHERE nome LIKE ?",
                [`%${queryBusca}%`]
            );

            const produtosResultados = [];

            // Verifica a disponibilidade de estoque para cada item encontrado
            for (const produto of produtosRows) {
                const [ingredientes] = await db.query(
                    `SELECT i.em_estoque 
                     FROM ingredientes i
                     INNER JOIN produto_ingredientes pi ON pi.id_ingrediente = i.id
                     WHERE pi.id_produto = ?`,
                    [produto.id]
                );

                produtosResultados.push({
                    ...produto,
                    disponivel: ingredientes.every(ing => ing.em_estoque === 1)
                });
            }

            // Reaproveita o estilo visual da Home para exibir o grid de resultados
            res.render('home', {
                cssPage: 'home',
                termoPesquisado: queryBusca,
                resultadoBusca: produtosResultados,
                usuarioLogado: req.session.usuarioLogado || false,
                usuarioNome: req.session.usuarioNome || null,
                userAdmin: req.session.userAdmin || false
            });

        } catch (error) {
            console.error('Erro ao pesquisar produtos:', error);
            res.status(500).send('Erro interno ao processar a pesquisa.');
        }
    }
};

module.exports = productsController;