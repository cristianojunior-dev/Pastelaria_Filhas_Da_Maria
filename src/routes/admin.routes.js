const express = require('express');
const router = express.Router();
const adminController = require('../controllers/admin.controller');
const upload = require('../config/multer');

// Middleware de proteção de rota: Garante que apenas administradores acessem
router.use((req, res, next) => {
    if (req.session && req.session.usuarioLogado && req.session.userAdmin) {
        return next();
    }
    res.redirect('/');
});

// Rota principal do painel administrativo
router.get('/dashboard', adminController.renderDashboard);

// Rotas de Produtos
router.post('/products/add', upload.single('imagem'), adminController.addProduct);
router.post('/products/delete/:id', adminController.deleteProduct);
router.post('/products/edit/:id', upload.single('imagem'), adminController.updateProduct);
router.get('/products/ingredients/:id', adminController.getProductIngredients);

// Rota de Pedidos
router.post('/orders/update-status/:id', adminController.updateOrderStatus);


// Rota de Ingredientes
router.post('/ingredients/add', adminController.addIngredient);
router.post('/ingredients/edit/:id', adminController.updateIngredient);
router.post('/ingredients/toggle/:id', adminController.toggleIngredientStatus);
router.post('/ingredients/delete/:id', adminController.deleteIngredient);

// Rotas de Gerenciamento de Categorias
router.post('/categories/add', adminController.addCategory);
router.post('/categories/edit/:id', adminController.updateCategory);
router.post('/categories/delete/:id', adminController.deleteCategory);

module.exports = router;