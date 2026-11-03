const authMiddleware = (req, res, next) => {
    // Se o usuário estiver autenticado na sessão, permite a passagem para o controller
    if (req.session && req.session.usuarioLogado) {
        return next(); 
    }
    
    // Se não estiver logado, salva a mensagem de aviso na sessão temporariamente
    req.session.loginError = 'Você precisa estar conectado em uma conta para acessar esta página.';
    
    // Redireciona de forma limpa mudando a URL do navegador para a rota oficial de login
    return res.redirect('/auth/login');
};

module.exports = authMiddleware;
