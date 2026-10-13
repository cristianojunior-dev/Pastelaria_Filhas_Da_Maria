const upload = require('../config/multer');

module.exports = {
    uploadImagemProduto: upload.single('imagem')
};