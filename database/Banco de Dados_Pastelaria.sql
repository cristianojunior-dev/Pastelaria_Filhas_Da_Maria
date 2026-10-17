-- =========================================================================
-- BANCO DE DADOS: PASTELARIA FILHAS DA MARIA
-- =========================================================================

DROP DATABASE IF EXISTS `pastelaria_filhas_maria`;
CREATE DATABASE `pastelaria_filhas_maria` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE `pastelaria_filhas_maria`;

-- =========================================================================
-- 1. CRIAÇÃO DAS TABELAS INDEPENDENTES
-- =========================================================================

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

CREATE TABLE `categorias` (
  `id` int NOT NULL AUTO_INCREMENT,
  `nome` varchar(100) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `ingredientes` (
  `id` int NOT NULL AUTO_INCREMENT,
  `nome` varchar(100) NOT NULL,
  `em_estoque` tinyint(1) DEFAULT '1',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- =========================================================================
-- 2. CRIAÇÃO DAS TABELAS DEPENDENTES (COM CHAVES ESTRANGEIRAS)
-- =========================================================================

-- Tabela de múltiplos endereços (ViaCEP)
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

-- Tabela de Produtos (Sem a coluna "descricao")
CREATE TABLE `produtos` (
  `id` int NOT NULL AUTO_INCREMENT,
  `nome` varchar(100) NOT NULL,
  `preco` decimal(10,2) NOT NULL,
  `imagem` varchar(255) DEFAULT NULL,
  `id_categoria` int DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `id_categoria` (`id_categoria`),
  CONSTRAINT `fk_produtos_categoria` FOREIGN KEY (`id_categoria`) REFERENCES `categorias` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Vínculo Produto <-> Ingrediente
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

-- Coluna CEP com VARCHAR(255) para receber o endereço completo
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
-- 3. INSERÇÃO DOS DADOS (SEED LIMPO)
-- =========================================================================

INSERT INTO `usuario` (`id`, `nome`, `email`, `telefone`, `senha`, `tipo_usuario`) VALUES
(1, 'admin', 'admin@admin', '99999999999', '$2b$10$jiH4nYEZjghBih6boYZmEOv2zo9fqDhs/Tv0liV/4VuynHR0ueZx2', 'admin');

INSERT INTO `categorias` (`id`, `nome`) VALUES
(1, 'Pastéis Salgados'), (2, 'Pastéis Doces'), (3, 'Bebidas'), 
(4, 'Salgados'), (5, 'Panquecas'), (6, 'Porções'), (7, 'Caldos');

INSERT INTO `ingredientes` (`id`, `nome`, `em_estoque`) VALUES
(1, 'Massa de pastel', 1), (2, 'Massa de salgado (Coxinha/Assados)', 1), (3, 'Massa podre (Empada)', 1), 
(4, 'Massa de panqueca', 1), (5, 'Carne moída', 1), (6, 'Frango desfiado', 1), 
(7, 'Hambúrguer bovino', 1), (8, 'Bacalhau desfiado', 1), (9, 'Bacon', 1), 
(10, 'Calabresa', 1), (11, 'Panceta suína (Torresmo)', 1), (12, 'Queijo mussarela', 1), 
(13, 'Catupiry', 1), (14, 'Queijo Minas (Branco)', 1), (15, 'Queijo Canastra', 1), 
(16, 'Brócolis', 1), (17, 'Tomate', 1), (18, 'Cebola', 1), 
(19, 'Alho', 1), (20, 'Azeitona', 1), (21, 'Ervilha', 1), 
(22, 'Batata palito (Porção)', 1), (23, 'Mandioca (Aipim)', 1), (24, 'Feijão', 1), 
(25, 'Arroz', 1), (26, 'Cenoura', 1), (27, 'Couve', 1), 
(28, 'Trigo para kibe', 1), (29, 'Hortelã', 1), (30, 'Molho de tomate artesanal', 1), 
(31, 'Molho branco', 1), (32, 'Chocolate ao leite', 1), (33, 'Goiabada cremosa', 1), 
(34, 'Banana', 1), (35, 'Canela em pó', 1), (36, 'Laranja fresca (para Suco)', 1), 
(37, 'Garrafa H2O Limão (Estoque)', 1), (38, 'Lata Cerveja Itaipava (Estoque)', 1), (39, 'Lata Refrigerante (Estoque)', 1);

-- Produtos sem a coluna descrição
INSERT INTO `produtos` (`id`, `nome`, `preco`, `imagem`, `id_categoria`) VALUES
(1, 'Pastel de Carne', 9.00, '1791921621572-779030691.png', 1),
(2, 'Pastel de Queijo', 9.00, '1791897780710-124221248.png', 1),
(3, 'Pastel Frango c/ Catupiry', 9.00, '1791897920203-717386132.png', 1),
(4, 'Pastel de Brócolis c/ Queijo', 9.00, '1791897832276-898620236.png', 1),
(5, 'Pastel de Chocolate', 10.00, '1791897881463-955293598.png', 2),
(6, 'Pastel de Banana c/ Canela', 10.00, '1791897807049-635174194.png', 2),
(7, 'Pastel Romeu e Julieta', 10.00, '1791897941088-281111386.png', 2),
(8, 'Coxinha', 6.00, '1791897491272-391592266.png', 4),
(9, 'Hambúrguer Assado', 6.00, '1791897578703-276559359.png', 4),
(10, 'Kibe', 6.00, '1791897611104-172852338.png', 4),
(11, 'Empada', 7.00, '1791897526539-131690826.png', 4),
(12, 'Panqueca Frango c/ Catupiry', 20.00, '1791897754242-410742021.png', 5),
(13, 'Panqueca de Carne', 20.00, '1791897721724-620790940.png', 5),
(14, 'Panqueca Queijo Canastra', 22.00, '1791915686735-669127710.png', 5),
(15, 'Panqueca de Bacalhau', 25.00, '1791897675195-389867088.png', 5),
(16, 'Batata Frita', 28.00, '1791897278352-744960985.png', 6),
(17, 'Batata Frita c/ Queijo e Bacon', 32.00, '1791897296862-313999461.png', 6),
(18, 'Torresmo', 48.00, '1791897995364-328445823.png', 6),
(19, 'Mandioca Frita', 27.00, '1791897644841-889332534.png', 6),
(20, 'Caldo de Canja', 22.00, '1791897347445-271618100.png', 7),
(21, 'Caldo de Mandioca c/ Bacon', 22.00, '1791897423975-206695166.png', 7),
(22, 'Caldo de Feijão c/ Bacon', 22.00, '1791897370392-757541276.png', 7),
(23, 'Caldo de Mandioca', 22.00, '1791897402306-563631902.png', 7),
(24, 'H2O', 6.00, '1791897550880-601784906.png', 3),
(25, 'Cerveja Itaipava Lata', 5.00, '1791897472651-579046241.png', 3),
(26, 'Suco de Laranja Natural', 27.00, '1791897978491-793378490.png', 3),
(27, 'Refrigerante Lata', 6.00, '1791897959525-219335783.png', 3);

INSERT INTO `produto_ingredientes` (`id_produto`, `id_ingrediente`) VALUES
(1, 1), (1, 5), (1, 20), (1, 18),
(2, 1), (2, 12),
(3, 1), (3, 6), (3, 13),
(4, 1), (4, 16), (4, 12), (4, 19),
(5, 1), (5, 32),
(6, 1), (6, 34), (6, 35),
(7, 1), (7, 33), (7, 14),
(8, 2), (8, 6),
(9, 2), (9, 7), (9, 12), (9, 17),
(10, 5), (10, 28), (10, 18), (10, 29),
(11, 3), (11, 6), (11, 20), (11, 21),
(12, 4), (12, 6), (12, 13), (12, 30),
(13, 4), (13, 5), (13, 30),
(14, 4), (14, 15), (14, 31),
(15, 4), (15, 8), (15, 20), (15, 31),
(16, 22),
(17, 22), (17, 12), (17, 9),
(18, 11),
(19, 23),
(20, 25), (20, 6), (20, 26),
(21, 23), (21, 9), (21, 10), (21, 27),
(22, 24), (22, 9), (22, 19),
(23, 23), (23, 19),
(24, 37),
(25, 38),
(26, 36),
(27, 39);