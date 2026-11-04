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
INSERT INTO `categorias` VALUES (1,'Pastéis Salgados'),(2,'Pastéis Doces'),(3,'Panquecas'),(4,'Salgados'),(5,'Porções'),(6,'Caldos'),(7,'Bebidas');
/*!40000 ALTER TABLE `categorias` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `enderecos`
--

DROP TABLE IF EXISTS `enderecos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
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
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `enderecos`
--

LOCK TABLES `enderecos` WRITE;
/*!40000 ALTER TABLE `enderecos` DISABLE KEYS */;
INSERT INTO `enderecos` VALUES (1,1,'13884-282','Rua Francisco Zanquetta','70','Vila Santana','Vargem Grande do Sul','SP');
/*!40000 ALTER TABLE `enderecos` ENABLE KEYS */;
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
  CONSTRAINT `fk_favoritos_produto` FOREIGN KEY (`id_produto`) REFERENCES `produtos` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_favoritos_usuario` FOREIGN KEY (`id_usuario`) REFERENCES `usuario` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
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
) ENGINE=InnoDB AUTO_INCREMENT=62 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ingredientes`
--

LOCK TABLES `ingredientes` WRITE;
/*!40000 ALTER TABLE `ingredientes` DISABLE KEYS */;
INSERT INTO `ingredientes` VALUES (1,'Massa de pastel',1),(2,'Massa de salgado',1),(3,'Massa podre (Empada)',1),(4,'Massa de panqueca',1),(5,'Carne moída',1),(6,'Frango desfiado',1),(7,'Hambúrguer bovino',1),(8,'Bacalhau desfiado',1),(9,'Bacon',1),(10,'Calabresa',1),(11,'Panceta suína (Torresmo)',1),(12,'Queijo mussarela',1),(13,'Catupiry',1),(14,'Queijo Minas (Branco)',1),(15,'Queijo Canastra',1),(16,'Brócolis',1),(17,'Tomate',1),(18,'Cebola',1),(19,'Alho',1),(20,'Azeitona',1),(21,'Ervilha',1),(22,'Batata palito',1),(23,'Mandioca (Aipim)',1),(24,'Feijão',1),(25,'Arroz',1),(26,'Cenoura',1),(27,'Couve',1),(28,'Trigo para kibe',1),(29,'Hortelã',1),(30,'Molho de tomate',1),(31,'Molho branco',1),(32,'Chocolate ao leite',1),(33,'Goiabada cremosa',1),(34,'Banana',1),(35,'Canela em pó',1),(36,'Laranja fresca',1),(37,'H2O Limão',1),(38,'Cerveja Itaipava',1),(39,'Refrigerante Lata',1),(40,'Camarão',1),(41,'Palmito',1),(42,'Orégano',1),(43,'Strogonoff de Carne Bovina',1),(44,'Strogonoff de Frango',1),(45,'Salsicha',1),(46,'Carne Seca',1),(47,'Mandioquinha Salsa',1),(48,'Tomate Seco',1),(49,'Rúcula',1),(50,'Garrafa Brahma/Skol/Sub Zero',1),(51,'Cerveja sem Álcool',1),(52,'Refrigerante Maçã 2L',1),(53,'Refrigerante Mogi 600ml',1),(54,'Refrigerante KS',1),(55,'Refrigerante Mogi Pet',1),(56,'Coca-Cola 1L',1),(57,'Guaraná Antarctica 1L',1),(58,'Coca/Guaraná 2L',1),(59,'Água Mineral',1),(60,'Massa de croquete',1),(61,'Presunto',1);
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
  CONSTRAINT `fk_itens_pedido` FOREIGN KEY (`id_pedido`) REFERENCES `pedidos` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_itens_produto` FOREIGN KEY (`id_produto`) REFERENCES `produtos` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=62 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `pedido_itens`
--

LOCK TABLES `pedido_itens` WRITE;
/*!40000 ALTER TABLE `pedido_itens` DISABLE KEYS */;
INSERT INTO `pedido_itens` VALUES (1,1,1,2,9.00),(2,2,12,1,20.00),(3,3,16,1,28.00),(4,3,27,2,6.00),(5,4,16,1,28.00),(6,5,5,1,10.00),(7,5,25,1,5.00),(8,6,26,2,7.00),(9,7,14,1,22.00),(10,8,2,2,9.00),(11,8,12,1,20.00),(12,9,18,1,48.00),(13,10,1,3,9.00),(14,11,17,1,34.00),(15,12,8,3,6.00),(16,13,15,1,25.00),(17,13,5,2,10.00),(18,14,18,1,48.00),(19,14,27,2,6.00),(20,15,13,1,20.00),(21,15,24,1,6.00),(22,16,6,2,10.00),(23,17,20,1,22.00),(24,17,27,1,6.00),(25,18,11,3,7.00),(26,19,19,1,27.00),(27,19,25,2,5.00),(28,20,12,1,20.00),(29,20,26,1,7.00),(30,21,3,4,9.00),(31,22,22,1,22.00),(32,23,9,2,7.00),(33,23,24,1,6.00),(34,24,18,1,48.00),(35,24,16,1,28.00),(36,25,10,5,6.00),(37,26,7,2,10.00),(38,27,13,1,20.00),(39,27,21,1,22.00),(40,28,4,3,9.00),(41,29,17,1,34.00),(42,29,27,2,6.00),(43,30,8,10,6.00),(44,31,3,1,9.00),(45,31,31,1,11.00),(46,31,4,1,9.00),(47,32,3,2,9.00),(48,33,1,2,9.00),(49,33,30,1,10.00),(50,33,32,1,12.00),(51,34,4,1,9.00),(52,34,28,1,9.00),(53,34,32,1,12.00),(54,35,3,4,9.00),(55,35,4,1,9.00),(56,35,28,1,9.00),(57,36,1,1,9.00),(58,36,33,2,9.00),(59,36,30,1,10.00),(60,37,3,1,9.00),(61,37,4,1,9.00);
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
  `cep` varchar(255) DEFAULT NULL,
  `data` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `id_usuario` (`id_usuario`),
  CONSTRAINT `fk_pedidos_usuario` FOREIGN KEY (`id_usuario`) REFERENCES `usuario` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=38 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `pedidos`
--

LOCK TABLES `pedidos` WRITE;
/*!40000 ALTER TABLE `pedidos` DISABLE KEYS */;
INSERT INTO `pedidos` VALUES (1,1,'PFM-20261001-1001','entregue',18.00,5.00,'PIX','Rua das Flores, N 123 - Centro (CEP: 13880-000)','2026-10-03 19:42:35'),(2,1,'PFM-20261002-1002','entregue',20.00,5.00,'Cartão de Crédito','Av. Principal, N 45 - Bairro Alto (CEP: 13880-111)','2026-10-04 19:42:35'),(3,1,'PFM-20261003-1003','entregue',40.00,5.00,'Dinheiro (Troco para R$ 50,00)','Rua Sete, N 77 - Vila Nova (CEP: 13880-222)','2026-10-05 19:42:35'),(4,1,'PFM-20261004-1004','entregue',28.00,5.00,'PIX','Rua das Flores, N 123 - Centro (CEP: 13880-000)','2026-10-06 19:42:35'),(5,1,'PFM-20261005-1005','entregue',15.00,5.00,'Cartão de Débito','Av. Principal, N 45 - Bairro Alto (CEP: 13880-111)','2026-10-07 19:42:35'),(6,1,'PFM-20261006-1006','entregue',54.00,5.00,'PIX','Rua São João, N 90 - Centro (CEP: 13880-333)','2026-10-08 19:42:35'),(7,1,'PFM-20261007-1007','entregue',22.00,5.00,'Cartão de Crédito','Rua Sete, N 77 - Vila Nova (CEP: 13880-222)','2026-10-09 19:42:35'),(8,1,'PFM-20261008-1008','entregue',38.00,5.00,'PIX','Rua das Flores, N 123 - Centro (CEP: 13880-000)','2026-10-10 19:42:35'),(9,1,'PFM-20261009-1009','entregue',48.00,5.00,'Dinheiro','Av. Brasil, N 1500 - Jd. Europa (CEP: 13880-444)','2026-10-11 19:42:35'),(10,1,'PFM-20261010-1010','entregue',27.00,5.00,'PIX','Rua São João, N 90 - Centro (CEP: 13880-333)','2026-10-12 19:42:35'),(11,1,'PFM-20261011-1011','entregue',32.00,5.00,'Cartão de Débito','Av. Principal, N 45 - Bairro Alto (CEP: 13880-111)','2026-10-13 19:42:35'),(12,1,'PFM-20261012-1012','entregue',18.00,5.00,'PIX','Rua das Flores, N 123 - Centro (CEP: 13880-000)','2026-10-14 19:42:35'),(13,1,'PFM-20261013-1013','entregue',45.00,5.00,'Cartão de Crédito','Av. Brasil, N 1500 - Jd. Europa (CEP: 13880-444)','2026-10-15 19:42:35'),(14,1,'PFM-20261014-1014','entregue',60.00,5.00,'PIX','Rua Sete, N 77 - Vila Nova (CEP: 13880-222)','2026-10-16 19:42:35'),(15,1,'PFM-20261015-1015','entregue',26.00,5.00,'Dinheiro (Troco para R$ 50,00)','Rua São João, N 90 - Centro (CEP: 13880-333)','2026-10-17 19:42:35'),(16,1,'PFM-20261016-1016','entregue',20.00,5.00,'PIX','Rua das Acácias, N 10 - Bela Vista (CEP: 13880-555)','2026-10-18 19:42:35'),(17,1,'PFM-20261017-1017','entregue',28.00,5.00,'Cartão de Crédito','Av. Independência, N 900 - Centro (CEP: 13880-000)','2026-10-19 19:42:35'),(18,1,'PFM-20261018-1018','entregue',21.00,5.00,'Dinheiro','Rua Sete, N 77 - Vila Nova (CEP: 13880-222)','2026-10-20 19:42:35'),(19,1,'PFM-20261019-1019','entregue',37.00,5.00,'PIX','Rua do Comércio, N 20 - Centro (CEP: 13880-000)','2026-10-21 19:42:35'),(20,1,'PFM-20261020-1020','entregue',47.00,5.00,'Cartão de Débito','Av. Brasil, N 1500 - Jd. Europa (CEP: 13880-444)','2026-10-22 19:42:35'),(21,1,'PFM-20261021-1021','entregue',36.00,5.00,'PIX','Rua São João, N 90 - Centro (CEP: 13880-333)','2026-10-23 19:42:35'),(22,1,'PFM-20261022-1022','entregue',22.00,5.00,'PIX','Av. Principal, N 45 - Bairro Alto (CEP: 13880-111)','2026-10-24 19:42:35'),(23,1,'PFM-20261023-1023','entregue',18.00,5.00,'Cartão de Crédito','Rua das Flores, N 123 - Centro (CEP: 13880-000)','2026-10-25 19:42:35'),(24,1,'PFM-20261024-1024','entregue',76.00,5.00,'Dinheiro (Troco para R$ 100,00)','Rua Sete, N 77 - Vila Nova (CEP: 13880-222)','2026-10-26 19:42:35'),(25,1,'PFM-20261025-1025','entregue',30.00,5.00,'PIX','Rua do Comércio, N 20 - Centro (CEP: 13880-000)','2026-10-27 19:42:35'),(26,1,'PFM-20261026-1026','entregue',20.00,5.00,'Cartão de Crédito','Rua São João, N 90 - Centro (CEP: 13880-333)','2026-10-28 19:42:35'),(27,1,'PFM-20261027-1027','entregue',42.00,5.00,'PIX','Av. Independência, N 900 - Centro (CEP: 13880-000)','2026-10-29 19:42:35'),(28,1,'PFM-20261028-1028','entregue',27.00,5.00,'Cartão de Débito','Rua das Acácias, N 10 - Bela Vista (CEP: 13880-555)','2026-10-30 19:42:35'),(29,1,'PFM-20261029-1029','entregue',44.00,5.00,'PIX','Av. Brasil, N 1500 - Jd. Europa (CEP: 13880-444)','2026-10-31 19:42:35'),(30,1,'PFM-20261030-1030','entregue',60.00,5.00,'PIX','Rua das Flores, N 123 - Centro (CEP: 13880-000)','2026-11-01 19:42:35'),(31,1,'PFM-20261102-4856','recebido',29.00,5.00,'PIX','Rua Francisco Zanquetta, Nº 70 - Vila Santana, Vargem Grande do Sul/SP (CEP: 13884-282)','2026-11-02 20:23:22'),(32,1,'PFM-20261102-9476','recebido',18.00,5.00,'PIX','Rua Francisco Zanquetta, Nº 70 - Vila Santana, Vargem Grande do Sul/SP (CEP: 13884-282)','2026-11-02 23:28:54'),(33,1,'PFM-20261102-1292','recebido',40.00,5.00,'PIX','Rua Francisco Zanquetta, Nº 70 - Vila Santana, Vargem Grande do Sul/SP (CEP: 13884-282)','2026-11-02 23:32:19'),(34,1,'PFM-20261102-4971','recebido',30.00,5.00,'PIX','Rua Francisco Zanquetta, Nº 70 - Vila Santana, Vargem Grande do Sul/SP (CEP: 13884-282)','2026-11-02 23:38:36'),(35,1,'PFM-20261103-2534','recebido',54.00,5.00,'PIX','Rua Francisco Zanquetta, Nº 70 - Vila Santana, Vargem Grande do Sul/SP (CEP: 13884-282)','2026-11-03 00:05:58'),(36,1,'PFM-20261103-8735','recebido',37.00,5.00,'PIX','Rua Francisco Zanquetta, Nº 70 - Vila Santana, Vargem Grande do Sul/SP (CEP: 13884-282)','2026-11-03 00:13:12'),(37,1,'PFM-20261103-3283','recebido',18.00,5.00,'PIX','Rua Francisco Zanquetta, Nº 70 - Vila Santana, Vargem Grande do Sul/SP (CEP: 13884-282)','2026-11-03 17:24:03');
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
  CONSTRAINT `fk_pi_ingrediente` FOREIGN KEY (`id_ingrediente`) REFERENCES `ingredientes` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_pi_produto` FOREIGN KEY (`id_produto`) REFERENCES `produtos` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=139 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `produto_ingredientes`
