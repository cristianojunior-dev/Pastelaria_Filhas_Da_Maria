const express = require('express');
const router = express.Router();
const adminController = require('../controllers/admin.controller');
const upload = require('../config/multer');

// Middleware de proteção de rota: Garante que apenas administradores acessem
router.use((req, res, next) => {
    if (req.session && req.session.usuarioLogado && req.session.userAdmin) {
        return next();
    }
    // Se não for admin, bloqueia o acesso e manda de volta pra Home
    res.redirect('/');
});

// Rota principal do painel administrativo
router.get('/dashboard', adminController.renderDashboard);

// Rota POST para cadastrar o produto (Interceptada pelo Multer para receber a foto 'imagem')
router.post('/products/add', upload.single('imagem'), adminController.addProduct);

// Rota POST para avançar o status na fila do delivery
router.post('/orders/update-status/:id', adminController.updateOrderStatus);

// Rota POST para alternar o estoque do ingrediente (Aba 4)
router.post('/ingredients/toggle/:id', adminController.toggleIngredientStatus);

// Rota POST para deletar um produto do cardápio (Aba 3)
router.post('/products/delete/:id', adminController.deleteProduct);

// Rota POST que recebe os dados do Modal de Edição (Aba 3)
router.post('/products/edit/:id', upload.single('imagem'), adminController.updateProduct);

module.exports = router;