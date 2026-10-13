const express = require('express');
const router = express.Router();
const cartController = require('../controllers/cart.controller');

// Rota para visualizar o carrinho
router.get('/', cartController.renderCart);

// Rota POST para adicionar um pastel ao carrinho
router.post('/add/:id', cartController.addItem);

// Rota POST para atualizar quantidade (+ ou -)
router.post('/update/:id', cartController.updateItem);

// Rota POST para remover um item específico
router.post('/remove/:id', cartController.removeItem);

// Rota POST para limpar o carrinho inteiro
router.post('/clear', cartController.clearCart);

module.exports = router;