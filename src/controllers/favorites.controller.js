const db = require('../config/db');

const favoritesController = {
    // Lista os favoritos do usuário logado
    getFavorites: async (req, res) => {
        const usuarioId = req.session.usuarioId;

        try {
            // Busca os produtos favoritados fazendo um JOIN com a tabela produtos
            const [produtos] = await db.query(
                `SELECT p.* FROM produtos p
                 INNER JOIN favoritos f ON f.id_produto = p.id
                 WHERE f.id_usuario = ?`,
                [usuarioId]
            );

            res.render('favoritos', {
                cssPage: 'favoritos',
                produtos: produtos,
                usuarioLogado: req.session.usuarioLogado || false,
                usuarioNome: req.session.usuarioNome || null,
                userAdmin: req.session.userAdmin || false
            });

        } catch (error) {
            console.error('Erro ao buscar favoritos:', error);
            res.status(500).send('Erro interno ao carregar favoritos.');
        }
    },

    addFavorite: async (req, res) => {
        const { id } = req.params;
        const usuarioId = req.session.usuarioId;

        try {
            // Verifica se o item já foi favoritado por este usuário para não duplicar
            const [rows] = await db.query(
                'SELECT id FROM favoritos WHERE id_usuario = ? AND id_produto = ?',
                [usuarioId, id]
            );

            if (rows.length === 0) {
                // Insere o vínculo físico na tabela de favoritos do MySQL
                await db.query(
                    'INSERT INTO favoritos (id_usuario, id_produto) VALUES (?, ?)',
                    [usuarioId, id]
                );
            }

            // Redireciona o usuário para a página de favoritos com o item adicionado
            res.redirect('/favorites');

        } catch (error) {
            console.error('Erro ao adicionar favorito:', error);
            res.status(500).send('Erro interno ao favoritar o produto.');
        }
    },

    // Remove um produto dos favoritos
    removeFavorite: async (req, res) => {
        const { id } = req.params;
        const usuarioId = req.session.usuarioId;

        try {
            await db.query('DELETE FROM favoritos WHERE id_usuario = ? AND id_produto = ?', [usuarioId, id]);
            res.redirect('/favorites');
        } catch (error) {
            console.error('Erro ao remover favorito:', error);
            res.status(500).send('Erro ao processar a remoção.');
        }
    }
};

module.exports = favoritesController;