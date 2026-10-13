const db = require('../config/db');

const indexController = {
    renderHome: async (req, res) => {
        try {
            // 1. Busca todas as categorias cadastradas no banco
            const [categorias] = await db.query('SELECT * FROM categorias');

            // 2. Cria uma estrutura para agrupar produtos por categoria
            const cardapio = [];

            for (const categoria of categorias) {
                // Busca os produtos pertencentes a esta categoria
                const [produtos] = await db.query(
                    'SELECT * FROM produtos WHERE id_categoria = ?', 
                    [categoria.id]
                );

                const produtosProcessados = [];

                // Para cada produto, verifica se TODOS os ingredientes estão em estoque
                for (const produto of produtos) {
                    const [ingredientes] = await db.query(
                        `SELECT i.em_estoque 
                         FROM ingredientes i
                         INNER JOIN produto_ingredientes pi ON pi.id_ingrediente = i.id
                         WHERE pi.id_produto = ?`,
                        [produto.id]
                    );

                    // Se algum ingrediente tiver 'em_estoque = 0', o produto fica indisponível
                    // Se não tiver nenhum ingrediente cadastrado, por padrão fica disponível (true)
                    const disponivel = ingredientes.every(ing => ing.em_estoque === 1);

                    produtosProcessados.push({
                        ...produto,
                        disponivel: disponivel
                    });
                }

                // Só adiciona a categoria ao cardápio se ela possuir produtos cadastrados
                if (produtosProcessados.length > 0) {
                    cardapio.push({
                        id_categoria: categoria.id,
                        categoria: categoria.nome,
                        produtos: produtosProcessados
                    });
                }
            }

            // 3. Busca os produtos de destaque para o Carrossel (Mais Pedidos)
            // Traz até 4 itens cadastrados no cardápio para rodar nos slides
            const [produtosDestaqueRows] = await db.query(
                "SELECT * FROM produtos LIMIT 4"
            );
            const maisPedidos = produtosDestaqueRows.length > 0 ? produtosDestaqueRows : null;

            // 4. Renderiza a página Home injetando a nova variável de lista
            res.render('home', {
                cssPage: 'home',
                cardapio: cardapio,
                maisPedidos: maisPedidos, // Envia a lista para o loop {{#each}} do carrossel
                usuarioLogado: req.session.usuarioLogado || false,
                usuarioNome: req.session.usuarioNome || null,
                userAdmin: req.session.userAdmin || false
            });

        } catch (error) {
            console.error('Erro ao carregar a Home:', error);
            res.status(500).send('Erro interno ao carregar o cardápio.');
        }
    }
};

module.exports = indexController;