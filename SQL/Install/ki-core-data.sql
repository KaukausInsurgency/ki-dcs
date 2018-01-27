-- MySQL dump 10.13  Distrib 5.7.17, for Win64 (x86_64)
--
-- Host: localhost    Database: ki
-- ------------------------------------------------------
-- Server version	5.7.20-log

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Dumping data for table `game_map`
--

LOCK TABLES `game_map` WRITE;
/*!40000 ALTER TABLE `game_map` DISABLE KEYS */;
INSERT INTO `game_map` VALUES (1,'Images/map/map-800x443.png',800,443,734650,-123282,238.636171875);
/*!40000 ALTER TABLE `game_map` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `map_layer`
--

LOCK TABLES `map_layer` WRITE;
/*!40000 ALTER TABLE `map_layer` DISABLE KEYS */;
INSERT INTO `map_layer` VALUES (1,1,'Images/map/map-1880x1041.png',1880,1041),(2,1,'Images/map/map-2685x1487.png',2685,1487);
/*!40000 ALTER TABLE `map_layer` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `role_image`
--

LOCK TABLES `role_image` WRITE;
/*!40000 ALTER TABLE `role_image` DISABLE KEYS */;
INSERT INTO `role_image` VALUES (1,'Images/role/role-ka50-30x30.png','Ka-50'),(2,'Images/role/role-sample-30x30.png','AV8BNA'),(3,'Images/role/role-mi8-30x30.png','Mi-8MT'),(4,'Images/role/role-a10c-30x30.png','A-10C'),(5,'Images/role/role-a10c-30x30.png','A-10A'),(6,'Images/role/role-uh1h-30x30.png','UH-1H'),(7,'Images/role/role-su27-30x30.png','Su-27'),(8,'Images/role/role-su27-30x30.png','Su-33'),(9,'Images/role/role-su25-30x30.png','Su-25'),(10,'Images/role/role-su25-30x30.png','Su-25T'),(11,'Images/role/role-f15-30x30.png','F-15C'),(12,'Images/role/role-mig29-30x30.png','MiG-29S'),(13,'Images/role/role-m2000c-30x30.png','M-2000C'),(14,'Images/role/role-mig21-30x30.png','MiG21-bis'),(15,'Images/role/role-f5e3-30x30.png','F-5-E3'),(16,'Images/role/role-gazelle-30x30.png','SA342M'),(17,'Images/role/role-gci-30x30.png','GCI'),(18,'Images/role/role-none-30x30.png',''),(19,'Images/role/role-gci-30x30.png','forward_observer'),(20,'Images/role/role-spectator-30x30.png','Spectator'),(21,'Images/role/role-gazelle-30x30.png','SA342L'),(22,'Images/role/role-gazelle-30x30.png','SA342Mistral'),(23,'Images/role/role-sample-30x30.png','AJS37');
/*!40000 ALTER TABLE `role_image` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2018-01-27  0:59:21
