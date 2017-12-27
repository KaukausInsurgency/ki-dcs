CREATE DATABASE  IF NOT EXISTS `ki` /*!40100 DEFAULT CHARACTER SET utf8 */;
USE `ki`;
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
-- Table structure for table `capture_point`
--

DROP TABLE IF EXISTS `capture_point`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `capture_point` (
  `capture_point_id` int(11) NOT NULL AUTO_INCREMENT,
  `server_id` int(11) NOT NULL,
  `type` varchar(12) NOT NULL DEFAULT 'CAPTUREPOINT',
  `name` varchar(128) NOT NULL,
  `status` varchar(15) NOT NULL,
  `blue_units` int(11) NOT NULL,
  `red_units` int(11) NOT NULL,
  `max_capacity` int(11) NOT NULL,
  `latlong` varchar(30) NOT NULL,
  `mgrs` varchar(20) NOT NULL,
  `x` double NOT NULL DEFAULT '0',
  `y` double NOT NULL DEFAULT '0',
  `image` varchar(132) NOT NULL,
  `text` varchar(900) DEFAULT NULL,
  PRIMARY KEY (`capture_point_id`),
  KEY `FK_CP_ServerID_idx` (`server_id`),
  CONSTRAINT `FK_CP_ServerID` FOREIGN KEY (`server_id`) REFERENCES `server` (`server_id`) ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=306 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `depot`
--

DROP TABLE IF EXISTS `depot`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `depot` (
  `depot_id` int(11) NOT NULL AUTO_INCREMENT,
  `server_id` int(11) NOT NULL,
  `name` varchar(125) NOT NULL,
  `latlong` varchar(30) NOT NULL,
  `mgrs` varchar(20) NOT NULL,
  `current_capacity` int(11) NOT NULL,
  `capacity` int(11) NOT NULL,
  `resources` varchar(900) NOT NULL,
  `status` varchar(45) NOT NULL,
  `x` double NOT NULL DEFAULT '0',
  `y` double NOT NULL DEFAULT '0',
  `image` varchar(132) NOT NULL,
  PRIMARY KEY (`depot_id`),
  KEY `FK_ServerID_idx` (`server_id`),
  CONSTRAINT `FK_ServerID` FOREIGN KEY (`server_id`) REFERENCES `server` (`server_id`) ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=166 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `game_map`
--

DROP TABLE IF EXISTS `game_map`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `game_map` (
  `game_map_id` int(11) NOT NULL AUTO_INCREMENT,
  `server_id` int(11) NOT NULL,
  `base_image` varchar(132) NOT NULL,
  `resolution_x` double NOT NULL,
  `resolution_y` double NOT NULL,
  `dcs_origin_x` double NOT NULL,
  `dcs_origin_y` double NOT NULL,
  `ratio` double NOT NULL,
  PRIMARY KEY (`game_map_id`),
  KEY `fk_map_server_idx` (`server_id`),
  CONSTRAINT `fk_map_server` FOREIGN KEY (`server_id`) REFERENCES `server` (`server_id`) ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `map_layer`
--

DROP TABLE IF EXISTS `map_layer`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `map_layer` (
  `map_layer_id` int(11) NOT NULL AUTO_INCREMENT,
  `game_map_id` int(11) NOT NULL,
  `image` varchar(132) NOT NULL,
  `resolution_x` double NOT NULL,
  `resolution_y` double NOT NULL,
  PRIMARY KEY (`map_layer_id`),
  KEY `fk_gamemap_layer_idx` (`game_map_id`),
  CONSTRAINT `fk_gamemap_layer` FOREIGN KEY (`game_map_id`) REFERENCES `game_map` (`game_map_id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `online_players`
--

DROP TABLE IF EXISTS `online_players`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `online_players` (
  `server_id` int(11) NOT NULL,
  `ucid` varchar(128) NOT NULL,
  `name` varchar(128) NOT NULL,
  `role` varchar(45) NOT NULL,
  `side` int(10) NOT NULL,
  `ping` varchar(45) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `player`
--

DROP TABLE IF EXISTS `player`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `player` (
  `ucid` varchar(128) NOT NULL,
  `name` varchar(128) NOT NULL,
  `lives` int(11) NOT NULL,
  `banned` bit(1) NOT NULL,
  PRIMARY KEY (`ucid`),
  UNIQUE KEY `ucid_UNIQUE` (`ucid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `raw_connection_log`
--

DROP TABLE IF EXISTS `raw_connection_log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `raw_connection_log` (
  `id` bigint(32) unsigned NOT NULL AUTO_INCREMENT,
  `server_id` int(11) NOT NULL,
  `session_id` int(11) NOT NULL,
  `type` varchar(20) NOT NULL,
  `player_ucid` varchar(128) NOT NULL,
  `player_name` varchar(128) NOT NULL,
  `player_id` int(11) NOT NULL,
  `ip_address` varchar(20) NOT NULL,
  `game_time` bigint(32) NOT NULL,
  `real_time` bigint(32) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=356 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `raw_gameevents_log`
--

DROP TABLE IF EXISTS `raw_gameevents_log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `raw_gameevents_log` (
  `id` bigint(32) NOT NULL AUTO_INCREMENT,
  `server_id` int(11) NOT NULL,
  `session_id` bigint(32) NOT NULL,
  `sortie_id` bigint(32) DEFAULT NULL,
  `ucid` varchar(128) DEFAULT NULL,
  `event` varchar(45) NOT NULL,
  `player_name` varchar(128) NOT NULL,
  `player_side` int(11) DEFAULT NULL,
  `real_time` bigint(32) NOT NULL,
  `game_time` bigint(32) NOT NULL,
  `role` varchar(25) DEFAULT NULL,
  `location` varchar(60) DEFAULT NULL,
  `weapon` varchar(60) DEFAULT NULL,
  `weapon_category` varchar(20) DEFAULT NULL,
  `target_name` varchar(60) DEFAULT NULL,
  `target_model` varchar(60) DEFAULT NULL,
  `target_type` varchar(25) DEFAULT NULL,
  `target_category` varchar(15) DEFAULT NULL,
  `target_side` int(11) DEFAULT NULL,
  `target_is_player` bit(1) DEFAULT NULL,
  `target_player_ucid` varchar(128) DEFAULT NULL,
  `target_player_name` varchar(128) DEFAULT NULL,
  `transport_unloaded_count` int(11) DEFAULT NULL,
  `cargo` varchar(128) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1346 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `role_image`
--

DROP TABLE IF EXISTS `role_image`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `role_image` (
  `role_image_id` int(11) NOT NULL AUTO_INCREMENT,
  `image` varchar(132) NOT NULL,
  `role` varchar(45) NOT NULL,
  PRIMARY KEY (`role_image_id`)
) ENGINE=InnoDB AUTO_INCREMENT=19 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `server`
--

DROP TABLE IF EXISTS `server`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `server` (
  `server_id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(128) NOT NULL,
  `ip_address` varchar(40) NOT NULL,
  `restart_time` int(11) DEFAULT NULL,
  `status` varchar(10) DEFAULT NULL,
  `last_heartbeat` datetime DEFAULT NULL,
  PRIMARY KEY (`server_id`)
) ENGINE=InnoDB AUTO_INCREMENT=31 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `session`
--

DROP TABLE IF EXISTS `session`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `session` (
  `session_id` bigint(32) NOT NULL AUTO_INCREMENT,
  `server_id` int(11) NOT NULL,
  `start` datetime NOT NULL,
  `end` datetime DEFAULT NULL,
  `real_time_start` bigint(32) DEFAULT NULL,
  `real_time_end` bigint(32) DEFAULT NULL,
  PRIMARY KEY (`session_id`),
  KEY `server_id_idx` (`server_id`),
  CONSTRAINT `Session_ServerID` FOREIGN KEY (`server_id`) REFERENCES `server` (`server_id`) ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=515 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `side_mission`
--

DROP TABLE IF EXISTS `side_mission`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `side_mission` (
  `side_mission_id` int(11) NOT NULL AUTO_INCREMENT,
  `server_id` int(11) NOT NULL,
  `server_mission_id` int(11) NOT NULL,
  `task_name` varchar(128) NOT NULL,
  `task_desc` varchar(900) NOT NULL,
  `image` varchar(132) NOT NULL,
  `status` varchar(20) NOT NULL,
  `time_remaining` double NOT NULL,
  `latlong` varchar(30) NOT NULL,
  `mgrs` varchar(20) NOT NULL,
  `x` double NOT NULL DEFAULT '0',
  `y` double NOT NULL DEFAULT '0',
  `time_inactive` datetime DEFAULT NULL,
  PRIMARY KEY (`side_mission_id`),
  KEY `fk_server_id_idx` (`server_id`),
  CONSTRAINT `fk_server_id` FOREIGN KEY (`server_id`) REFERENCES `server` (`server_id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=40 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `sproc_log`
--

DROP TABLE IF EXISTS `sproc_log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `sproc_log` (
  `sproc` varchar(128) DEFAULT NULL,
  `text` varchar(5000) DEFAULT NULL,
  `time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping events for database 'ki'
--
/*!50106 SET @save_time_zone= @@TIME_ZONE */ ;
/*!50106 DROP EVENT IF EXISTS `e_DeleteInactiveMissions` */;
DELIMITER ;;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;;
/*!50003 SET character_set_client  = utf8 */ ;;
/*!50003 SET character_set_results = utf8 */ ;;
/*!50003 SET collation_connection  = utf8_general_ci */ ;;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;;
/*!50003 SET @saved_time_zone      = @@time_zone */ ;;
/*!50003 SET time_zone             = 'SYSTEM' */ ;;
/*!50106 CREATE*/ /*!50117 DEFINER=`root`@`localhost`*/ /*!50106 EVENT `e_DeleteInactiveMissions` ON SCHEDULE EVERY 5 MINUTE STARTS '2017-12-26 21:40:45' ON COMPLETION NOT PRESERVE ENABLE COMMENT 'Deletes inactive missions' DO DELETE FROM ki.side_mission
		WHERE status != "Active" AND fnc_GetMissionInactiveTimeInSeconds(side_mission_id) > 300 */ ;;
/*!50003 SET time_zone             = @saved_time_zone */ ;;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;;
/*!50003 SET character_set_client  = @saved_cs_client */ ;;
/*!50003 SET character_set_results = @saved_cs_results */ ;;
/*!50003 SET collation_connection  = @saved_col_connection */ ;;
/*!50106 DROP EVENT IF EXISTS `e_PlayerGainLife` */;;
DELIMITER ;;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;;
/*!50003 SET character_set_client  = utf8 */ ;;
/*!50003 SET character_set_results = utf8 */ ;;
/*!50003 SET collation_connection  = utf8_general_ci */ ;;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;;
/*!50003 SET @saved_time_zone      = @@time_zone */ ;;
/*!50003 SET time_zone             = 'SYSTEM' */ ;;
/*!50106 CREATE*/ /*!50117 DEFINER=`root`@`localhost`*/ /*!50106 EVENT `e_PlayerGainLife` ON SCHEDULE EVERY 1 HOUR STARTS '2017-12-15 14:19:05' ON COMPLETION NOT PRESERVE ENABLE COMMENT 'Restores 1 life to each player every hour' DO UPDATE ki.player
		SET lives = lives + 1
		WHERE lives < 5 */ ;;
/*!50003 SET time_zone             = @saved_time_zone */ ;;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;;
/*!50003 SET character_set_client  = @saved_cs_client */ ;;
/*!50003 SET character_set_results = @saved_cs_results */ ;;
/*!50003 SET collation_connection  = @saved_col_connection */ ;;
/*!50106 DROP EVENT IF EXISTS `e_ServerStatusCheck` */;;
DELIMITER ;;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;;
/*!50003 SET character_set_client  = utf8 */ ;;
/*!50003 SET character_set_results = utf8 */ ;;
/*!50003 SET collation_connection  = utf8_general_ci */ ;;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;;
/*!50003 SET @saved_time_zone      = @@time_zone */ ;;
/*!50003 SET time_zone             = 'SYSTEM' */ ;;
/*!50106 CREATE*/ /*!50117 DEFINER=`root`@`localhost`*/ /*!50106 EVENT `e_ServerStatusCheck` ON SCHEDULE EVERY 5 MINUTE STARTS '2017-12-15 15:49:29' ON COMPLETION NOT PRESERVE ENABLE COMMENT 'Checks the status of servers' DO UPDATE ki.server
		SET status = "Offline"
        WHERE fnc_GetLastHeartbeatInSeconds(server_id) > 300 AND status <> "Offline" */ ;;
/*!50003 SET time_zone             = @saved_time_zone */ ;;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;;
/*!50003 SET character_set_client  = @saved_cs_client */ ;;
/*!50003 SET character_set_results = @saved_cs_results */ ;;
/*!50003 SET collation_connection  = @saved_col_connection */ ;;
DELIMITER ;
/*!50106 SET TIME_ZONE= @save_time_zone */ ;

--
-- Dumping routines for database 'ki'
--
/*!50003 DROP FUNCTION IF EXISTS `fnc_GetAirportImage` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `fnc_GetAirportImage`(Type VARCHAR(7), Status VARCHAR(45)) RETURNS varchar(132) CHARSET utf8
BEGIN
	IF (Status = "Red" AND Type = "AIRPORT") THEN
		RETURN "Images/markers/airport-red-200x200.png";
	ELSEIF (Status = "Blue" AND Type = "AIRPORT") THEN
		RETURN "Images/markers/airport-blue-200x200.png";
	ELSEIF (Status = "Red" AND Type = "FARP") THEN
		RETURN "Images/markers/farp-red-200x200.png";
	ELSEIF (Status = "Blue" AND Type = "FARP") THEN
		RETURN "Images/markers/farp-blue-200x200.png";
	ELSE
		RETURN "";
    END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `fnc_GetCapturePointImage` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `fnc_GetCapturePointImage`(BlueUnits INT, RedUnits INT, Type VARCHAR(12)) RETURNS varchar(132) CHARSET utf8
BEGIN
	DECLARE ImgPath VARCHAR(15);
    DECLARE ImgType VARCHAR(7);
    DECLARE ImgRes VARCHAR(7);
	DECLARE ImgStatus VARCHAR(9);
    
    SET ImgPath = "Images/markers/";
   
	IF (Type = "CAPTUREPOINT") THEN
		SET ImgType = "flag";
        SET ImgRes = "256x256";
	ELSEIF (Type = "AIRPORT") THEN
		SET ImgType = "airport";
        SET ImgRes = "200x200";
	ELSEIF (Type = "FARP") THEN
		SET ImgType = "farp";
        SET ImgRes = "200x200";
	ELSE 
		SET ImgType = "flag";
        SET ImgRes = "256x256";
	END IF;
    
	IF (BlueUnits = 0 AND RedUnits = 0) THEN
		SET ImgStatus = "neutral";
	ELSEIF (BlueUnits > 0 AND RedUnits > 0) THEN
		SET ImgStatus = "contested";
	ELSEIF (BlueUnits > 0) THEN
		SET ImgStatus = "blue";
	ELSEIF (RedUnits > 0) THEN
		SET ImgStatus = "red";
    END IF;
    
    RETURN CONCAT(ImgPath, ImgType, "-", ImgStatus, "-", ImgRes, ".png");
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `fnc_GetDepotImage` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `fnc_GetDepotImage`(Status VARCHAR(45)) RETURNS varchar(132) CHARSET utf8
BEGIN
	IF (Status = "Online") THEN
		RETURN "Images/markers/depot-red-256x256.png";
	ELSEIF (Status = "Captured") THEN
		RETURN "Images/markers/depot-blue-256x256.png";
	ELSEIF (Status = "Contested") THEN
		RETURN "Images/markers/depot-contested-256x256.png";
	ELSE
		RETURN "";
    END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `fnc_GetLastHeartbeatInSeconds` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `fnc_GetLastHeartbeatInSeconds`( ServerID INT) RETURNS int(11)
BEGIN
	SET @LastHeartbeat = 0;
	SELECT TIME_TO_SEC( TIMEDIFF( NOW(), COALESCE(last_heartbeat, FROM_UNIXTIME(0)) )) INTO @LastHeartbeat
	FROM ki.server WHERE server_id = ServerID;
    
    RETURN @LastHeartbeat;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `fnc_GetMissionInactiveTimeInSeconds` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `fnc_GetMissionInactiveTimeInSeconds`( SideMissionID INT) RETURNS int(11)
BEGIN
	SET @TimeDiff = 0;
	SELECT TIME_TO_SEC( TIMEDIFF( NOW(), COALESCE(time_inactive, FROM_UNIXTIME(0)) )) INTO @TimeDiff
	FROM ki.side_mission WHERE side_mission_id = SideMissionID;
    
    RETURN @TimeDiff;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `fnc_GetRoleImage` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `fnc_GetRoleImage`(role VARCHAR(45)) RETURNS varchar(132) CHARSET utf8
BEGIN
	DECLARE RoleImage VARCHAR(132);
    SELECT COALESCE(ri.image, "Images/role/role-none-30x30.png") INTO RoleImage 
    FROM role_image ri WHERE ri.role = role;
    
	RETURN RoleImage;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `fnc_GetSideMissionImage` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `fnc_GetSideMissionImage`(Image VARCHAR(90), Status VARCHAR(40)) RETURNS varchar(132) CHARSET utf8
BEGIN
	DECLARE ImgPath VARCHAR(15);
    DECLARE ImgType VARCHAR(7);
    DECLARE ImgRes VARCHAR(7);
    
	DECLARE ImgStatus VARCHAR(9);
    
    SET ImgPath = "Images/markers/";
	SET ImgType = "task";
	SET ImgRes = "200x200";
    
    RETURN CONCAT(ImgPath, ImgType, "-", Image, "-", ImgRes, ".png");
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `fnc_HoursToSeconds` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `fnc_HoursToSeconds`(hours INT) RETURNS int(11)
BEGIN
	RETURN hours * POW(60, 2);
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `fnc_SESSION_LENGTH` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `fnc_SESSION_LENGTH`() RETURNS int(11)
BEGIN
	RETURN fnc_HoursToSeconds(4);
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `AddConnectionEvent` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `AddConnectionEvent`(
		ServerID INT,
        SessionID INT,
        Type VARCHAR(20),
        Name VARCHAR(128),
        UCID VARCHAR(128),
        ID INT,
        IP VARCHAR(25),
        GameTime BIGINT(32),
        RealTime BIGINT(32)
    )
BEGIN

	IF Type = "CONNECTED" THEN
		INSERT INTO online_players (server_id, ucid, name, role, side, ping)
		VALUES (ServerID, UCID, Name, "", 0, 0);
    ELSE
		DELETE FROM online_players WHERE online_players.server_id = ServerID AND online_players.ucid = UCID;
    END IF;
	INSERT INTO raw_Connection_log (server_id, session_id, type, player_ucid, player_name, player_id, ip_address, game_time, real_time)
    VALUES (ServerID, SessionID, Type, UCID, Name, ID, IP, GameTime, RealTime);
    SELECT LAST_INSERT_ID();
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `AddGameEvent` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `AddGameEvent`(
		IN ServerID INT, 
		IN SessionID BIGINT(32), 
        IN SortieID BIGINT(32), 
        IN UCID VARCHAR(128), 
        IN Event VARCHAR(45),
        IN PlayerName VARCHAR(128),
        IN PlayerSide INT,
        IN RealTime BIGINT(32),
        IN GameTime BIGINT(32),
        IN Role VARCHAR(25),
        IN Location VARCHAR(60),
        IN Weapon VARCHAR(60),
        IN WeaponCategory VARCHAR(20),
        IN TargetName VARCHAR(60),
        IN TargetModel VARCHAR(60),
        IN TargetType VARCHAR(25),
        IN TargetCategory VARCHAR(15),
        IN TargetSide INT,
        IN TargetIsPlayer BIT(1),
        IN TargetPlayerUCID VARCHAR(128),
        IN TargetPlayerName VARCHAR(128),
        IN TransportUnloadedCount INT,
        IN Cargo VARCHAR(128)
	)
BEGIN
	INSERT INTO raw_gameevents_log (server_id, session_id, sortie_id, ucid, event, player_name, player_side, real_time, game_time, 
									role, location, weapon, weapon_category, target_name, target_model, target_type,
									target_category, target_side, target_is_player, target_player_ucid, target_player_name,
                                    transport_unloaded_count, cargo)
    VALUES(ServerID, SessionID, SortieID, UCID, Event, PlayerName, PlayerSide, RealTime, GameTime, 
		   Role, Location, Weapon, WeaponCategory, TargetName, TargetModel, TargetType, 
           TargetCategory, TargetSide, TargetIsPlayer, TargetPlayerUCID, TargetPlayerName,
           TransportUnloadedCount, Cargo);
           
	SELECT LAST_INSERT_ID();
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `AddOrUpdateCapturePoint` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `AddOrUpdateCapturePoint`(
		IN ServerID INT, 
		IN Name VARCHAR(128), 
        IN Type VARCHAR(12),
        IN Status VARCHAR(15), 
        IN BlueUnits INT, 
        IN RedUnits INT,
        IN MaxCapacity INT,
        IN LatLong VARCHAR(30),
        IN MGRS VARCHAR(20),
        IN Text VARCHAR(900),
        IN X DOUBLE,
        IN Y DOUBLE
	)
BEGIN
	IF ((SELECT EXISTS (SELECT 1 FROM capture_point WHERE capture_point.name = Name AND capture_point.server_id = ServerID)) = 1) THEN
		UPDATE capture_point
        SET capture_point.name = Name,
			capture_point.type = Type,
			capture_point.status = Status,
            capture_point.blue_units = BlueUnits,
            capture_point.red_units = RedUnits,
            capture_point.latlong = LatLong,
            capture_point.mgrs = MGRS,
            capture_point.max_capacity = MaxCapacity,
            capture_point.text = Text,
            capture_point.x = X,
            capture_point.y = Y,
            capture_point.image = fnc_GetCapturePointImage(BlueUnits, RedUnits, Type)
		WHERE capture_point.name = Name AND capture_point.server_id = ServerID;
	ELSE
		INSERT INTO capture_point 
        (capture_point.server_id, capture_point.name, capture_point.latlong, capture_point.mgrs, 
         capture_point.status, capture_point.blue_units, capture_point.red_units, capture_point.max_capacity,
         capture_point.text, capture_point.x, capture_point.y, capture_point.image, capture_point.type)
        VALUES (ServerID, Name, LatLong, MGRS, 
				Status, BlueUnits, RedUnits, MaxCapacity,
				Text, X, Y, fnc_GetCapturePointImage(BlueUnits, RedUnits, Type), Type);
    END IF;
    SELECT 1;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `AddOrUpdateDepot` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `AddOrUpdateDepot`(
		IN ServerID INT, 
		IN Name VARCHAR(128), 
        IN Status VARCHAR(45),
        IN ResourceString VARCHAR(900),
        IN CurrentCapacity INT,
        IN Capacity INT,
        IN LatLong VARCHAR(30),
        IN MGRS VARCHAR(20),
        IN X DOUBLE,
        IN Y DOUBLE
        
	)
BEGIN
	IF ((SELECT EXISTS (SELECT 1 FROM depot WHERE depot.name = Name AND depot.server_id = ServerID)) = 1) THEN
		UPDATE depot
        SET depot.name = Name,
			depot.latlong = LatLong,
            depot.mgrs = MGRS,
            depot.current_capacity = CurrentCapacity,
            depot.capacity = Capacity,
            depot.resources = ResourceString,
			depot.status = Status,
            depot.x = X,
            depot.y = Y,
            depot.image = fnc_GetDepotImage(Status)
		WHERE depot.name = Name AND depot.server_id = ServerID;
	ELSE
		INSERT INTO depot 
        (depot.server_id, depot.name, depot.latlong, depot.mgrs, 
         depot.current_capacity, depot.capacity, depot.resources, depot.status,
         depot.x, depot.y, depot.image)
        VALUES (ServerID, Name, LatLong, MGRS, 
                CurrentCapacity, Capacity, ResourceString, Status,
                X, Y, fnc_GetDepotImage(Status));
    END IF;
    SELECT 1;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `AddOrUpdateSideMission` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `AddOrUpdateSideMission`(
		IN IsAdd BOOL,
		IN ServerID INT, 
        IN ServerMissionID INT,
        IN Status VARCHAR(20),
        IN TimeRemaining INT,
		IN TaskName VARCHAR(128), 
        IN TaskDesc VARCHAR(900),
        IN Image VARCHAR(90),
        IN LatLong VARCHAR(30),
        IN MGRS VARCHAR(20),
        IN X DOUBLE,
        IN Y DOUBLE
	)
BEGIN
	IF (NOT IsAdd) THEN
		UPDATE side_mission
        SET side_mission.status = Status,
            side_mission.time_remaining = TimeRemaining,
			side_mission.image = fnc_GetSideMissionImage(Image, Status),
            side_mission.time_inactive = CASE WHEN (Status != "Active") THEN NOW() ELSE NULL END
		WHERE side_mission.server_mission_id = ServerMissionID AND side_mission.server_id = ServerID;
	ELSE
		INSERT INTO side_mission 
        (side_mission.server_id, side_mission.server_mission_id, side_mission.task_name, side_mission.task_desc,
         side_mission.image, side_mission.status, side_mission.time_remaining, side_mission.time_inactive,
         side_mission.latlong, side_mission.mgrs, side_mission.x, side_mission.y)
        VALUES (ServerID, ServerMissionID, TaskName, TaskDesc,
				fnc_GetSideMissionImage(Image, Status), Status, TimeRemaining, NULL,
				LatLong, MGRS, X, Y);
    END IF;
    SELECT 1;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `BanPlayer` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `BanPlayer`(
	UCID VARCHAR(128)
)
BEGIN
	UPDATE ki.player SET banned = 1 WHERE player.ucid = UCID;
    SELECT UCID;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `CreateSession` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `CreateSession`(
		ServerID INT,
        RealTimeStart BIGINT,
        RefreshMissionData BOOL
    )
BEGIN
	IF RefreshMissionData THEN
		DELETE FROM capture_point WHERE server_id = ServerID;
        DELETE FROM depot WHERE server_id = ServerID;
	END IF;
	DELETE FROM online_players WHERE server_id = ServerID;
    UPDATE ki.server SET status = "Online" WHERE server_id = ServerID;
	INSERT INTO session (server_id, start, real_time_start)
    VALUES (ServerID, NOW(), RealTimeStart);
    SELECT LAST_INSERT_ID() AS SessionID;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `EndSession` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `EndSession`(
		ServerID INT,
        SessionID INT,
        RealTimeEnd BIGINT,
        ServerStatus VARCHAR(10)
    )
BEGIN
	DELETE FROM online_players WHERE server_id = ServerID;
    UPDATE session SET end = NOW(), real_time_end = RealTimeEnd WHERE server_id = ServerID AND session_id = SessionID;
    UPDATE ki.server SET status = ServerStatus WHERE server_id = ServerID;
    SELECT 1;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `GetOrAddPlayer` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `GetOrAddPlayer`(
	UCID VARCHAR(128),
    Name VARCHAR(128)
)
BEGIN
	IF ((SELECT EXISTS (SELECT 1 FROM player WHERE player.ucid = UCID)) = 1) THEN
		SELECT player.ucid, player.name, lives, banned
        FROM player WHERE player.ucid = UCID;
	ELSE
		INSERT INTO player (player.ucid, player.name, lives, banned)
        VALUES (UCID, Name, 5, 0);
        SELECT player.ucid, player.name, lives, banned
        FROM player WHERE player.ucid = UCID;
    END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `GetOrAddServer` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `GetOrAddServer`(
		IN ServerName VARCHAR(128),
        IN IP VARCHAR(30)
    )
BEGIN
	IF ((SELECT EXISTS (SELECT 1 FROM server WHERE server.ip_address = IP)) = 1) THEN
		SELECT server_id FROM server WHERE ip_address = IP;
    ELSE
		-- New Entry, Insert the new server into the database
        INSERT INTO server (name, ip_address) VALUES (ServerName, IP);
        SELECT LAST_INSERT_ID();
    END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `IsPlayerBanned` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `IsPlayerBanned`(
	UCID VARCHAR(128)
)
BEGIN
    SELECT banned, player.ucid AS UCID FROM ki.player WHERE player.ucid = UCID;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `log` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `log`(sproc VARCHAR(128), text VARCHAR(5000))
BEGIN
	INSERT INTO ki.sproc_log (sproc_log.sproc, sproc_log.text)
    VALUES (sproc, text);
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `rpt_PlayerOnlineTime` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `rpt_PlayerOnlineTime`(IN ucid VARCHAR(128), INOUT totaltime INT)
BEGIN
	DECLARE v_finished INTEGER DEFAULT 0;
	
    DECLARE v_event varchar(20) DEFAULT "";
    DECLARE v_time BIGINT DEFAULT 0;
    DECLARE v_server_id INT DEFAULT 0;
    DECLARE v_session_id INT DEFAULT 0;
    
    DECLARE v_start BIGINT DEFAULT 0;
    DECLARE v_end BIGINT;
    
    
	DEClARE con_cursor CURSOR FOR 
	SELECT type, real_time, server_id, session_id FROM ki.raw_connection_log WHERE player_ucid = ucid;

	-- declare NOT FOUND handler
	DECLARE CONTINUE HANDLER 
		FOR NOT FOUND SET v_finished = 1;

	CALL ki.log("rpt_PlayerOnlineTime", CONCAT("totaltime: ", totaltime));
    
	OPEN con_cursor;

	online_time: LOOP
		CALL ki.log("rpt_PlayerOnlineTime", "In Loop");
        
		FETCH con_cursor INTO v_event, v_time, v_server_id, v_session_id;

		IF v_finished = 1 THEN 
			CALL ki.log("rpt_PlayerOnlineTime", "Finished Loop");
			LEAVE online_time;
		END IF;
        
        IF v_event = "CONNECTED" THEN
			
            
			IF v_start != 0 then
				CALL ki.log("rpt_PlayerOnlineTime", "CONNECTED EVENT TWICE IN A ROW");
                CALL ki.log("rpt_PlayerOnlineTime", CONCAT("v_server_id", v_server_id));
                CALL ki.log("rpt_PlayerOnlineTime", CONCAT("v_session_id", v_session_id));
				-- If the next event is not a disconnect event, assume that the player or server crashed, and get the time from the session
				SELECT session.real_time_end INTO v_end FROM ki.session WHERE server_id = v_server_id AND session_id = v_session_id;
                IF v_end != NULL THEN
					CALL ki.log("rpt_PlayerOnlineTime", "SETTING v_end TO SESSION END TIME");
					SET totaltime = totaltime + (v_end - v_start);
				ELSE
					SELECT session.real_time_start INTO v_end FROM ki.session WHERE session.server_id = v_server_id AND session.session_id = v_session_id;
					CALL ki.log("rpt_PlayerOnlineTime", "SETTING v_end To the SESSION START + 4 Hours");
                    CALL ki.log("rpt_PlayerOnlineTime", CONCAT("fnc_SESSION_LENGTH : ", fnc_SESSION_LENGTH()));
                    CALL ki.log("rpt_PlayerOnlineTime", CONCAT("totaltime : ", totaltime));
                    CALL ki.log("rpt_PlayerOnlineTime", CONCAT("v_start : ", v_start));
                    CALL ki.log("rpt_PlayerOnlineTime", CONCAT("v_end : ", v_end));
                    SET totaltime = totaltime + ((v_end + fnc_SESSION_LENGTH()) - v_start);
                END IF;
            END IF;
			SET v_start = v_time;
		ELSEIF v_event = "DISCONNECTED" THEN
			CALL ki.log("rpt_PlayerOnlineTime", "DISCONNECTED EVENT - CALCULATING END TIME");
            SET totaltime = totaltime + (v_time - v_start);
            SET v_start = 0;
		END IF;
		
        CALL ki.log("rpt_PlayerOnlineTime", CONCAT("IN LOOP: Total Time: ", totaltime));
	END LOOP online_time;

	CLOSE con_cursor;
	
    CALL ki.log("rpt_PlayerOnlineTime", CONCAT("Total Time: ", totaltime));
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `SendHeartbeat` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `SendHeartbeat`(
		IN ServerID INT,
        IN RestartTime INT
    )
BEGIN
	UPDATE ki.server 
		SET last_heartbeat = NOW(),
        status = "Online",
		restart_time = RestartTime
	WHERE server_id = ServerID;
	SELECT 1;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `UnbanPlayer` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `UnbanPlayer`(
	UCID VARCHAR(128)
)
BEGIN
	UPDATE ki.player SET banned = 0 WHERE player.ucid = UCID;
    SELECT UCID;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `UpdatePlayer` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `UpdatePlayer`(
	ServerID INT,
	UCID VARCHAR(128),
    Name VARCHAR(128),
    Role VARCHAR(45),
    Lives INT,
    Side INT,
    Ping INT
)
BEGIN
	UPDATE player
    SET player.lives = Lives, player.name = Name
    WHERE player.ucid = UCID;
    
    UPDATE online_players
    SET online_players.role = Role, online_players.side = Side, online_players.ping = Ping
    WHERE online_players.server_id = ServerID AND online_players.ucid = UCID;
    
    SELECT UCID;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `websp_GetCapturePoints` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `websp_GetCapturePoints`(ServerID INT)
BEGIN
	SELECT  c.capture_point_id as CapturePointID,
			c.type As Type,
			c.name as Name,
            c.latlong as LatLong,
            c.mgrs as MGRS,
            c.text as Text,
            c.status as Status,
            c.blue_units as BlueUnits,
            c.red_units as RedUnits,
            c.max_capacity as MaxCapacity,
            c.x as X,
            c.y as Y,
			c.image as ImagePath
	FROM capture_point c
    WHERE c.server_id = ServerID;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `websp_GetDepots` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `websp_GetDepots`(ServerID INT)
BEGIN
	SELECT  d.depot_id as DepotID,
			d.name as Name,
            d.latlong as LatLong,
            d.mgrs as MGRS,
            d.current_capacity as CurrentCapacity,
            d.capacity as Capacity,
            d.status as Status,
            d.resources as Resources,
            d.x as X,
            d.y as Y,
			d.image as ImagePath
	FROM depot d
    WHERE d.server_id = ServerID;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `websp_GetGame` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `websp_GetGame`(ServerID INT)
BEGIN
	SELECT s.server_id as ServerID, 
		   s.name as ServerName, 
           s.ip_address as IPAddress,  
           COUNT(op.ucid) as OnlinePlayerCount,
           s.restart_time as RestartTime,
           s.status
	FROM server s
    LEFT JOIN online_players op
		ON s.server_id = op.server_id
    WHERE s.server_id = ServerID
    GROUP BY s.server_id, s.name;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `websp_GetGameMap` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `websp_GetGameMap`(ServerID INT)
BEGIN
	SELECT  m.game_map_id as GameMapID,
			m.base_image as ImagePath,
			m.resolution_x as Width,
            m.resolution_y as Height,
            m.dcs_origin_x as X,
            m.dcs_origin_y as Y,
            m.ratio as Ratio
	FROM game_map m
    WHERE m.server_id = ServerID;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `websp_GetGameMapLayers` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `websp_GetGameMapLayers`(GameMapID INT)
BEGIN
	SELECT  m.image as ImagePath,
			m.resolution_x as Width,
            m.resolution_y as Height
	FROM map_layer m
    WHERE m.game_map_id = GameMapID
    ORDER BY m.resolution_x ASC;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `websp_GetOnlinePlayers` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `websp_GetOnlinePlayers`(ServerID INT)
BEGIN
	SELECT  op.ucid as UCID,
			op.name as Name,
            op.role as Role,
            COALESCE(ri.image, "Images/role/role-none-30x30.png") as RoleImage,
            op.side as Side,
            op.ping as Ping,
            p.lives as Lives
	FROM online_players op
    INNER JOIN player p 
		ON op.ucid = p.ucid
    LEFT JOIN role_image ri
		ON op.role = ri.role
	WHERE op.server_id = ServerID
	GROUP BY op.ucid , op.name;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `websp_GetServersList` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `websp_GetServersList`()
BEGIN
	SELECT s.server_id as ServerID, 
		   s.name as ServerName, 
           s.ip_address as IPAddress,  
           COUNT(op.ucid) as OnlinePlayers,
           s.restart_time as RestartTime,
           s.status
	FROM server s
    LEFT JOIN online_players op
		ON s.server_id = op.server_id
	GROUP BY s.server_id, s.name;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `websp_GetSideMissions` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `websp_GetSideMissions`(ServerID INT)
BEGIN
	SELECT  m.server_mission_id as ServerMissionID,
			m.task_name as Name,
            m.task_desc as Description,
            m.image as ImagePath,
            m.status as Status,
            m.time_remaining as TimeRemaining,
            m.time_inactive as TimeInactive,
            m.latlong as LatLong,
            m.mgrs as MGRS,
            m.x as X,
            m.y as Y
	FROM side_mission m
    WHERE m.server_id = ServerID;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2017-12-26 22:30:19
