const db = require('../config/db');
const bcrypt = require('bcrypt');

const authController = {
    // Exibe a tela de cadastro
    renderRegister: (req, res) => {
        res.render('register', { cssPage: 'register' });
    },

    // Processa os dados enviados pelo formulário de cadastro
    register: async (req, res) => {
        const { nome, email, telefone, senha, confirme_senha } = req.body;

        // Validações básicas antes de mandar para o banco
        if (!nome || !email || !senha || !confirme_senha) {
            return res.render('register', { 
                cssPage: 'register', 
                error: 'Por favor, preencha todos os campos obrigatórios.' 
            });
        }

        if (senha !== confirme_senha) {
            return res.render('register', { 
                cssPage: 'register', 
                error: 'As senhas não coincidem.' 
            });
        }

        try {
            // Verifica se o e-mail já está cadastrado no sistema
            const [rows] = await db.query('SELECT id FROM usuario WHERE email = ?', [email]);
            if (rows.length > 0) {
                return res.render('register', { 
                    cssPage: 'register', 
                    error: 'Este e-mail já está cadastrado.' 
                });
            }

            // Criptografa a senha do cliente antes de salvar no banco
            const saltRounds = 10;
            const senhaCriptografada = await bcrypt.hash(senha, saltRounds);

            // Insere o usuário no banco de dados
            await db.query(
                'INSERT INTO usuario (nome, email, telefone, senha, tipo_usuario) VALUES (?, ?, ?, ?, ?)',
                [nome, email, telefone || null, senhaCriptografada, 'cliente']
            );

            // Se tudo deu certo, exibe mensagem de sucesso
            return res.render('register', { 
                cssPage: 'register', 
                success: 'Cadastro realizado com sucesso! Você já pode se conectar.' 
            });

        } catch (error) {
            console.error('Erro no cadastro:', error);
            return res.render('register', { 
                cssPage: 'register', 
                error: 'Ocorreu um erro interno no servidor. Tente novamente mais tarde.' 
            });
        }
    },

    // Exibe a tela de login
    renderLogin: (req, res) => {
        res.render('login', { cssPage: 'login' });
    },

    // Processa os dados de login enviados pelo formulário
    login: async (req, res) => {
        const { email, senha } = req.body;

        if (!email || !senha) {
            return res.render('login', { 
                cssPage: 'login', 
                error: 'Por favor, preencha todos os campos.' 
            });
        }

        try {
            // Busca o usuário pelo e-mail informado
            const [rows] = await db.query('SELECT * FROM usuario WHERE email = ?', [email]);
            if (rows.length === 0) {
                return res.render('login', { 
                    cssPage: 'login', 
                    error: 'E-mail ou senha incorretos.' 
                });
            }

            const usuario = rows[0];

            // Compara a senha digitada com a criptografada armazenada no banco
            const senhaValida = await bcrypt.compare(senha, usuario.senha);
            if (!senhaValida) {
                return res.render('login', { 
                    cssPage: 'login', 
                    error: 'E-mail ou senha incorretos.' 
                });
            }

            // Salva os dados do usuário na sessão do Express
            req.session.usuarioLogado = true;
            req.session.usuarioId = usuario.id;
            req.session.userAdmin = usuario.tipo_usuario === 'admin';
            req.session.usuarioNome = usuario.nome;

            // Redireciona o usuário para a página principal (Home)
            return res.redirect('/');

        } catch (error) {
            console.error('Erro no login:', error);
            return res.render('login', { 
                cssPage: 'login', 
                error: 'Ocorreu um erro interno no servidor.' 
            });
        }
    },

    // Destrói a sessão ao deslogar
    logout: (req, res) => {
        req.session.destroy((err) => {
            if (err) {
                console.error('Erro ao sair:', err);
            }
            res.redirect('/');
        });
    }
};

module.exports = authController;