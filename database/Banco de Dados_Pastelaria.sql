CREATE DATABASE  IF NOT EXISTS `pastelaria_filhas_maria` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;
USE `pastelaria_filhas_maria`;
-- MySQL dump 10.13  Distrib 8.0.46, for Win64 (x86_64)
--
-- Host: localhost    Database: pastelaria_filhas_maria
-- ------------------------------------------------------
-- Server version	8.0.46

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `categorias`
--

DROP TABLE IF EXISTS `categorias`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `categorias` (
  `id` int NOT NULL AUTO_INCREMENT,
  `nome` varchar(100) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `categorias`
--

LOCK TABLES `categorias` WRITE;
/*!40000 ALTER TABLE `categorias` DISABLE KEYS */;
INSERT INTO `categorias` VALUES (1,'Pastéis Salgados'),(2,'Pastéis Doces'),(3,'Bebidas'),(4,'Salgados'),(5,'Panquecas'),(6,'Porções'),(7,'Caldos');
/*!40000 ALTER TABLE `categorias` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `favoritos`
--

DROP TABLE IF EXISTS `favoritos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `favoritos` (
  `id` int NOT NULL AUTO_INCREMENT,
  `id_usuario` int NOT NULL,
  `id_produto` int NOT NULL,
  PRIMARY KEY (`id`),
  KEY `id_usuario` (`id_usuario`),
  KEY `id_produto` (`id_produto`),
  CONSTRAINT `favoritos_ibfk_1` FOREIGN KEY (`id_usuario`) REFERENCES `usuario` (`id`) ON DELETE CASCADE,
  CONSTRAINT `favoritos_ibfk_2` FOREIGN KEY (`id_produto`) REFERENCES `produtos` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `favoritos`
--

LOCK TABLES `favoritos` WRITE;
/*!40000 ALTER TABLE `favoritos` DISABLE KEYS */;
/*!40000 ALTER TABLE `favoritos` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ingredientes`
--

DROP TABLE IF EXISTS `ingredientes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ingredientes` (
  `id` int NOT NULL AUTO_INCREMENT,
  `nome` varchar(100) NOT NULL,
  `em_estoque` tinyint(1) DEFAULT '1',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ingredientes`
--

LOCK TABLES `ingredientes` WRITE;
/*!40000 ALTER TABLE `ingredientes` DISABLE KEYS */;
INSERT INTO `ingredientes` VALUES (1,'Carne Moída Selecionada',1),(2,'Queijo Muçarela',1),(3,'Goiabada Cremosa',0);
/*!40000 ALTER TABLE `ingredientes` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `pedido_itens`
--

DROP TABLE IF EXISTS `pedido_itens`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `pedido_itens` (
  `id` int NOT NULL AUTO_INCREMENT,
  `id_pedido` int NOT NULL,
  `id_produto` int NOT NULL,
  `quantidade` int NOT NULL,
  `preco_unitario` decimal(10,2) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `id_pedido` (`id_pedido`),
  KEY `id_produto` (`id_produto`),
  CONSTRAINT `pedido_itens_ibfk_1` FOREIGN KEY (`id_pedido`) REFERENCES `pedidos` (`id`) ON DELETE CASCADE,
  CONSTRAINT `pedido_itens_ibfk_2` FOREIGN KEY (`id_produto`) REFERENCES `produtos` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `pedido_itens`
--

LOCK TABLES `pedido_itens` WRITE;
/*!40000 ALTER TABLE `pedido_itens` DISABLE KEYS */;
/*!40000 ALTER TABLE `pedido_itens` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `pedidos`
--

DROP TABLE IF EXISTS `pedidos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `pedidos` (
  `id` int NOT NULL AUTO_INCREMENT,
  `id_usuario` int NOT NULL,
  `codigo` varchar(20) NOT NULL,
  `status` enum('recebido','em preparação','enviado','entregue') DEFAULT 'recebido',
  `total_pedido` decimal(10,2) NOT NULL,
  `taxa_entrega` decimal(10,2) DEFAULT '5.00',
  `forma_pagamento` varchar(50) NOT NULL,
  `cep` varchar(20) DEFAULT NULL,
  `data` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `id_usuario` (`id_usuario`),
  CONSTRAINT `pedidos_ibfk_1` FOREIGN KEY (`id_usuario`) REFERENCES `usuario` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `pedidos`
--

LOCK TABLES `pedidos` WRITE;
/*!40000 ALTER TABLE `pedidos` DISABLE KEYS */;
/*!40000 ALTER TABLE `pedidos` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `produto_ingredientes`
--

DROP TABLE IF EXISTS `produto_ingredientes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `produto_ingredientes` (
  `id` int NOT NULL AUTO_INCREMENT,
  `id_produto` int NOT NULL,
  `id_ingrediente` int NOT NULL,
  PRIMARY KEY (`id`),
  KEY `id_produto` (`id_produto`),
  KEY `id_ingrediente` (`id_ingrediente`),
  CONSTRAINT `produto_ingredientes_ibfk_1` FOREIGN KEY (`id_produto`) REFERENCES `produtos` (`id`) ON DELETE CASCADE,
  CONSTRAINT `produto_ingredientes_ibfk_2` FOREIGN KEY (`id_ingrediente`) REFERENCES `ingredientes` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `produto_ingredientes`
--

LOCK TABLES `produto_ingredientes` WRITE;
/*!40000 ALTER TABLE `produto_ingredientes` DISABLE KEYS */;
INSERT INTO `produto_ingredientes` VALUES (1,1,1),(2,2,2),(3,2,3),(4,10,3);
/*!40000 ALTER TABLE `produto_ingredientes` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `produtos`
--

DROP TABLE IF EXISTS `produtos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `produtos` (
  `id` int NOT NULL AUTO_INCREMENT,
  `nome` varchar(100) NOT NULL,
  `preco` decimal(10,2) NOT NULL,
  `descricao` text,
  `imagem` varchar(255) DEFAULT NULL,
  `id_categoria` int DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `id_categoria` (`id_categoria`),
  CONSTRAINT `produtos_ibfk_1` FOREIGN KEY (`id_categoria`) REFERENCES `categorias` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `usuario`
--

DROP TABLE IF EXISTS `usuario`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `usuario` (
  `id` int NOT NULL AUTO_INCREMENT,
  `nome` varchar(100) NOT NULL,
  `email` varchar(100) NOT NULL,
  `telefone` varchar(20) DEFAULT NULL,
  `senha` varchar(255) NOT NULL,
  `tipo_usuario` enum('cliente','admin') DEFAULT 'admin',
  PRIMARY KEY (`id`),
  UNIQUE KEY `email` (`email`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `usuario`
--

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;


INSERT INTO produtos (nome, preco, descricao, imagem, id_categoria) VALUES
('Pastel de Carne', 9.00, NULL, '1791921621572-779030691.png', 1),
('Pastel de Queijo', 9.00, NULL, '1791897780710-124221248.png', 1),
('Pastel Frango c/ Catupiry', 9.00, NULL, '1791897920203-717386132.png', 1),
('Pastel de Brocolis c/ Queijo', 9.00, NULL, '1791897832276-898620236.png', 1),
('Pastel de Chocolate', 10.00, NULL, '1791897881463-955293598.png', 2),
('Pastel de Banana c/ Canela', 10.00, NULL, '1791897807049-635174194.png', 2),
('Pastel Romeu e Julieta', 10.00, NULL, '1791897941088-281111386.png', 2),
('Coxinha', 6.00, NULL, '1791897491272-391592266.png', 4),
('Hambúrguer', 6.00, NULL, '1791897578703-276559359.png', 4),
('Kibe', 6.00, NULL, '1791897611104-172852338.png', 4),
('Empada', 7.00, NULL, '1791897526539-131690826.png', 4),
('Panqueca Frango c/ Catupiry', 20.00, NULL, '1791897754242-410742021.png', 5),
('Panqueca de Carne', 20.00, NULL, '1791897721724-620790940.png', 5),
('Panqueca Queijo Canastra', 22.00, NULL, '1791915686735-669127710.png', 5),
('Panqueca de Bacalhau', 25.00, NULL, '1791897675195-389867088.png', 5),
('Batata Frita', 28.00, NULL, '1791897278352-744960985.png', 6),
('Batata Frita c/ Queijo e Bacon', 32.00, NULL, '1791897296862-313999461.png', 6),
('Torresmo', 48.00, NULL, '1791897995364-328445823.png', 6),
('Mandioca Frita', 27.00, NULL, '1791897644841-889332534.png', 6),
('Caldo de Canja', 22.00, NULL, '1791897347445-271618100.png', 7),
('Caldo de Mandioca c/ Bacon', 22.00, NULL, '1791897423975-206695166.png', 7),
('Caldo de Feijão c/ Bacon', 22.00, NULL, '1791897370392-757541276.png', 7),
('Caldo de Mandioca', 22.00, NULL, '1791897402306-563631902.png', 7),
('H2O', 6.00, NULL, '1791897550880-601784906.png', 3),
('Cerveja Itaipava Lata', 5.00, NULL, '1791897472651-579046241.png', 3),
('Suco de Laranja Natural', 27.00, NULL, '1791897978491-793378490.png', 3),
('Refrigerante Lata', 6.00, NULL, '1791897959525-219335783.png', 3);

INSERT INTO ingredientes (nome) VALUES
('Massa de pastel'),
('Carne moída temperada'),
('Azeitona'),
('Cebola'),
('Queijo mussarela'),
('Orégano'),
('Frango desfiado temperado'),
('Legítimo Catupiry'),
('Brócolis fresco'),
('Alho frito'),
('Chocolate ao leite derretido'),
('Açúcar de confeiteiro'),
('Banana fatiada'),
('Açúcar'),
('Canela em pó'),
('Goiabada cremosa'),
('Queijo branco (Minas)'),
('Massa de farinha com caldo de frango'),
('Farinha de rosca para empanar'),
('Massa de salgado assado'),
('Hambúrguer de carne bovina'),
('Tomate'),
('Carne moída'),
('Trigo para kibe'),
('Hortelã fresca'),
('Temperos árabes'),
('Massa podre'),
('Frango desfiado cremoso'),
('Ervilha'),
('Massa fina de panqueca'),
('Frango desfiado'),
('Catupiry'),
('Molho de tomate artesanal'),
('Queijo ralado'),
('Carne moída bem temperada'),
('Salsinha'),
('Queijo Canastra artesanal derretido'),
('Molho branco'),
('Noz-moscada'),
('Bacalhau desfiado'),
('Azeite de oliva'),
('Azeitonas pretas'),
('Batata palito cortada na hora'),
('Sal'),
('Acompanha maionese da casa'),
('Batata palito'),
('Mix de queijos derretidos'),
('Cubos de bacon crocante'),
('Panceta de porco'),
('Limão para acompanhar'),
('Mandioca cozida e frita'),
('Manteiga de garrafa'),
('Arroz'),
('Peito de frango desfiado'),
('Cenoura'),
('Batata'),
('Cheiro-verde'),
('Creme de mandioca'),
('Bacon frito'),
('Calabresa defumada'),
('Couve picadinha'),
('Feijão carioca ou preto batido'),
('Bacon crocante'),
('Cebolinha'),
('Creme de mandioca (aipim)'),
('Alho dourado'),
('Azeite'),
('Cheiro-verde fresco'),
('Água gaseificada'),
('Suco de limão'),
('Edulcorantes'),
('Água'),
('Malte'),
('Cereais não maltados'),
('Lúpulo'),
('Laranjas frescas espremidas na hora'),
('Gelo'),
('Açúcar (opcional)'),
('Extrato natural (Coca/Guaraná)');

INSERT INTO produto_ingredientes (id_produto, id_ingrediente) VALUES
/* Pastel de Carne (ID 11) */
(11, 4), (11, 5), (11, 6), (11, 7),
/* Pastel de Queijo (ID 12) */
(12, 4), (12, 8), (12, 9),
/* Pastel Frango c/ Catupiry (ID 13) */
(13, 4), (13, 10), (13, 11),
/* Pastel de Brocolis c/ Queijo (ID 14) */
(14, 4), (14, 12), (14, 8), (14, 13),
/* Pastel de Chocolate (ID 15) */
(15, 4), (15, 14), (15, 15),
/* Pastel de Banana c/ Canela (ID 16) */
(16, 4), (16, 16), (16, 17), (16, 18),
/* Pastel Romeu e Julieta (ID 17) */
(17, 4), (17, 19), (17, 20),
/* Coxinha (ID 18) */
(18, 21), (18, 10), (18, 22),
/* Hambúrguer (ID 19) */
(19, 23), (19, 24), (19, 8), (19, 25), (19, 9),
/* Kibe (ID 20) */
(20, 26), (20, 27), (20, 28), (20, 7), (20, 29),
/* Empada (ID 21) */
(21, 30), (21, 31), (21, 6), (21, 32),
/* Panqueca Frango c/ Catupiry (ID 22) */
(22, 33), (22, 34), (22, 35), (22, 36), (22, 37),
/* Panqueca de Carne (ID 23) */
(23, 33), (23, 38), (23, 36), (23, 39),
/* Panqueca Queijo Canastra (ID 24) */
(24, 33), (24, 40), (24, 41), (24, 42),
/* Panqueca de Bacalhau (ID 25) */
(25, 33), (25, 43), (25, 44), (25, 45), (25, 41),
/* Batata Frita (ID 26) */
(26, 46), (26, 47), (26, 48),
/* Batata Frita c/ Queijo e Bacon (ID 27) */
(27, 49), (27, 50), (27, 51),
/* Torresmo (ID 28) */
(28, 52), (28, 47), (28, 53),
/* Mandioca Frita (ID 29) */
(29, 54), (29, 55), (29, 47),
/* Caldo de Canja (ID 30) */
(30, 56), (30, 57), (30, 58), (30, 59), (30, 60),
/* Caldo de Mandioca c/ Bacon (ID 31) */
(31, 61), (31, 62), (31, 63), (31, 64),
/* Caldo de Feijão c/ Bacon (ID 32) */
(32, 65), (32, 66), (32, 13), (32, 67),
/* Caldo de Mandioca (ID 33) */
(33, 68), (33, 69), (33, 70), (33, 71),
/* H2O (ID 34) */
(34, 72), (34, 73), (34, 74),
/* Cerveja Itaipava Lata (ID 35) */
(35, 75), (35, 76), (35, 77), (35, 78),
/* Suco de Laranja Natural (ID 36) */
(36, 79),
/* Refrigerante Lata (ID 37) */
(37, 72), (37, 17), (37, 82);

INSERT INTO `usuario` VALUES (1, 'admin', 'admin@admin', '99999999999', '$2b$10$jiH4nYEZjghBih6boYZmEOv2zo9fqDhs/Tv0liV/4VuynHR0ueZx2', 'admin');

-- Dump completed on 2026-10-13  8:10:14
