CREATE DATABASE  IF NOT EXISTS `vio_bonini` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;
USE `vio_bonini`;
-- MySQL dump 10.13  Distrib 8.0.36, for Win64 (x86_64)
--
-- Host: localhost    Database: vio_bonini
-- ------------------------------------------------------
-- Server version	8.0.36

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
-- Table structure for table `compra`
--

DROP TABLE IF EXISTS `compra`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `compra` (
  `id_compra` int NOT NULL AUTO_INCREMENT,
  `data_compra` datetime NOT NULL,
  `fk_id_usuario` int NOT NULL,
  PRIMARY KEY (`id_compra`),
  KEY `fk_id_usuario` (`fk_id_usuario`),
  CONSTRAINT `compra_ibfk_1` FOREIGN KEY (`fk_id_usuario`) REFERENCES `usuario` (`id_usuario`)
) ENGINE=InnoDB AUTO_INCREMENT=22 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `compra`
--

LOCK TABLES `compra` WRITE;
/*!40000 ALTER TABLE `compra` DISABLE KEYS */;
INSERT INTO `compra` VALUES (1,'2024-11-14 19:04:00',1),(2,'2024-11-13 17:00:00',1),(3,'2024-11-12 15:30:00',2),(4,'2024-11-11 14:20:00',2),(5,'2025-05-12 10:51:14',3),(6,'2025-05-12 13:10:30',4),(7,'2025-05-12 13:18:31',7),(8,'2025-05-12 13:26:04',7),(9,'2025-06-02 08:50:06',1),(10,'2025-06-02 08:50:27',1),(11,'2025-06-02 11:14:14',1),(12,'2025-06-02 11:15:00',1),(13,'2025-06-02 11:15:37',1),(14,'2025-06-02 11:15:45',1),(15,'2025-06-02 11:15:53',1),(16,'2025-06-02 11:16:00',1),(17,'2025-06-02 11:16:03',1),(19,'2025-06-02 11:24:17',1),(21,'2025-06-02 11:24:28',1);
/*!40000 ALTER TABLE `compra` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Temporary view structure for view `compras_por_usuario`
--

DROP TABLE IF EXISTS `compras_por_usuario`;
/*!50001 DROP VIEW IF EXISTS `compras_por_usuario`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `compras_por_usuario` AS SELECT 
 1 AS `usuario`,
 1 AS `evento`,
 1 AS `data_compra`,
 1 AS `tipo_ingresso`,
 1 AS `quantidade_vip`,
 1 AS `preco_total`*/;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `evento`
--

