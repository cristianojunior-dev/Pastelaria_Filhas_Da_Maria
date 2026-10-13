const express = require('express');
const router = express.Router();
const authController = require('../controllers/auth.controller');

// Rotas para a Tela de Cadastro (Página 2 do Figma)
router.get('/register', authController.renderRegister);
router.post('/register', authController.register);

// Rotas para a Tela de Login (Página 1 do Figma)
router.get('/login', authController.renderLogin);
router.post('/login', authController.login);

// Rota para desconectar o usuário
router.get('/logout', authController.logout);

module.exports = router;