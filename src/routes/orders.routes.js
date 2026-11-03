const express = require('express');
const router = express.Router();
const ordersController = require('../controllers/orders.controller');
const authMiddleware = require('../middlewares/auth.middleware');

// Rota protegida: garante que o usuário esteja logado antes de carregar o histórico de pedidos
router.get('/pedidos', authMiddleware, ordersController.getMeusPedidos);

module.exports = router;
