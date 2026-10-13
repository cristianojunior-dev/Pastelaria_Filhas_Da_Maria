const authMiddleware = (req, res, next) => {
    if (req.session && req.session.usuarioLogado) {
        return next(); 
    }
    return res.render('login', {
        cssPage: 'login',
        error: 'Você precisa estar conectado em uma conta para realizar esta ação.'
    });
};

module.exports = authMiddleware;