--

LOCK TABLES `produto_ingredientes` WRITE;
/*!40000 ALTER TABLE `produto_ingredientes` DISABLE KEYS */;
INSERT INTO `produto_ingredientes` VALUES (1,1,1),(2,1,5),(3,1,20),(4,1,18),(5,2,1),(6,2,12),(7,3,1),(8,3,6),(9,3,13),(10,4,1),(11,4,16),(12,4,12),(13,4,19),(14,5,1),(15,5,32),(16,6,1),(17,6,34),(18,6,35),(19,7,1),(20,7,33),(21,7,14),(22,8,2),(23,8,6),(24,9,2),(25,9,7),(26,9,12),(27,9,17),(28,10,5),(29,10,28),(30,10,18),(31,10,29),(32,11,3),(33,11,6),(34,11,20),(35,11,21),(36,12,4),(37,12,6),(38,12,13),(39,12,30),(40,13,4),(41,13,5),(42,13,30),(43,14,4),(44,14,15),(45,14,31),(46,15,4),(47,15,8),(48,15,20),(49,15,31),(50,16,22),(51,17,22),(52,17,12),(53,17,9),(54,18,11),(55,19,23),(56,20,25),(57,20,6),(58,20,26),(59,21,23),(60,21,9),(61,21,10),(62,21,27),(63,22,24),(64,22,9),(65,22,19),(66,23,23),(67,23,19),(68,24,37),(69,25,38),(70,26,36),(71,27,39),(72,28,1),(73,28,15),(74,29,1),(75,29,16),(76,29,31),(77,29,12),(78,30,1),(79,30,22),(80,30,12),(81,30,9),(82,31,1),(83,31,43),(84,32,1),(85,32,40),(86,33,1),(87,33,41),(88,34,1),(89,34,12),(90,34,61),(91,34,17),(92,34,42),(93,35,1),(94,35,10),(95,35,18),(96,36,1),(97,36,44),(98,37,1),(99,37,8),(100,38,1),(101,38,5),(102,38,12),(103,38,61),(104,38,17),(105,38,42),(106,38,41),(107,38,6),(108,39,2),(109,39,45),(110,40,2),(111,40,45),(112,40,12),(113,41,60),(114,41,5),(115,42,22),(116,42,12),(117,43,23),(118,43,8),(119,44,23),(120,44,46),(121,45,12),(122,45,10),(123,45,20),(124,46,10),(125,46,18),(126,47,47),(127,47,48),(128,47,49),(129,48,50),(130,49,51),(131,50,52),(132,51,53),(133,52,54),(134,53,55),(135,54,56),(136,55,57),(137,56,58),(138,57,59);
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
  `imagem` varchar(255) DEFAULT 'default.png',
  `id_categoria` int DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `id_categoria` (`id_categoria`),
  CONSTRAINT `fk_produtos_categoria` FOREIGN KEY (`id_categoria`) REFERENCES `categorias` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=58 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `produtos`
