const express = require('express');
const router = express.Router();
const authController = require('../controllers/auth.controller');

// Rotas para a Tela de Cadastro
router.get('/register', authController.renderRegister);
router.post('/register', authController.register);

// Rotas para a Tela de Login
router.get('/login', authController.renderLogin);
router.post('/login', authController.login);

// Rota para desconectar o usuário
router.get('/logout', authController.logout);

module.exports = router;