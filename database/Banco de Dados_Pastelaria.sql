-- =========================================================================
-- BANCO DE DADOS: PASTELARIA FILHAS DA MARIA
-- =========================================================================

DROP DATABASE IF EXISTS `pastelaria_filhas_maria`;
CREATE DATABASE `pastelaria_filhas_maria` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE `pastelaria_filhas_maria`;

-- =========================================================================
-- 1. TABELAS INDEPENDENTES (SEM CHAVES ESTRANGEIRAS)
-- =========================================================================

-- 1.1 Tabela de Utilizadores
CREATE TABLE `usuario` (
  `id` int NOT NULL AUTO_INCREMENT,
  `nome` varchar(100) NOT NULL,
  `email` varchar(100) NOT NULL,
  `telefone` varchar(20) DEFAULT NULL,
  `senha` varchar(255) NOT NULL,
  `tipo_usuario` enum('cliente','admin') DEFAULT 'cliente',
  PRIMARY KEY (`id`),
  UNIQUE KEY `email` (`email`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 1.2 Tabela de Categorias
CREATE TABLE `categorias` (
  `id` int NOT NULL AUTO_INCREMENT,
  `nome` varchar(100) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 1.3 Tabela de Ingredientes (Controlo de Stock)
CREATE TABLE `ingredientes` (
  `id` int NOT NULL AUTO_INCREMENT,
  `nome` varchar(100) NOT NULL,
  `em_estoque` tinyint(1) DEFAULT '1',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- =========================================================================
-- 2. TABELAS DEPENDENTES (COM CHAVES ESTRANGEIRAS JÁ DEFINIDAS)
-- =========================================================================

-- 2.1 Tabela de Endereços dos Utilizadores (Integração ViaCEP)
CREATE TABLE `enderecos` (
  `id` int NOT NULL AUTO_INCREMENT,
  `id_usuario` int NOT NULL,
  `cep` varchar(15) NOT NULL,
  `rua` varchar(150) NOT NULL,
  `numero` varchar(20) NOT NULL,
  `bairro` varchar(100) NOT NULL,
  `cidade` varchar(100) NOT NULL,
  `uf` varchar(5) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `id_usuario` (`id_usuario`),
  CONSTRAINT `fk_enderecos_usuario` FOREIGN KEY (`id_usuario`) REFERENCES `usuario` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 2.2 Tabela de Produtos
CREATE TABLE `produtos` (
  `id` int NOT NULL AUTO_INCREMENT,
  `nome` varchar(100) NOT NULL,
  `preco` decimal(10,2) NOT NULL,
  `descricao` text,
  `imagem` varchar(255) DEFAULT NULL,
  `id_categoria` int DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `id_categoria` (`id_categoria`),
  CONSTRAINT `fk_produtos_categoria` FOREIGN KEY (`id_categoria`) REFERENCES `categorias` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 2.3 Tabela Relacional: Produto <-> Ingredientes
CREATE TABLE `produto_ingredientes` (
  `id` int NOT NULL AUTO_INCREMENT,
  `id_produto` int NOT NULL,
  `id_ingrediente` int NOT NULL,
  PRIMARY KEY (`id`),
  KEY `id_produto` (`id_produto`),
  KEY `id_ingrediente` (`id_ingrediente`),
  CONSTRAINT `fk_pi_produto` FOREIGN KEY (`id_produto`) REFERENCES `produtos` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_pi_ingrediente` FOREIGN KEY (`id_ingrediente`) REFERENCES `ingredientes` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 2.4 Tabela de Favoritos
CREATE TABLE `favoritos` (
  `id` int NOT NULL AUTO_INCREMENT,
  `id_usuario` int NOT NULL,
  `id_produto` int NOT NULL,
  PRIMARY KEY (`id`),
  KEY `id_usuario` (`id_usuario`),
  KEY `id_produto` (`id_produto`),
  CONSTRAINT `fk_favoritos_usuario` FOREIGN KEY (`id_usuario`) REFERENCES `usuario` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_favoritos_produto` FOREIGN KEY (`id_produto`) REFERENCES `produtos` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 2.5 Tabela de Pedidos (Com coluna CEP já ajustada para VARCHAR(255) para guardar o endereço completo)
CREATE TABLE `pedidos` (
  `id` int NOT NULL AUTO_INCREMENT,
  `id_usuario` int NOT NULL,
  `codigo` varchar(20) NOT NULL,
  `status` enum('recebido','em preparação','enviado','entregue') DEFAULT 'recebido',
  `total_pedido` decimal(10,2) NOT NULL,
  `taxa_entrega` decimal(10,2) DEFAULT '5.00',
  `forma_pagamento` varchar(50) NOT NULL,
  `cep` varchar(255) DEFAULT NULL,
  `data` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `id_usuario` (`id_usuario`),
  CONSTRAINT `fk_pedidos_usuario` FOREIGN KEY (`id_usuario`) REFERENCES `usuario` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 2.6 Tabela de Itens do Pedido
CREATE TABLE `pedido_itens` (
  `id` int NOT NULL AUTO_INCREMENT,
  `id_pedido` int NOT NULL,
  `id_produto` int NOT NULL,
  `quantidade` int NOT NULL,
  `preco_unitario` decimal(10,2) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `id_pedido` (`id_pedido`),
  KEY `id_produto` (`id_produto`),
  CONSTRAINT `fk_itens_pedido` FOREIGN KEY (`id_pedido`) REFERENCES `pedidos` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_itens_produto` FOREIGN KEY (`id_produto`) REFERENCES `produtos` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- =========================================================================
-- 3. INSERÇÃO DE DADOS INICIAIS (SEED)
-- =========================================================================

-- 3.1 Utilizador Administrador Padrão
INSERT INTO `usuario` (`id`, `nome`, `email`, `telefone`, `senha`, `tipo_usuario`) VALUES
(1, 'admin', 'admin@admin', '99999999999', '$2b$10$jiH4nYEZjghBih6boYZmEOv2zo9fqDhs/Tv0liV/4VuynHR0ueZx2', 'admin');

-- 3.2 Categorias do Cardápio
INSERT INTO `categorias` (`id`, `nome`) VALUES
(1, 'Pastéis Salgados'),
(2, 'Pastéis Doces'),
(3, 'Bebidas'),
(4, 'Salgados'),
(5, 'Panquecas'),
(6, 'Porções'),
(7, 'Caldos');

-- 3.3 Produtos do Cardápio
INSERT INTO `produtos` (`id`, `nome`, `preco`, `descricao`, `imagem`, `id_categoria`) VALUES
(1, 'Pastel de Carne', 9.00, 'Pastel recheado com carne moída temperada, azeitona e cebola.', '1791921621572-779030691.png', 1),
(2, 'Pastel de Queijo', 9.00, 'Pastel recheado com queijo mussarela derretido e orégano.', '1791897780710-124221248.png', 1),
(3, 'Pastel Frango c/ Catupiry', 9.00, 'Pastel recheado com frango desfiado temperado e legítimo Catupiry.', '1791897920203-717386132.png', 1),
(4, 'Pastel de Brócolis c/ Queijo', 9.00, 'Pastel recheado com brócolis fresco, queijo mussarela e alho frito.', '1791897832276-898620236.png', 1),
(5, 'Pastel de Chocolate', 10.00, 'Pastel doce recheado com chocolate ao leite derretido e açúcar de confeiteiro.', '1791897881463-955293598.png', 2),
(6, 'Pastel de Banana c/ Canela', 10.00, 'Pastel doce recheado com banana fatiada, açúcar e canela em pó.', '1791897807049-635174194.png', 2),
(7, 'Pastel Romeu e Julieta', 10.00, 'Pastel doce recheado com goiabada cremosa e queijo branco (Minas).', '1791897941088-281111386.png', 2),
(8, 'Coxinha', 6.00, 'Coxinha tradicional de frango desfiado temperado.', '1791897491272-391592266.png', 4),
(9, 'Hambúrguer Assado', 6.00, 'Salgado assado com hambúrguer bovino, queijo mussarela, tomate e orégano.', '1791897578703-276559359.png', 4),
(10, 'Kibe', 6.00, 'Kibe frito tradicional com carne moída, trigo, cebola, hortelã e temperos árabes.', '1791897611104-172852338.png', 4),
(11, 'Empada', 7.00, 'Empada de massa podre com recheio cremoso de frango, azeitona e ervilha.', '1791897526539-131690826.png', 4),
(12, 'Panqueca Frango c/ Catupiry', 20.00, 'Panqueca de frango desfiado com Catupiry, molho de tomate artesanal e queijo ralado.', '1791897754242-410742021.png', 5),
(13, 'Panqueca de Carne', 20.00, 'Panqueca de carne moída temperada com molho de tomate artesanal e salsinha.', '1791897721724-620790940.png', 5),
(14, 'Panqueca Queijo Canastra', 22.00, 'Panqueca de queijo Canastra artesanal derretido ao molho branco e noz-moscada.', '1791915686735-669127710.png', 5),
(15, 'Panqueca de Bacalhau', 25.00, 'Panqueca de bacalhau desfiado com azeite de oliva, azeitonas pretas e molho branco.', '1791897675195-389867088.png', 5),
(16, 'Batata Frita', 28.00, 'Porção de batata palito cortada na hora, acompanha maionese da casa.', '1791897278352-744960985.png', 6),
(17, 'Batata Frita c/ Queijo e Bacon', 32.00, 'Porção de batata palito com mix de queijos derretidos e cubos de bacon crocante.', '1791897296862-313999461.png', 6),
(18, 'Torresmo', 48.00, 'Porção de panceta de porco crocante, acompanha limão.', '1791897995364-328445823.png', 6),
(19, 'Mandioca Frita', 27.00, 'Porção de mandioca cozida e frita na manteiga de garrafa.', '1791897644841-889332534.png', 6),
(20, 'Caldo de Canja', 22.00, 'Canja quentinha com arroz, peito de frango desfiado, cenoura, batata e cheiro-verde.', '1791897347445-271618100.png', 7),
(21, 'Caldo de Mandioca c/ Bacon', 22.00, 'Creme de mandioca com bacon frito, calabresa defumada e couve picadinha.', '1791897423975-206695166.png', 7),
(22, 'Caldo de Feijão c/ Bacon', 22.00, 'Caldo de feijão batido com bacon crocante, alho frito e cebolinha.', '1791897370392-757541276.png', 7),
(23, 'Caldo de Mandioca', 22.00, 'Creme de mandioca (aipim) tradicional com alho dourado, azeite e cheiro-verde fresco.', '1791897402306-563631902.png', 7),
(24, 'H2O', 6.00, 'Bebida levemente gaseificada sabor limão.', '1791897550880-601784906.png', 3),
(25, 'Cerveja Itaipava Lata', 5.00, 'Cerveja gelada em lata.', '1791897472651-579046241.png', 3),
(26, 'Suco de Laranja Natural', 27.00, 'Jarra de suco de laranjas frescas espremidas na hora.', '1791897978491-793378490.png', 3),
(27, 'Refrigerante Lata', 6.00, 'Refrigerante lata 350ml (Coca-Cola / Guaraná).', '1791897959525-219335783.png', 3);

-- 3.4 Ingredientes
INSERT INTO `ingredientes` (`id`, `nome`, `em_estoque`) VALUES
(1, 'Massa de pastel', 1),
(2, 'Carne moída temperada', 1),
(3, 'Azeitona', 1),
(4, 'Cebola', 1),
(5, 'Queijo mussarela', 1),
(6, 'Orégano', 1),
(7, 'Frango desfiado temperado', 1),
(8, 'Legítimo Catupiry', 1),
(9, 'Brócolis fresco', 1),
(10, 'Alho frito', 1),
(11, 'Chocolate ao leite derretido', 1),
(12, 'Açúcar de confeiteiro', 1),
(13, 'Banana fatiada', 1),
(14, 'Açúcar', 1),
(15, 'Canela em pó', 1),
(16, 'Goiabada cremosa', 1),
(17, 'Queijo branco (Minas)', 1),
(18, 'Massa de farinha com caldo de frango', 1),
(19, 'Farinha de rosca para empanar', 1),
(20, 'Massa de salgado assado', 1),
(21, 'Hambúrguer de carne bovina', 1),
(22, 'Tomate', 1),
(23, 'Carne moída', 1),
(24, 'Trigo para kibe', 1),
(25, 'Hortelã fresca', 1),
(26, 'Temperos árabes', 1),
(27, 'Massa podre', 1),
(28, 'Frango desfiado cremoso', 1),
(29, 'Ervilha', 1),
(30, 'Massa fina de panqueca', 1),
(31, 'Frango desfiado', 1),
(32, 'Catupiry', 1),
(33, 'Molho de tomate artesanal', 1),
(34, 'Queijo ralado', 1),
(35, 'Carne moída bem temperada', 1),
(36, 'Salsinha', 1),
(37, 'Queijo Canastra artesanal derretido', 1),
(38, 'Molho branco', 1),
(39, 'Noz-moscada', 1),
(40, 'Bacalhau desfiado', 1),
(41, 'Azeite de oliva', 1),
(42, 'Azeitonas pretas', 1),
(43, 'Batata palito cortada na hora', 1),
(44, 'Sal', 1),
(45, 'Acompanha maionese da casa', 1),
(46, 'Batata palito', 1),
(47, 'Mix de queijos derretidos', 1),
(48, 'Cubos de bacon crocante', 1),
(49, 'Panceta de porco', 1),
(50, 'Limão para acompanhar', 1),
(51, 'Mandioca cozida e frita', 1),
(52, 'Manteiga de garrafa', 1),
(53, 'Arroz', 1),
(54, 'Peito de frango desfiado', 1),
(55, 'Cenoura', 1),
(56, 'Batata', 1),
(57, 'Cheiro-verde', 1),
(58, 'Creme de mandioca', 1),
(59, 'Bacon frito', 1),
(60, 'Calabresa defumada', 1),
(61, 'Couve picadinha', 1),
(62, 'Feijão carioca ou preto batido', 1),
(63, 'Bacon crocante', 1),
(64, 'Cebolinha', 1),
(65, 'Creme de mandioca (aipim)', 1),
(66, 'Alho dourado', 1),
(67, 'Azeite', 1),
(68, 'Cheiro-verde fresco', 1),
(69, 'Água gaseificada', 1),
(70, 'Suco de limão', 1),
(71, 'Edulcorantes', 1),
(72, 'Água', 1),
(73, 'Malte', 1),
(74, 'Cereais não maltados', 1),
(75, 'Lúpulo', 1),
(76, 'Laranjas frescas espremidas na hora', 1),
(77, 'Extrato natural (Coca/Guaraná)', 1);

-- 3.5 Vínculo de Produtos e Ingredientes
INSERT INTO `produto_ingredientes` (`id_produto`, `id_ingrediente`) VALUES
-- Pastel de Carne (ID 1)
(1, 1), (1, 2), (1, 3), (1, 4),
-- Pastel de Queijo (ID 2)
(2, 1), (2, 5), (2, 6),
-- Pastel Frango c/ Catupiry (ID 3)
(3, 1), (3, 7), (3, 8),
-- Pastel de Brócolis c/ Queijo (ID 4)
(4, 1), (4, 9), (4, 5), (4, 10),
-- Pastel de Chocolate (ID 5)
(5, 1), (5, 11), (5, 12),
-- Pastel de Banana c/ Canela (ID 6)
(6, 1), (6, 13), (6, 14), (6, 15),
-- Pastel Romeu e Julieta (ID 7)
(7, 1), (7, 16), (7, 17),
-- Coxinha (ID 8)
(8, 18), (8, 7), (8, 19),
-- Hambúrguer Assado (ID 9)
(9, 20), (9, 21), (9, 5), (9, 22), (9, 6),
-- Kibe (ID 10)
(10, 23), (10, 24), (10, 4), (10, 25), (10, 26),
-- Empada (ID 11)
(11, 27), (11, 28), (11, 3), (11, 29),
-- Panqueca Frango c/ Catupiry (ID 12)
(12, 30), (12, 31), (12, 32), (12, 33), (12, 34),
-- Panqueca de Carne (ID 13)
(13, 30), (13, 35), (13, 33), (13, 36),
-- Panqueca Queijo Canastra (ID 14)
(14, 30), (14, 37), (14, 38), (14, 39),
-- Panqueca de Bacalhau (ID 15)
(15, 30), (15, 40), (15, 41), (15, 42), (15, 38),
-- Batata Frita (ID 16)
(16, 43), (16, 44), (16, 45),
-- Batata Frita c/ Queijo e Bacon (ID 17)
(17, 46), (17, 47), (17, 48),
-- Torresmo (ID 18)
(18, 49), (18, 44), (18, 50),
-- Mandioca Frita (ID 19)
(19, 51), (19, 52), (19, 44),
-- Caldo de Canja (ID 20)
(20, 53), (20, 54), (20, 55), (20, 56), (20, 57),
-- Caldo de Mandioca c/ Bacon (ID 21)
(21, 58), (21, 59), (21, 60), (21, 61),
-- Caldo de Feijão c/ Bacon (ID 22)
(22, 62), (22, 63), (22, 10), (22, 64),
-- Caldo de Mandioca (ID 23)
(23, 65), (23, 66), (23, 67), (23, 68),
-- H2O (ID 24)
(24, 69), (24, 70), (24, 71),
-- Cerveja Itaipava Lata (ID 25)
(25, 72), (25, 73), (25, 74), (25, 75),
-- Suco de Laranja Natural (ID 26)
(26, 76),
-- Refrigerante Lata (ID 27)
(27, 69), (27, 14), (27, 77);