--

LOCK TABLES `produtos` WRITE;
/*!40000 ALTER TABLE `produtos` DISABLE KEYS */;
INSERT INTO `produtos` VALUES (1,'Pastel de Carne',9.00,'1792466318323-180478849.jpg',1),(2,'Pastel de Queijo',9.00,'1792469059542-870244860.jpg',1),(3,'Pastel Frango c/ Catupiry',9.00,'1792466355530-183041118.jpg',1),(4,'Pastel de Brócolis c/ Queijo',9.00,'1792466772515-351766605.jpg',1),(5,'Pastel de Chocolate',10.00,'1792466786648-259196785.jpg',2),(6,'Pastel de Banana c/ Canela',10.00,'1792466813308-981902952.jpg',2),(7,'Pastel Romeu e Julieta',10.00,'1792466824703-425610835.jpg',2),(8,'Coxinha',6.00,'1792466834736-33420290.jpg',4),(9,'Hamburgão',7.00,'1792466854394-331278635.jpg',4),(10,'Kibe',6.00,'1792466876461-880224488.jpg',4),(11,'Empada',7.00,'1792466886525-351426801.jpg',4),(12,'Panqueca Frango c/ Catupiry',20.00,'1792466897201-436724526.jpg',3),(13,'Panqueca de Carne',20.00,'1792466908723-56330089.jpg',3),(14,'Panqueca Queijo Canastra',22.00,'1792466921569-764956461.jpg',3),(15,'Panqueca de Bacalhau',25.00,'1792466931578-875824073.jpg',3),(16,'Batata Frita',28.00,'1792466944881-749981715.jpg',5),(17,'Batata Frita c/ Queijo e Bacon',34.00,'1792466953694-940458647.jpg',5),(18,'Torresmo',48.00,'1792466963693-670496048.jpg',5),(19,'Mandioca Frita',27.00,'1792466974480-734664559.jpg',5),(20,'Caldo de Canja',22.00,'1792466983376-477039642.jpg',6),(21,'Caldo de Mandioca c/ Bacon',22.00,'1792466999554-728515862.jpg',6),(22,'Caldo de Feijão c/ Bacon',22.00,'1792467019878-442655302.jpg',6),(23,'Caldo de Mandioca',22.00,'1792467029473-726495263.jpg',6),(24,'H2O',6.00,'1792467040703-742917118.jpg',7),(25,'Cerveja Itaipava Lata',5.00,'1792467052035-624950578.jpg',7),(26,'Suco de Laranja Natural',7.00,'1792467061589-405015406.jpg',7),(27,'Refrigerante Lata',6.00,'1792467072426-485463528.jpg',7),(28,'Pastel Queijo Canastra',9.00,'1792467083106-312474942.jpg',1),(29,'Pastel Brócolis c/ Molho Branco e Queijo',10.00,'1792467105934-64885767.jpg',1),(30,'Pastel Batata c/ Queijo e Bacon',10.00,'1792467160430-7981880.jpg',1),(31,'Pastel Strogonoff de Carne',11.00,'1792467173932-492568319.jpg',1),(32,'Pastel de Camarão',12.00,'1792467184939-577004660.jpg',1),(33,'Pastel de Palmito',9.00,'1792467199563-642826505.jpg',1),(34,'Pastel Sabor Pizza',9.00,'1792467216074-99743482.jpg',1),(35,'Pastel de Calabresa',9.00,'1792467227037-526425102.jpg',1),(36,'Pastel Strogonoff de Frango',10.00,'1792467245386-476457125.jpg',1),(37,'Pastel de Bacalhau',12.00,'1792467259225-181076737.jpg',1),(38,'Pastel X-Tudo',19.00,'1792467269738-617195916.jpg',1),(39,'Espeto',6.00,'1792467278921-542946773.jpg',4),(40,'Enroladinho',6.00,'1792467293404-676705853.jpg',4),(41,'Croquete',6.00,'1792467304486-295432429.jpg',4),(42,'Porção Batata com Queijo',32.00,'1792467315789-907984762.jpg',5),(43,'Bolinho Mandioca com Bacalhau',29.00,'1792467327643-449853640.jpg',5),(44,'Bolinho Mandioca com Carne Seca',29.00,'1792467337747-125670972.jpg',5),(45,'Porção Tira Gosto',9.00,'1792467350147-94465474.jpg',5),(46,'Porção Calabresa Acebolada',36.00,'1792467363270-338692651.jpg',5),(47,'Caldo Mandioquinha Salsa',22.00,'1792467374600-984269234.jpg',6),(48,'Cerveja Brahma/Skol/Sub Zero',6.00,'1792467385449-460502647.jpg',7),(49,'Cerveja sem Álcool',6.00,'1792467439927-86411339.jpg',7),(50,'Refrigerante Maçã 2L',8.00,'1792467447905-532662148.jpg',7),(51,'Refrigerante Mogi 600ml',4.00,'1792467455732-646817306.jpg',7),(52,'Refrigerante KS',4.50,'1792467463514-883715603.jpg',7),(53,'Refrigerante Mogi Pet',3.00,'1792467470610-960401905.jpg',7),(54,'Coca-Cola 1L',8.00,'1792467478541-718245527.jpg',7),(55,'Guaraná Antarctica 1L',8.00,'1792467485587-32256757.jpg',7),(56,'Coca/Guaraná Antarctica 2L',13.00,'1792467493529-265106684.jpg',7),(57,'Água Mineral',3.50,'1792467501331-153633839.jpg',7);
/*!40000 ALTER TABLE `produtos` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sessions`
--

DROP TABLE IF EXISTS `sessions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sessions` (
  `session_id` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL,
  `expires` int unsigned NOT NULL,
  `data` mediumtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin,
  PRIMARY KEY (`session_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sessions`
--

LOCK TABLES `sessions` WRITE;
/*!40000 ALTER TABLE `sessions` DISABLE KEYS */;
INSERT INTO `sessions` VALUES ('XUW38i3KEnoHCvCoxxGwD9mzp1r0HIA0',1793832206,'{\"cookie\":{\"originalMaxAge\":900000,\"expires\":\"2026-11-04T22:33:33.625Z\",\"httpOnly\":true,\"path\":\"/\"},\"usuarioLogado\":true,\"usuarioId\":1,\"userAdmin\":true,\"usuarioNome\":\"admin\"}'),('tYbUW0akRg1Mq-fBANWPTAf37zPcvcZe',1793834468,'{\"cookie\":{\"originalMaxAge\":900000,\"expires\":\"2026-11-04T23:21:02.472Z\",\"httpOnly\":true,\"path\":\"/\"},\"usuarioLogado\":true,\"usuarioId\":1,\"userAdmin\":true,\"usuarioNome\":\"admin\",\"cart\":[]}');
/*!40000 ALTER TABLE `sessions` ENABLE KEYS */;
UNLOCK TABLES;

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
  `tipo_usuario` enum('cliente','admin') DEFAULT 'cliente',
  PRIMARY KEY (`id`),
  UNIQUE KEY `email` (`email`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `usuario`
--

LOCK TABLES `usuario` WRITE;
/*!40000 ALTER TABLE `usuario` DISABLE KEYS */;
INSERT INTO `usuario` VALUES (1,'admin','admin@admin','99999999999','$2b$10$jiH4nYEZjghBih6boYZmEOv2zo9fqDhs/Tv0liV/4VuynHR0ueZx2','admin');
/*!40000 ALTER TABLE `usuario` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-11-04 20:13:56
