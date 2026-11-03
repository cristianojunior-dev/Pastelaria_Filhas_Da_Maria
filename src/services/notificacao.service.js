const nodemailer = require('nodemailer');

const transporter = nodemailer.createTransport({
    host: process.env.EMAIL_HOST,
    port: process.env.EMAIL_PORT,
    secure: false,
    auth: {
        user: process.env.EMAIL_USER,
        pass: process.env.EMAIL_PASS
    }
});

module.exports = {
    enviarEmail: async (destinatario, assunto, mensagemTexto, mensagemHtml) => {
        try {
            await transporter.sendMail({
                from: `"Pastelaria Filhas da Maria" <${process.env.EMAIL_USER}>`,
                to: destinatario,
                subject: assunto,
                text: mensagemTexto,
                html: mensagemHtml 
            });
            console.log(`[Nodemailer] E-mail enviado com sucesso para: ${destinatario}`);
        } catch (error) {
            console.error('Erro ao enviar e-mail:', error);
        }
    }
};