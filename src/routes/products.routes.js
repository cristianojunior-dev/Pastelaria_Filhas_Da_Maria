const express = require('express');
const router = express.Router();
const productsController = require('../controllers/products.controller');

// Rota para processar a busca (Acessível em /products/search?q=termo)
router.get('/search', productsController.searchProducts);

// Rota dinâmica para exibir os detalhes por ID
router.get('/:id', productsController.getProductDetail);

module.exports = router;