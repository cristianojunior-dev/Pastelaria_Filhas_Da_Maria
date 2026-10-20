-- =========================================================================
-- BANCO DE DADOS: PASTELARIA FILHAS DA MARIA (ESTRUTURA)
-- =========================================================================

DROP DATABASE IF EXISTS `pastelaria_filhas_maria`;
CREATE DATABASE `pastelaria_filhas_maria` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE `pastelaria_filhas_maria`;

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

CREATE TABLE `produtos` (
  `id` int NOT NULL AUTO_INCREMENT,
  `nome` varchar(100) NOT NULL,
  `preco` decimal(10,2) NOT NULL,
  `imagem` varchar(255) DEFAULT 'default.png',
  `id_categoria` int DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `id_categoria` (`id_categoria`),
  CONSTRAINT `fk_produtos_categoria` FOREIGN KEY (`id_categoria`) REFERENCES `categorias` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

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
-- INSERÇÃO DOS DADOS
-- =========================================================================

INSERT INTO `usuario` (`id`, `nome`, `email`, `telefone`, `senha`, `tipo_usuario`) VALUES 
(1, 'admin', 'admin@admin', '99999999999', '$2b$10$jiH4nYEZjghBih6boYZmEOv2zo9fqDhs/Tv0liV/4VuynHR0ueZx2', 'admin');

INSERT INTO `categorias` (`id`, `nome`) VALUES 
(1, 'Pastéis Salgados'), (2, 'Pastéis Doces'), (3, 'Panquecas'), 
(4, 'Salgados'), (5, 'Porções'), (6, 'Caldos'), (7, 'Bebidas');

INSERT INTO `ingredientes` (`id`, `nome`, `em_estoque`) VALUES 
(1, 'Massa de pastel', 1), (2, 'Massa de salgado', 1), (3, 'Massa podre (Empada)', 1), 
(4, 'Massa de panqueca', 1), (5, 'Carne moída', 1), (6, 'Frango desfiado', 1), 
(7, 'Hambúrguer bovino', 1), (8, 'Bacalhau desfiado', 1), (9, 'Bacon', 1), 
(10, 'Calabresa', 1), (11, 'Panceta suína (Torresmo)', 1), (12, 'Queijo mussarela', 1), 
(13, 'Catupiry', 1), (14, 'Queijo Minas (Branco)', 1), (15, 'Queijo Canastra', 1), 
(16, 'Brócolis', 1), (17, 'Tomate', 1), (18, 'Cebola', 1), 
(19, 'Alho', 1), (20, 'Azeitona', 1), (21, 'Ervilha', 1), 
(22, 'Batata palito', 1), (23, 'Mandioca (Aipim)', 1), (24, 'Feijão', 1), 
(25, 'Arroz', 1), (26, 'Cenoura', 1), (27, 'Couve', 1), 
(28, 'Trigo para kibe', 1), (29, 'Hortelã', 1), (30, 'Molho de tomate', 1), 
(31, 'Molho branco', 1), (32, 'Chocolate ao leite', 1), (33, 'Goiabada cremosa', 1), 
(34, 'Banana', 1), (35, 'Canela em pó', 1), (36, 'Laranja fresca', 1), 
(37, 'H2O Limão', 1), (38, 'Cerveja Itaipava', 1), (39, 'Refrigerante Lata', 1),
(40, 'Camarão', 1), (41, 'Palmito', 1), (42, 'Orégano', 1),
(43, 'Strogonoff de Carne Bovina', 1), (44, 'Strogonoff de Frango', 1), (45, 'Salsicha', 1),
(46, 'Carne Seca', 1), (47, 'Mandioquinha Salsa', 1), (48, 'Tomate Seco', 1),
(49, 'Rúcula', 1), (50, 'Garrafa Brahma/Skol/Sub Zero', 1), (51, 'Cerveja sem Álcool', 1),
(52, 'Refrigerante Maçã 2L', 1), (53, 'Refrigerante Mogi 600ml', 1), (54, 'Refrigerante KS', 1),
(55, 'Refrigerante Mogi Pet', 1), (56, 'Coca-Cola 1L', 1), (57, 'Guaraná Antarctica 1L', 1),
(58, 'Coca/Guaraná 2L', 1), (59, 'Água Mineral', 1), (60, 'Massa de croquete', 1), (61, 'Presunto', 1);

INSERT INTO `produtos` (`id`, `nome`, `preco`, `imagem`, `id_categoria`) VALUES 
(1, 'Pastel de Carne', 9.00, '1792466318323-180478849.jpg', 1), 
(2, 'Pastel de Queijo', 9.00, '1792469059542-870244860.jpg', 1), 
(3, 'Pastel Frango c/ Catupiry', 9.00, '1792466355530-183041118.jpg', 1), 
(4, 'Pastel de Brócolis c/ Queijo', 9.00, '1792466772515-351766605.jpg', 1), 
(5, 'Pastel de Chocolate', 10.00, '1792466786648-259196785.jpg', 2), 
(6, 'Pastel de Banana c/ Canela', 10.00, '1792466813308-981902952.jpg', 2), 
(7, 'Pastel Romeu e Julieta', 10.00, '1792466824703-425610835.jpg', 2), 
(8, 'Coxinha', 6.00, '1792466834736-33420290.jpg', 4), 
(9, 'Hamburgão', 7.00, '1792466854394-331278635.jpg', 4), 
(10, 'Kibe', 6.00, '1792466876461-880224488.jpg', 4), 
(11, 'Empada', 7.00, '1792466886525-351426801.jpg', 4), 
(12, 'Panqueca Frango c/ Catupiry', 20.00, '1792466897201-436724526.jpg', 3), 
(13, 'Panqueca de Carne', 20.00, '1792466908723-56330089.jpg', 3), 
(14, 'Panqueca Queijo Canastra', 22.00, '1792466921569-764956461.jpg', 3), 
(15, 'Panqueca de Bacalhau', 25.00, '1792466931578-875824073.jpg', 3), 
(16, 'Batata Frita', 28.00, '1792466944881-749981715.jpg', 5), 
(17, 'Batata Frita c/ Queijo e Bacon', 34.00, '1792466953694-940458647.jpg', 5), 
(18, 'Torresmo', 48.00, '1792466963693-670496048.jpg', 5), 
(19, 'Mandioca Frita', 27.00, '1792466974480-734664559.jpg', 5), 
(20, 'Caldo de Canja', 22.00, '1792466983376-477039642.jpg', 6), 
(21, 'Caldo de Mandioca c/ Bacon', 22.00, '1792466999554-728515862.jpg', 6), 
(22, 'Caldo de Feijão c/ Bacon', 22.00, '1792467019878-442655302.jpg', 6), 
(23, 'Caldo de Mandioca', 22.00, '1792467029473-726495263.jpg', 6), 
(24, 'H2O', 6.00, '1792467040703-742917118.jpg', 7), 
(25, 'Cerveja Itaipava Lata', 5.00, '1792467052035-624950578.jpg', 7), 
(26, 'Suco de Laranja Natural', 7.00, '1792467061589-405015406.jpg', 7), 
(27, 'Refrigerante Lata', 6.00, '1792467072426-485463528.jpg', 7),
(28, 'Pastel Queijo Canastra', 9.00, '1792467083106-312474942.jpg', 1),
(29, 'Pastel Brócolis c/ Molho Branco e Queijo', 10.00, '1792467105934-64885767.jpg', 1),
(30, 'Pastel Batata c/ Queijo e Bacon', 10.00, '1792467160430-7981880.jpg', 1),
(31, 'Pastel Strogonoff de Carne', 11.00, '1792467173932-492568319.jpg', 1),
(32, 'Pastel de Camarão', 12.00, '1792467184939-577004660.jpg', 1),
(33, 'Pastel de Palmito', 9.00, '1792467199563-642826505.jpg', 1),
(34, 'Pastel Sabor Pizza', 9.00, '1792467216074-99743482.jpg', 1),
(35, 'Pastel de Calabresa', 9.00, '1792467227037-526425102.jpg', 1),
(36, 'Pastel Strogonoff de Frango', 10.00, '1792467245386-476457125.jpg', 1),
(37, 'Pastel de Bacalhau', 12.00, '1792467259225-181076737.jpg', 1),
(38, 'Pastel X-Tudo', 19.00, '1792467269738-617195916.jpg', 1),
(39, 'Espeto', 6.00, '1792467278921-542946773.jpg', 4),
(40, 'Enroladinho', 6.00, '1792467293404-676705853.jpg', 4),
(41, 'Croquete', 6.00, '1792467304486-295432429.jpg', 4),
(42, 'Porção Batata com Queijo', 32.00, '1792467315789-907984762.jpg', 5),
(43, 'Bolinho Mandioca com Bacalhau', 29.00, '1792467327643-449853640.jpg', 5),
(44, 'Bolinho Mandioca com Carne Seca', 29.00, '1792467337747-125670972.jpg', 5),
(45, 'Porção Tira Gosto', 9.00, '1792467350147-94465474.jpg', 5),
(46, 'Porção Calabresa Acebolada', 36.00, '1792467363270-338692651.jpg', 5),
(47, 'Caldo Mandioquinha Salsa', 22.00, '1792467374600-984269234.jpg', 6),
(48, 'Cerveja Brahma/Skol/Sub Zero', 6.00, '1792467385449-460502647.jpg', 7),
(49, 'Cerveja sem Álcool', 6.00, '1792467439927-86411339.jpg', 7),
(50, 'Refrigerante Maçã 2L', 8.00, '1792467447905-532662148.jpg', 7),
(51, 'Refrigerante Mogi 600ml', 4.00, '1792467455732-646817306.jpg', 7),
(52, 'Refrigerante KS', 4.50, '1792467463514-883715603.jpg', 7),
(53, 'Refrigerante Mogi Pet', 3.00, '1792467470610-960401905.jpg', 7),
(54, 'Coca-Cola 1L', 8.00, '1792467478541-718245527.jpg', 7),
(55, 'Guaraná Antarctica 1L', 8.00, '1792467485587-32256757.jpg', 7),
(56, 'Coca/Guaraná Antarctica 2L', 13.00, '1792467493529-265106684.jpg', 7),
(57, 'Água Mineral', 3.50, '1792467501331-153633839.jpg', 7);

INSERT INTO `produto_ingredientes` (`id_produto`, `id_ingrediente`) VALUES 
(1, 1), (1, 5), (1, 20), (1, 18), (2, 1), (2, 12), (3, 1), (3, 6), (3, 13), 
(4, 1), (4, 16), (4, 12), (4, 19), (5, 1), (5, 32), (6, 1), (6, 34), (6, 35), 
(7, 1), (7, 33), (7, 14), (8, 2), (8, 6), (9, 2), (9, 7), (9, 12), (9, 17), 
(10, 5), (10, 28), (10, 18), (10, 29), (11, 3), (11, 6), (11, 20), (11, 21), 
(12, 4), (12, 6), (12, 13), (12, 30), (13, 4), (13, 5), (13, 30), (14, 4), 
(14, 15), (14, 31), (15, 4), (15, 8), (15, 20), (15, 31), (16, 22), (17, 22), 
(17, 12), (17, 9), (18, 11), (19, 23), (20, 25), (20, 6), (20, 26), (21, 23), 
(21, 9), (21, 10), (21, 27), (22, 24), (22, 9), (22, 19), (23, 23), (23, 19), 
(24, 37), (25, 38), (26, 36), (27, 39), (28, 1), (28, 15), (29, 1), (29, 16), 
(29, 31), (29, 12), (30, 1), (30, 22), (30, 12), (30, 9), (31, 1), (31, 43), 
(32, 1), (32, 40), (33, 1), (33, 41), (34, 1), (34, 12), (34, 61), (34, 17), 
(34, 42), (35, 1), (35, 10), (35, 18), (36, 1), (36, 44), (37, 1), (37, 8), 
(38, 1), (38, 5), (38, 12), (38, 61), (38, 17), (38, 42), (38, 41), (38, 6), 
(39, 2), (39, 45), (40, 2), (40, 45), (40, 12), (41, 60), (41, 5), (42, 22), 
(42, 12), (43, 23), (43, 8), (44, 23), (44, 46), (45, 12), (45, 10), (45, 20), 
(46, 10), (46, 18), (47, 47), (47, 48), (47, 49), (48, 50), (49, 51), (50, 52), 
(51, 53), (52, 54), (53, 55), (54, 56), (55, 57), (56, 58), (57, 59);


-- =========================================================================
-- INSERÇÃO DOS 30 PEDIDOS
-- =========================================================================

INSERT INTO `pedidos` (`id`, `id_usuario`, `codigo`, `status`, `total_pedido`, `taxa_entrega`, `forma_pagamento`, `cep`, `data`) VALUES
(1, 1, 'PFM-20261001-1001', 'entregue', 18.00, 5.00, 'PIX', 'Rua das Flores, N 123 - Centro (CEP: 13880-000)', DATE_SUB(NOW(), INTERVAL 30 DAY)),
(2, 1, 'PFM-20261002-1002', 'entregue', 20.00, 5.00, 'Cartão de Crédito', 'Av. Principal, N 45 - Bairro Alto (CEP: 13880-111)', DATE_SUB(NOW(), INTERVAL 29 DAY)),
(3, 1, 'PFM-20261003-1003', 'entregue', 40.00, 5.00, 'Dinheiro (Troco para R$ 50,00)', 'Rua Sete, N 77 - Vila Nova (CEP: 13880-222)', DATE_SUB(NOW(), INTERVAL 28 DAY)),
(4, 1, 'PFM-20261004-1004', 'entregue', 28.00, 5.00, 'PIX', 'Rua das Flores, N 123 - Centro (CEP: 13880-000)', DATE_SUB(NOW(), INTERVAL 27 DAY)),
(5, 1, 'PFM-20261005-1005', 'entregue', 15.00, 5.00, 'Cartão de Débito', 'Av. Principal, N 45 - Bairro Alto (CEP: 13880-111)', DATE_SUB(NOW(), INTERVAL 26 DAY)),
(6, 1, 'PFM-20261006-1006', 'entregue', 54.00, 5.00, 'PIX', 'Rua São João, N 90 - Centro (CEP: 13880-333)', DATE_SUB(NOW(), INTERVAL 25 DAY)),
(7, 1, 'PFM-20261007-1007', 'entregue', 22.00, 5.00, 'Cartão de Crédito', 'Rua Sete, N 77 - Vila Nova (CEP: 13880-222)', DATE_SUB(NOW(), INTERVAL 24 DAY)),
(8, 1, 'PFM-20261008-1008', 'entregue', 38.00, 5.00, 'PIX', 'Rua das Flores, N 123 - Centro (CEP: 13880-000)', DATE_SUB(NOW(), INTERVAL 23 DAY)),
(9, 1, 'PFM-20261009-1009', 'entregue', 48.00, 5.00, 'Dinheiro', 'Av. Brasil, N 1500 - Jd. Europa (CEP: 13880-444)', DATE_SUB(NOW(), INTERVAL 22 DAY)),
(10, 1, 'PFM-20261010-1010', 'entregue', 27.00, 5.00, 'PIX', 'Rua São João, N 90 - Centro (CEP: 13880-333)', DATE_SUB(NOW(), INTERVAL 21 DAY)),
(11, 1, 'PFM-20261011-1011', 'entregue', 32.00, 5.00, 'Cartão de Débito', 'Av. Principal, N 45 - Bairro Alto (CEP: 13880-111)', DATE_SUB(NOW(), INTERVAL 20 DAY)),
(12, 1, 'PFM-20261012-1012', 'entregue', 18.00, 5.00, 'PIX', 'Rua das Flores, N 123 - Centro (CEP: 13880-000)', DATE_SUB(NOW(), INTERVAL 19 DAY)),
(13, 1, 'PFM-20261013-1013', 'entregue', 45.00, 5.00, 'Cartão de Crédito', 'Av. Brasil, N 1500 - Jd. Europa (CEP: 13880-444)', DATE_SUB(NOW(), INTERVAL 18 DAY)),
(14, 1, 'PFM-20261014-1014', 'entregue', 60.00, 5.00, 'PIX', 'Rua Sete, N 77 - Vila Nova (CEP: 13880-222)', DATE_SUB(NOW(), INTERVAL 17 DAY)),
(15, 1, 'PFM-20261015-1015', 'entregue', 26.00, 5.00, 'Dinheiro (Troco para R$ 50,00)', 'Rua São João, N 90 - Centro (CEP: 13880-333)', DATE_SUB(NOW(), INTERVAL 16 DAY)),
(16, 1, 'PFM-20261016-1016', 'entregue', 20.00, 5.00, 'PIX', 'Rua das Acácias, N 10 - Bela Vista (CEP: 13880-555)', DATE_SUB(NOW(), INTERVAL 15 DAY)),
(17, 1, 'PFM-20261017-1017', 'entregue', 28.00, 5.00, 'Cartão de Crédito', 'Av. Independência, N 900 - Centro (CEP: 13880-000)', DATE_SUB(NOW(), INTERVAL 14 DAY)),
(18, 1, 'PFM-20261018-1018', 'entregue', 21.00, 5.00, 'Dinheiro', 'Rua Sete, N 77 - Vila Nova (CEP: 13880-222)', DATE_SUB(NOW(), INTERVAL 13 DAY)),
(19, 1, 'PFM-20261019-1019', 'entregue', 37.00, 5.00, 'PIX', 'Rua do Comércio, N 20 - Centro (CEP: 13880-000)', DATE_SUB(NOW(), INTERVAL 12 DAY)),
(20, 1, 'PFM-20261020-1020', 'entregue', 47.00, 5.00, 'Cartão de Débito', 'Av. Brasil, N 1500 - Jd. Europa (CEP: 13880-444)', DATE_SUB(NOW(), INTERVAL 11 DAY)),
(21, 1, 'PFM-20261021-1021', 'entregue', 36.00, 5.00, 'PIX', 'Rua São João, N 90 - Centro (CEP: 13880-333)', DATE_SUB(NOW(), INTERVAL 10 DAY)),
(22, 1, 'PFM-20261022-1022', 'entregue', 22.00, 5.00, 'PIX', 'Av. Principal, N 45 - Bairro Alto (CEP: 13880-111)', DATE_SUB(NOW(), INTERVAL 9 DAY)),
(23, 1, 'PFM-20261023-1023', 'entregue', 18.00, 5.00, 'Cartão de Crédito', 'Rua das Flores, N 123 - Centro (CEP: 13880-000)', DATE_SUB(NOW(), INTERVAL 8 DAY)),
(24, 1, 'PFM-20261024-1024', 'entregue', 76.00, 5.00, 'Dinheiro (Troco para R$ 100,00)', 'Rua Sete, N 77 - Vila Nova (CEP: 13880-222)', DATE_SUB(NOW(), INTERVAL 7 DAY)),
(25, 1, 'PFM-20261025-1025', 'entregue', 30.00, 5.00, 'PIX', 'Rua do Comércio, N 20 - Centro (CEP: 13880-000)', DATE_SUB(NOW(), INTERVAL 6 DAY)),
(26, 1, 'PFM-20261026-1026', 'entregue', 20.00, 5.00, 'Cartão de Crédito', 'Rua São João, N 90 - Centro (CEP: 13880-333)', DATE_SUB(NOW(), INTERVAL 5 DAY)),
(27, 1, 'PFM-20261027-1027', 'entregue', 42.00, 5.00, 'PIX', 'Av. Independência, N 900 - Centro (CEP: 13880-000)', DATE_SUB(NOW(), INTERVAL 4 DAY)),
(28, 1, 'PFM-20261028-1028', 'entregue', 27.00, 5.00, 'Cartão de Débito', 'Rua das Acácias, N 10 - Bela Vista (CEP: 13880-555)', DATE_SUB(NOW(), INTERVAL 3 DAY)),
(29, 1, 'PFM-20261029-1029', 'entregue', 44.00, 5.00, 'PIX', 'Av. Brasil, N 1500 - Jd. Europa (CEP: 13880-444)', DATE_SUB(NOW(), INTERVAL 2 DAY)),
(30, 1, 'PFM-20261030-1030', 'entregue', 60.00, 5.00, 'PIX', 'Rua das Flores, N 123 - Centro (CEP: 13880-000)', DATE_SUB(NOW(), INTERVAL 1 DAY));

INSERT INTO `pedido_itens` (`id_pedido`, `id_produto`, `quantidade`, `preco_unitario`) VALUES
(1, 1, 2, 9.00), (2, 12, 1, 20.00), (3, 16, 1, 28.00), (3, 27, 2, 6.00), 
(4, 16, 1, 28.00), (5, 5, 1, 10.00), (5, 25, 1, 5.00), (6, 26, 2, 7.00), 
(7, 14, 1, 22.00), (8, 2, 2, 9.00), (8, 12, 1, 20.00), (9, 18, 1, 48.00), 
(10, 1, 3, 9.00), (11, 17, 1, 34.00), (12, 8, 3, 6.00), (13, 15, 1, 25.00), 
(13, 5, 2, 10.00), (14, 18, 1, 48.00), (14, 27, 2, 6.00), (15, 13, 1, 20.00), 
(15, 24, 1, 6.00), (16, 6, 2, 10.00), (17, 20, 1, 22.00), (17, 27, 1, 6.00), 
(18, 11, 3, 7.00), (19, 19, 1, 27.00), (19, 25, 2, 5.00), (20, 12, 1, 20.00), 
(20, 26, 1, 7.00), (21, 3, 4, 9.00), (22, 22, 1, 22.00), (23, 9, 2, 7.00), 
(23, 24, 1, 6.00), (24, 18, 1, 48.00), (24, 16, 1, 28.00), (25, 10, 5, 6.00), 
(26, 7, 2, 10.00), (27, 13, 1, 20.00), (27, 21, 1, 22.00), (28, 4, 3, 9.00), 
(29, 17, 1, 34.00), (29, 27, 2, 6.00), (30, 8, 10, 6.00);
