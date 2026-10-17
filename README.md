```markdown
# 🥟 Pastelaria Filhas da Maria

Sistema web completo de delivery e gestão para a **Pastelaria Filhas da Maria**,
desenvolvido com Node.js, Express, Handlebars e MySQL. O projeto conta com cardápio dinâmico, controle de estoque de ingredientes por receita,
carrinho de compras, múltiplos endereços com busca automática de CEP (ViaCEP), painel administrativo e notificações por e-mail (Nodemailer)

---

## 🚀 Funcionalidades do Sistema

### 👤 Para o Cliente:
* **Catálogo Completo e Interativo:** Visualização de pastéis salgados, doces, panquecas, salgados, porções, caldos e bebidas
* **Controle de Estoque Inteligente:** Se um ingrediente essencial de um pastel esgotar na cozinha, o produto fica automaticamente com o selo
*"Indisponível no momento"*.
* **Busca de Produtos:** Barra de pesquisa em tempo real.
* **Favoritos:** Adicione e remova pastéis e bebidas favoritas.
* **Carrinho de Compras:** Gestão completa de quantidades e itens.
* **Checkout Avançado com ViaCEP:** 
  * Busca automática de endereço pelo CEP integrado à API dos Correios (ViaCEP).
  * Opção de escolher entre endereços já salvos na conta ou cadastrar um novo endereço que fica guardado automaticamente.
  * Possibilidade de remover endereços antigos diretamente na finalização.
* **Acompanhamento de Pedidos:** Histórico completo de pedidos realizados na aba "Meus Pedidos".

### ⚙️ Para o Administrador (Painel Admin):
* **Fila de Pedidos em Tempo Real:** Monitoramento de novos pedidos recebidos, com alteração de status
(`recebido` -> `em preparação` -> `enviado` -> `entregue`).
* **Notificações por E-mail:** Envio automático de atualizações da entrega para o cliente via Nodemailer.
* **Gestão de Cardápio:** Cadastro de novos produtos com upload de fotos (Multer)[cite: 1], edição via Modal e exclusão de itens.
* **Controle de Estoque Manual:** Ativação e desativação rápida de ingredientes (ex: esgotou o queijo ou a goiabada).

---

## 🛠️ Tecnologias Utilizadas

* **Backend:** Node.js, Express
* **Sessões e Segurança:** Express-session, Cookie-parser, Bcrypt (Criptografia de senhas)
* **Banco de Dados:** MySQL (MySQL2 com Pool de Conexões)
* **Template Engine:** Handlebars (`express-handlebars`)
* **Upload de Imagens:** Multer
* **Envio de E-mails:** Nodemailer
* **Frontend & Estilização:** HTML5, CSS3 (Responsivo), JavaScript Vanilla, jQuery (para a API de CEP), Font Awesome

---

## 📦 Como Instalar e Executar o Projeto

### Pré-requisitos
Certifique-se de ter instalado em sua máquina:
* **Node.js** (versão 18+ recomendada)
* **MySQL Server** (ou XAMPP / WampServer)

### 1. Clonar o repositório
```bash
git clone https://github.com/cristianojunior-dev/Pastelaria_Filhas_Da_Maria.git
cd pastelaria-filhas-da-maria

```

### 2. Instalar as dependências

```bash
npm install

```

### 3. Configurar o Banco de Dados

1. Abra o seu gerenciador MySQL (como o MySQL Workbench).
2. Execute o script contido no arquivo `database/Banco de Dados_Pastelaria.sql` para criar a base de dados, tabelas e dados iniciais.



### 4. Configurar as Variáveis de Ambiente (.env)

No arquivo `.env` na raiz do projeto coloque sua senha do seu MySQL:

```env
PORT=3000

# Configurações do Banco de Dados
DB_HOST=localhost
DB_USER=root
DB_PASS=sua_senha_aqui
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
