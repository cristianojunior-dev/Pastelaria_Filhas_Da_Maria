const express = require('express');
const router = express.Router();
const ordersController = require('../controllers/orders.controller');
const authMiddleware = require('../middlewares/auth.middleware');

// Rota protegida: obriga o utilizador a estar ligado para ver os pedidos
router.get('/', authMiddleware, ordersController.getMeusPedidos);

module.exports = router;