const express = require('express');
const path = require('path');
const exphbs = require('express-handlebars');
const cookieParser = require('cookie-parser');
const session = require('express-session');

const MySQLStore = require('express-mysql-session')(session);

// Importação das Rotas do Sistema
const indexRoutes = require('./routes/index.routes');
const authRoutes = require('./routes/auth.routes');
const productsRoutes = require('./routes/products.routes');
const cartRoutes = require('./routes/cart.routes');
const checkoutRoutes = require('./routes/checkout.routes');
const favoritesRoutes = require('./routes/favorites.routes');
const adminRoutes = require('./routes/admin.routes');
const ordersRoutes = require('./routes/orders.routes');

// Configuração da ligação com o banco do env
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

app.use((req, res, next) => {
    console.log(`[REQ] ${new Date().toISOString()} -> ${req.method} ${req.url}`);
    next();
});

// Middlewares para leitura e processamento de dados de formulários
app.use(express.urlencoded({ extended: true }));
app.use(express.json());

// Middlewares para Controle de Cookies e Sessão do Usuário
app.use(cookieParser());


app.use(session({
    secret: process.env.SESSION_SECRET || 'segredo_pastelaria_filhas_maria',
    store: sessionStore,
    resave: false,
    saveUninitialized: false,
    cookie: {
        maxAge: 1000 * 60 * 15 // Sessão ativa por 15 minutos
    }
}));

// Middleware Global de Sessão para o Handlebars
app.use((req, res, next) => {
    res.locals.usuarioLogado = req.session.usuarioLogado || false;
    res.locals.usuarioNome = req.session.usuarioNome || null;
    res.locals.userAdmin = req.session.userAdmin || false;
    next();
});

// Definição das Pastas de Arquivos Estáticos
app.use(express.static(path.join(__dirname, '..', 'public')));
app.use('/uploads', express.static(path.join(__dirname, '..', 'uploads')));

// Configuração e Conexão da Template Engine
app.engine('handlebars', exphbs.engine({
    defaultLayout: 'main',
    layoutsDir: path.join(__dirname, '..', 'views', 'layouts'),
    partialsDir: path.join(__dirname, '..', 'views', 'partials'),
    helpers: {
        gt: (v1, v2) => v1 > v2,
        math: (lvalue, operator, rvalue) => {
            lvalue = parseFloat(lvalue);
            rvalue = parseFloat(rvalue);
            return {
                "-": lvalue - rvalue
            }[operator];
        }
    }
}));
app.set('view engine', 'handlebars');
app.set('views', path.join(__dirname, '..', 'views'));

// Ativação das Rotas com seus Respectivos Prefixos Globais
app.use('/', indexRoutes);
app.use('/', ordersRoutes);
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
