function gerarCodigoPedido() {
    const data = new Date();
    const ano = data.getFullYear();
    const mes = String(data.getMonth() + 1).padStart(2, '0');
    const dia = String(data.getDate()).padStart(2, '0');
    const aleatorio = Math.floor(1000 + Math.random() * 9000); // 4 dígitos aleatórios
    
    return `PFM-${ano}${mes}${dia}-${aleatorio}`;
}

module.exports = gerarCodigoPedido;