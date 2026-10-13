const multer = require('multer');
const path = require('path');

// Configura o armazenamento do Multer
const storage = multer.diskStorage({
    destination: (req, file, cb) => {
        // As fotos enviadas pelo painel admin vão para public/images
        cb(null, path.join(__dirname, '..', '..', 'public', 'images'));
    },
    filename: (req, file, cb) => {
        // Renomeia o arquivo: timestamp-original-name (ex: 1718293847-pastel_carne.jpg)
        const uniqueSuffix = Date.now() + '-' + Math.round(Math.random() * 1E9);
        cb(null, uniqueSuffix + path.extname(file.originalname));
    }
});

// Filtro de arquivos para aceitar apenas imagens
const fileFilter = (req, file, cb) => {
    if (file.mimetype.startsWith('image/')) {
        cb(null, true);
    } else {
        cb(new Error('Apenas arquivos de imagem são permitidos!'), false);
    }
};

const upload = multer({ 
    storage: storage,
    fileFilter: fileFilter
});

module.exports = upload;