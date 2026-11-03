```markdown
# 🥟 Pastelaria Filhas da Maria - Sistema de Delivery e Gestão

Sistema web completo de delivery e gestão de pedidos desenvolvido exclusivamente para a **Pastelaria Filhas da Maria**. Construído com Node.js, Express, Handlebars e MySQL, o projeto moderniza o atendimento ao cliente e centraliza a operação da cozinha e administração financeira.

---

## 🚀 Funcionalidades Principais

### 📱 Para o Cliente (Interface Pública)
* **Catálogo Dinâmico:** Navegação intuitiva separada por categorias (Pastéis Salgados, Doces, Panquecas, Salgados, Porções, Caldos e Bebidas).
* **Controle de Estoque Inteligente:** Produtos ficam indisponíveis automaticamente caso algum ingrediente da sua receita seja marcado como esgotado no painel admin.
* **Busca de Produtos:** Barra de pesquisa rápida integrada ao cabeçalho.
* **Sistema de Favoritos:** Os clientes podem favoritar seus pastéis e bebidas preferidos para compras futuras.
* **Carrinho de Compras:** Gestão de quantidades, cálculo automático de subtotais e taxa de entrega.
* **Checkout Avançado (Integração ViaCEP):** 
  * Busca automática de endereço pelo CEP.
  * Armazenamento de múltiplos endereços na conta do usuário para seleções rápidas.
  * Opções de pagamento na entrega (PIX, Cartões, Dinheiro com cálculo de troco).
* **Meus Pedidos:** Histórico completo de compras com acompanhamento de status em tempo real.

### ⚙️ Para o Administrador (Painel Admin)
* **Gestão de Fila de Pedidos:** Acompanhamento e alteração de status (`recebido` -> `em preparação` -> `enviado` -> `entregue`).
* **Notificações por E-mail (Nodemailer):** O cliente recebe um e-mail com layout personalizado sempre que o status do pedido avança.
* **Impressão de Comandas:** Geração de via de impressão formatada para a cozinha e entregador (com dados do cliente, itens e endereço).
* **Gestão do Cardápio:** Adição, edição e remoção de produtos, categorias e upload de fotos (Multer).
* **Controle de Estoque (Ingredientes):** O administrador cadastra os ingredientes e os vincula aos produtos. Se a "Carne" for desativada, todos os pastéis que usam carne ficam indisponíveis no site.
* **Relatórios Gerenciais Financeiros:** 
  * Relatório de Faturamento por período e filtro de categoria.
  * Relatório de Volume de Entregas e Ticket Médio.
  * Opção de exportação/impressão para PDF.

---

## 🛠️ Tecnologias Utilizadas

**Backend:**
* [Node.js](https://nodejs.org/) & [Express](https://expressjs.com/) - Servidor e roteamento.
* [Express-Handlebars](https://www.npmjs.com/package/express-handlebars) - Template engine para renderização das telas.
* [MySQL2](https://www.npmjs.com/package/mysql2) - Conexão e queries ao banco de dados com Pool de conexões.
* [Bcrypt](https://www.npmjs.com/package/bcrypt) - Criptografia de senhas de usuários.
* [Express-Session](https://www.npmjs.com/package/express-session) & [Express-MySQL-Session](https://www.npmjs.com/package/express-mysql-session) - Gerenciamento de sessões com persistência no banco.
* [Multer](https://www.npmjs.com/package/multer) - Upload e armazenamento de imagens dos produtos.
* [Nodemailer](https://nodemailer.com/) - Envio de e-mails transacionais (SMTP).

**Frontend:**
* HTML5 & CSS3 (Responsivo com Flexbox e CSS Grid).
* JavaScript Vanilla (Manipulação da DOM e chamadas assíncronas).
* [jQuery](https://jquery.com/) - Utilizado especificamente para a máscara e requisição da API do ViaCEP.
* [FontAwesome](https://fontawesome.com/) - Ícones da interface.

```

## 💻 Como Instalar e Executar o Projeto

### Pré-requisitos
Certifique-se de ter instalado na sua máquina:
* **Node.js** (versão 18+ recomendada)
* **MySQL Server** (ou pacotes como XAMPP / WampServer)
* **Git**

```

### 1. Clonar o repositório
```bash
git clone [https://github.com/cristianojunior-dev/Pastelaria_Filhas_Da_Maria.git](https://github.com/cristianojunior-dev/Pastelaria_Filhas_Da_Maria.git)
cd pastelaria-filhas-da-maria

```

### 2. Instalar as dependências

```bash
npm install

```

### 3. Configurar o Banco de Dados

1. Abra o seu gerenciador MySQL (como o MySQL Workbench).
2. Execute o script contido no arquivo `database/Banco de Dados_Pastelaria.sql` para criar o banco de dados (pastelaria_filhas_maria), as tabelas necessárias e os dados iniciais de teste (produtos, categorias e ingredientes).



### 4. Configurar as Variáveis de Ambiente (.env)

Crie um arquivo chamado `.env` na raiz do projeto (mesmo nível do `server.js`) copie as chaves abaixo e insira a senha do seu MySQL local:

```env
PORT=3000

# Configurações do Banco de Dados
DB_HOST=localhost
DB_USER=root
DB_PASS=Sua_Senha_MySQL
DB_NAME=pastelaria_filhas_maria

# Configurações do Session Secret
SESSION_SECRET=segredo_pastelaria_filhas_maria

# Configurações do Nodemailer (E-mails transacionais)
EMAIL_HOST=smtp.gmail.com
EMAIL_PORT=587
EMAIL_USER=pastelariafilhasdemaria@gmail.com
EMAIL_PASS=iqxchdgdoznuifzk

```

### 5. Iniciar o Servidor

Modo de desenvolvimento (com reinicialização automática se usar nodemon) ou produção:

```bash
npm start

```

O servidor estará rodando em: `http://localhost:3000`

---

## 👨‍💻 Acesso Administrativo Padrão

Para testar o painel administrativo, você pode utilizar as credenciais de seed:

* **E-mail:** `admin@admin`

* **Senha:** `admin`
