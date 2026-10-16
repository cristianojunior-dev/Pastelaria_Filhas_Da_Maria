const express = require('express');
const router = express.Router();
const adminController = require('../controllers/admin.controller');
const upload = require('../config/multer');

router.use((req, res, next) => {
    if (req.session && req.session.usuarioLogado && req.session.userAdmin) {
        return next();
    }
    res.redirect('/');
});

router.get('/dashboard', adminController.renderDashboard);

router.post('/products/add', upload.single('imagem'), adminController.addProduct);

router.post('/orders/update-status/:id', adminController.updateOrderStatus);

router.post('/ingredients/toggle/:id', adminController.toggleIngredientStatus);

router.post('/products/delete/:id', adminController.deleteProduct);

router.post('/products/edit/:id', upload.single('imagem'), adminController.updateProduct);

router.post('/categories/add', adminController.addCategory);

router.post('/categories/edit/:id', adminController.updateCategory);

router.post('/categories/delete/:id', adminController.deleteCategory);

module.exports = router;