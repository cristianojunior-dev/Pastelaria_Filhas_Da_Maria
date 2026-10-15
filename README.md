```markdown
# 🥟 Pastelaria Filhas da Maria

Sistema web completo de delivery e gestão para a **Pastelaria Filhas da Maria**, desenvolvido com Node.js, Express, Handlebars e MySQL. O projeto conta com cardápio dinâmico, controle de estoque de ingredientes por receita, carrinho de compras, múltiplos endereços com busca automática de CEP (ViaCEP)[cite: 2], painel administrativo e notificações por e-mail (Nodemailer)[cite: 1].

---

## 🚀 Funcionalidades do Sistema

### 👤 Para o Cliente:
* **Catálogo Completo e Interativo:** Visualização de pastéis salgados, doces, panquecas, salgados, porções, caldos e bebidas[cite: 1].
* **Controle de Estoque Inteligente:** Se um ingrediente essencial de um pastel esgotar na cozinha, o produto fica automaticamente com o selo *"Indisponível no momento"*[cite: 1].
* **Busca de Produtos:** Barra de pesquisa em tempo real[cite: 1].
* **Favoritos:** Adicione e remova pastéis e bebidas favoritas[cite: 1].
* **Carrinho de Compras:** Gestão completa de quantidades e itens[cite: 1].
* **Checkout Avançado com ViaCEP:** 
  * Busca automática de endereço pelo CEP integrado à API dos Correios (ViaCEP)[cite: 2].
  * Opção de escolher entre endereços já salvos na conta ou cadastrar um novo endereço que fica guardado automaticamente.
  * Possibilidade de remover endereços antigos diretamente na finalização.
* **Acompanhamento de Pedidos:** Histórico completo de pedidos realizados na aba "Meus Pedidos"[cite: 1].

### ⚙️ Para o Administrador (Painel Admin):
* **Fila de Pedidos em Tempo Real:** Monitoramento de novos pedidos recebidos, com alteração de status (`recebido` -> `em preparação` -> `enviado` -> `entregue`)[cite: 1].
* **Notificações por E-mail:** Envio automático de atualizações da entrega para o cliente via Nodemailer[cite: 1].
* **Gestão de Cardápio:** Cadastro de novos produtos com upload de fotos (Multer)[cite: 1], edição via Modal[cite: 1] e exclusão de itens[cite: 1].
* **Controle de Estoque Manual:** Ativação e desativação rápida de ingredientes (ex: esgotou o queijo ou a goiabada)[cite: 1].

---

## 🛠️ Tecnologias Utilizadas

* **Backend:** Node.js, Express[cite: 1]
* **Sessões e Segurança:** Express-session, Cookie-parser, Bcrypt (Criptografia de senhas)[cite: 1]
* **Banco de Dados:** MySQL (MySQL2 com Pool de Conexões)[cite: 1]
* **Template Engine:** Handlebars (`express-handlebars`)[cite: 1]
* **Upload de Imagens:** Multer[cite: 1]
* **Envio de E-mails:** Nodemailer[cite: 1]
* **Frontend & Estilização:** HTML5, CSS3 (Responsivo), JavaScript Vanilla, jQuery (para a API de CEP)[cite: 2], Font Awesome[cite: 1]

---

## 📦 Como Instalar e Executar o Projeto

### Pré-requisitos
Certifique-se de ter instalado em sua máquina:
* **Node.js** (versão 18+ recomendada)
* **MySQL Server** (ou XAMPP / WampServer)

### 1. Clonar o repositório
```bash
git clone https://github.com/PanetoMatheus/Pastelaria_Filhas_Maria.git
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
