const express = require('express');
const path = require('path');
const exphbs = require('express-handlebars');
const cookieParser = require('cookie-parser');
const session = require('express-session');

const MySQLStore = require('express-mysql-session')(session);

// Importação Cirúrgica das Rotas do Sistema
const indexRoutes = require('./routes/index.routes');
const authRoutes = require('./routes/auth.routes');
const productsRoutes = require('./routes/products.routes');
const cartRoutes = require('./routes/cart.routes');
const checkoutRoutes = require('./routes/checkout.routes');
const favoritesRoutes = require('./routes/favorites.routes');
const adminRoutes = require('./routes/admin.routes');
const ordersRoutes = require('./routes/orders.routes');

// Configure a ligação com o seu banco do Aiven
const sessionStore = new MySQLStore({
    host: process.env.DB_HOST,
    port: process.env.DB_PORT,
    user: process.env.DB_USER,
    password: process.env.DB_PASS,
    database: process.env.DB_NAME,
    ssl: {
        rejectUnauthorized: false
    }
});

const app = express();

app.set('trust proxy', 1); 

// Middleware de debug: Logger de requisições no console do terminal
app.use((req, res, next) => {
    console.log(`[REQ] ${new Date().toISOString()} -> ${req.method} ${req.url}`);
    next();
});

// Middlewares para leitura e processamento de dados de formulários (POST)
app.use(express.urlencoded({ extended: true }));
app.use(express.json());

// Middlewares para Controle de Cookies e Sessão do Usuário
app.use(cookieParser());

// Atualize o app.use(session(...)) que já existe no seu código para incluir o 'store'
app.use(session({
    secret: process.env.SESSION_SECRET || 'segredo_pastelaria_filhas_maria',
    store: sessionStore, // <- Esta linha faz a mágica de guardar no Aiven!
    resave: false,
    saveUninitialized: false,
    cookie: {
        maxAge: 1000 * 60 * 60 * 24 // Sessão ativa por 24 horas
    }
}));

// Middleware Global de Sessão para o Handlebars (Compartilha o estado logado com o header.handlebars)
app.use((req, res, next) => {
    res.locals.usuarioLogado = req.session.usuarioLogado || false;
    res.locals.usuarioNome = req.session.usuarioNome || null;
    res.locals.userAdmin = req.session.userAdmin || false;
    next();
});

// Definição das Pastas de Arquivos Estáticos (CSS, Imagens e Uploads)
app.use(express.static(path.join(__dirname, '..', 'public')));
app.use('/uploads', express.static(path.join(__dirname, '..', 'uploads')));

// Configuração e Conexão da Template Engine (Handlebars)
app.engine('handlebars', exphbs.engine({
    defaultLayout: 'main',
    layoutsDir: path.join(__dirname, '..', 'views', 'layouts'),
    partialsDir: path.join(__dirname, '..', 'views', 'partials')
}));
app.set('view engine', 'handlebars');
app.set('views', path.join(__dirname, '..', 'views'));

// Ativação das Rotas com seus Respectivos Prefixos Globais
app.use('/', indexRoutes);
app.use('/', ordersRoutes); // Injetado na raiz para validar a rota '/pedidos' que o cabeçalho chama
app.use('/auth', authRoutes);
app.use('/products', productsRoutes);
app.use('/cart', cartRoutes);
app.use('/checkout', checkoutRoutes);
app.use('/favorites', favoritesRoutes);
app.use('/admin', adminRoutes);

// Tratamento de Erro 404 (Rota não encontrada - Customizada)
app.use((req, res) => {
    res.status(404).render('home', {
        cssPage: 'home',
        error: 'A página que você tentou acessar não existe.'
    });
});

module.exports = app;
