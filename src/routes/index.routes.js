const express = require('express');
const router = express.Router();
const indexController = require('../controllers/index.controller');

// Rota para a Página Home Principal (Páginas 4 e 12 do Figma)
router.get('/', indexController.renderHome);

// Atalho caso o usuário digite explicitamente /home
router.get('/home', indexController.renderHome);

router.get('/about', indexController.renderSobre);

module.exports = router;