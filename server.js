require('dotenv').config();
const app = require('./src/app');
const PORT = process.env.PORT || 3000;

// O '0.0.0.0' permite que dispositivos externos da mesma rede acessem o servidor
app.listen(PORT, '0.0.0.0', () => {
    console.log(`Servidor rodando na porta ${PORT}`);
    console.log(`Acesse localmente em http://localhost:${PORT}`);
    console.log(`Acesse na sua rede em http://SEU_IP_LOCAL:${PORT}`);
});