DROP TABLE IF EXISTS `evento`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `evento` (
  `id_evento` int NOT NULL AUTO_INCREMENT,
  `nome` varchar(100) NOT NULL,
  `descricao` varchar(255) NOT NULL,
  `data_hora` datetime NOT NULL,
  `local` varchar(255) NOT NULL,
  `fk_id_organizador` int NOT NULL,
  PRIMARY KEY (`id_evento`),
  KEY `fk_id_organizador` (`fk_id_organizador`),
  CONSTRAINT `evento_ibfk_1` FOREIGN KEY (`fk_id_organizador`) REFERENCES `organizador` (`id_organizador`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `evento`
--

LOCK TABLES `evento` WRITE;
/*!40000 ALTER TABLE `evento` DISABLE KEYS */;
INSERT INTO `evento` VALUES (1,'Festival de Verão','evento de verao','2024-12-15 00:00:00','Praia Central',1),(2,'Congresso de Tecnologia','Evento de tecnologia','2024-11-20 00:00:00','Centro de convencoes',2),(3,'Show Internacional','Evento internacional','2024-10-30 00:00:00','Arena Principal',3),(4,'Feira Cultural de Inverno','Evento cultural com música e gastronomia.','2025-07-20 00:00:00','Teatro Central',1);
/*!40000 ALTER TABLE `evento` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`alunods`@`%`*/ /*!50003 TRIGGER `impedir_alteracao_evento_passado` BEFORE UPDATE ON `evento` FOR EACH ROW begin 
    if old.data_hora < curdate() then
        signal sqlstate '45000'
        set message_text = 'Não é permitido alterar eventos que ocorreram.';
    end if;
end */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `ingresso`
--

DROP TABLE IF EXISTS `ingresso`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ingresso` (
  `id_ingresso` int NOT NULL AUTO_INCREMENT,
  `preco` decimal(5,2) NOT NULL,
  `tipo` varchar(10) NOT NULL,
  `fk_id_evento` int NOT NULL,
  PRIMARY KEY (`id_ingresso`),
  KEY `fk_id_evento` (`fk_id_evento`),
  CONSTRAINT `ingresso_ibfk_1` FOREIGN KEY (`fk_id_evento`) REFERENCES `evento` (`id_evento`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ingresso`
--

LOCK TABLES `ingresso` WRITE;
/*!40000 ALTER TABLE `ingresso` DISABLE KEYS */;
INSERT INTO `ingresso` VALUES (1,500.00,'vip',1),(2,150.00,'pista',1),(3,200.00,'pista',2),(4,600.00,'vip',3),(5,250.00,'pista',3),(6,120.00,'vip',4),(7,60.00,'pista',4);
/*!40000 ALTER TABLE `ingresso` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ingresso_compra`
--

DROP TABLE IF EXISTS `ingresso_compra`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ingresso_compra` (
  `id_ingresso_compra` int NOT NULL AUTO_INCREMENT,
  `quantidade` int NOT NULL,
  `fk_id_ingresso` int NOT NULL,
  `fk_id_compra` int NOT NULL,
  PRIMARY KEY (`id_ingresso_compra`),
  KEY `fk_id_ingresso` (`fk_id_ingresso`),
  KEY `fk_id_compra` (`fk_id_compra`),
  CONSTRAINT `ingresso_compra_ibfk_1` FOREIGN KEY (`fk_id_ingresso`) REFERENCES `ingresso` (`id_ingresso`),
  CONSTRAINT `ingresso_compra_ibfk_2` FOREIGN KEY (`fk_id_compra`) REFERENCES `compra` (`id_compra`)
) ENGINE=InnoDB AUTO_INCREMENT=22 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ingresso_compra`
--

LOCK TABLES `ingresso_compra` WRITE;
/*!40000 ALTER TABLE `ingresso_compra` DISABLE KEYS */;
INSERT INTO `ingresso_compra` VALUES (1,5,4,1),(2,2,5,1),(3,1,1,2),(4,2,2,2),(5,2,5,5),(6,10,7,8),(8,3,7,10),(9,2,6,12),(10,1,7,12),(11,2,6,14),(12,1,7,14),(13,2,6,15),(14,2,6,16),(15,1,7,16),(16,2,6,17),(17,1,7,17),(18,2,6,19),(19,1,7,19),(20,2,6,21),(21,1,7,21);
/*!40000 ALTER TABLE `ingresso_compra` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`alunods`@`%`*/ /*!50003 TRIGGER `verifica_data_evento` BEFORE INSERT ON `ingresso_compra` FOR EACH ROW begin
    declare data_evento datetime;

-- buscar data do evento
    select e.data_hora into data_evento 
    from ingresso i
    join 
    evento e on i.fk_id_evento = e.id_evento 
    where i.id_ingresso = new.fk_id_ingresso;

    -- Verificar se o evento já ocorreu
    if date(data_evento) < curdate() then
        signal sqlstate '45000'
        set message_text = 'Não é possível comprar ingressos para eventos passados.';
    end if;
end */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `organizador`
--

DROP TABLE IF EXISTS `organizador`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `organizador` (
  `id_organizador` int NOT NULL AUTO_INCREMENT,
  `nome` varchar(100) NOT NULL,
  `email` varchar(100) NOT NULL,
  `senha` varchar(50) NOT NULL,
  `telefone` char(11) NOT NULL,
  PRIMARY KEY (`id_organizador`),
  UNIQUE KEY `email` (`email`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `organizador`
--

LOCK TABLES `organizador` WRITE;
/*!40000 ALTER TABLE `organizador` DISABLE KEYS */;
INSERT INTO `organizador` VALUES (1,'Organizacao Abc','contato@abc.com','senha123','11111222333'),(2,'Eventos XYZ','info@xyz.com','senha123','11222333444'),(3,'Festivais BR','contato@festbr.com','senha123','11333444555'),(4,'Eventos GL','support@gl.com','senha123','11444555666'),(5,'Eventos JQ','contact@jq.com','senha123','11555666777');
/*!40000 ALTER TABLE `organizador` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `presenca`
--

DROP TABLE IF EXISTS `presenca`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `presenca` (
  `id_presenca` int NOT NULL AUTO_INCREMENT,
  `data_hora_checkin` datetime DEFAULT NULL,
  `fk_id_evento` int NOT NULL,
  `fk_id_compra` int NOT NULL,
  PRIMARY KEY (`id_presenca`),
  KEY `fk_id_evento` (`fk_id_evento`),
  KEY `fk_id_compra` (`fk_id_compra`),
  CONSTRAINT `presenca_ibfk_1` FOREIGN KEY (`fk_id_evento`) REFERENCES `evento` (`id_evento`),
  CONSTRAINT `presenca_ibfk_2` FOREIGN KEY (`fk_id_compra`) REFERENCES `compra` (`id_compra`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `presenca`
--

ALTER TABLE evento ADD imagem LONGBLOB;

LOCK TABLES `presenca` WRITE;
/*!40000 ALTER TABLE `presenca` DISABLE KEYS */;
/*!40000 ALTER TABLE `presenca` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `usuario`
--

DROP TABLE IF EXISTS `usuario`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `usuario` (
  `id_usuario` int NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  `email` varchar(100) NOT NULL,
  `password` varchar(255) NOT NULL,
  `cpf` char(11) NOT NULL,
  `data_nascimento` date NOT NULL,
  PRIMARY KEY (`id_usuario`),
  UNIQUE KEY `email` (`email`),
  UNIQUE KEY `cpf` (`cpf`)
) ENGINE=InnoDB AUTO_INCREMENT=42 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `usuario`
--

LOCK TABLES `usuario` WRITE;
/*!40000 ALTER TABLE `usuario` DISABLE KEYS */;
INSERT INTO `usuario` VALUES (1,'João Silva','joao.silva@example.com','$2b$10$zEhm/aUwxWbx1xymsPqZG.oYnlUqdjBBwRVT.sqtJe.SQDws1I5fe','16123456789','1990-01-15'),(41,'a','a@a','$2b$10$zEhm/aUwxWbx1xymsPqZG.oYnlUqdjBBwRVT.sqtJe.SQDws1I5fe','11111111110','2001-01-01');
/*!40000 ALTER TABLE `usuario` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping events for database 'vio_bonini'
--

--
-- Dumping routines for database 'vio_bonini'
--
/*!50003 DROP PROCEDURE IF EXISTS `registrar_compra` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`alunods`@`%` PROCEDURE `registrar_compra`(
    in p_id_usuario int,
    in p_id_ingresso int,
    in p_quantidade int
)
begin
    declare v_id_compra int;
    declare v_data_evento datetime;
    
    -- obtem a data do evento
    select e.data_hora into v_data_evento
    from ingresso i 
    join evento e on i.fk_id_evento = e.id_evento
	where i.id_ingresso  =  p_id_ingresso;
    
    -- verificar se a data do evento é menor que a atual
    if date(v_data_evento) < curdate() then
		signal sqlstate '45000'
        set message_text = 'ERRO_PROCEDURE - Não é possivel comprar ingressos para eventos passados';
	end if;
    
    -- Criar registro na tabela 'compra'
    insert into compra (data_compra, fk_id_usuario)
    values (now(), p_id_usuario);

    -- Obter o ID da compra recém-criada
    set v_id_compra = last_insert_id();

    -- Registrar os ingressos comprados
    insert into ingresso_compra (fk_id_compra, fk_id_ingresso, quantidade)
        values(v_id_compra, p_id_ingresso, p_quantidade);

end ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `registrar_compra2` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`alunods`@`%` PROCEDURE `registrar_compra2`(
    in p_id_ingresso int,
    in p_id_compra int,
    in p_quantidade int
)
begin
    declare v_data_evento datetime;
    
    -- obtem a data do evento
    select e.data_hora into v_data_evento
    from ingresso i 
    join evento e on i.fk_id_evento = e.id_evento
	where i.id_ingresso  =  p_id_ingresso;
    
    -- verificar se a data do evento é menor que a atual
    if date(v_data_evento) < curdate() then
		delete from ingresso_compra where fk_id_compra = p_id_compra;
        delete from compra where id_compra = p_id_compra;
		signal sqlstate '45000'
        set message_text = 'ERRO_PROCEDURE - Não é possivel comprar ingressos para eventos passados';
	end if;

    -- Registrar os ingressos comprados
    insert into ingresso_compra (fk_id_compra, fk_id_ingresso, quantidade)
        values(p_id_compra, p_id_ingresso, p_quantidade);

end ;;
DELIMITER ;

ALTER TABLE evento ADD tipo_imagem varchar(255);
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Final view structure for view `compras_por_usuario`
--

/*!50001 DROP VIEW IF EXISTS `compras_por_usuario`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`alunods`@`%` SQL SECURITY DEFINER */
/*!50001 VIEW `compras_por_usuario` (`usuario`,`evento`,`data_compra`,`tipo_ingresso`,`quantidade_vip`,`preco_total`) AS select `u`.`name` AS `Usuario`,`e`.`nome` AS `Evento`,`c`.`data_compra` AS `Data_compra`,`i`.`tipo` AS `Tipo_ingresso`,sum((case when (`i`.`tipo` = 'vip') then `ic`.`quantidade` else 0 end)) AS `Quantidade_VIP`,round(sum((`ic`.`quantidade` * `i`.`preco`)),2) AS `Preco_Total` from ((((`usuario` `u` join `compra` `c` on((`u`.`id_usuario` = `c`.`fk_id_usuario`))) join `ingresso_compra` `ic` on((`c`.`id_compra` = `ic`.`fk_id_compra`))) join `ingresso` `i` on((`ic`.`fk_id_ingresso` = `i`.`id_ingresso`))) join `evento` `e` on((`i`.`fk_id_evento` = `e`.`id_evento`))) group by `u`.`name`,`e`.`nome`,`c`.`data_compra`,`i`.`tipo` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2025-06-09  8:51:09