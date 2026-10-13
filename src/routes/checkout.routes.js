const express = require('express');
const router = express.Router();
const checkoutController = require('../controllers/checkout.controller');
const authMiddleware = require('../middlewares/auth.middleware');

// Ambas as rotas exigem obrigatoriamente que o usuário esteja logado
router.get('/', authMiddleware, checkoutController.renderCheckout);
router.post('/finalizar', authMiddleware, checkoutController.finalizarPedido);

module.exports = router;