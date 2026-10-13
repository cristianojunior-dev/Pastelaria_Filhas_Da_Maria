const express = require('express');
const router = express.Router();
const favoritesController = require('../controllers/favorites.controller');
const authMiddleware = require('../middlewares/auth.middleware');

// Todas as rotas exigem login obrigatório do cliente
router.get('/', authMiddleware, favoritesController.getFavorites);
router.post('/add/:id', authMiddleware, favoritesController.addFavorite);
router.post('/remove/:id', authMiddleware, favoritesController.removeFavorite);

module.exports = router;