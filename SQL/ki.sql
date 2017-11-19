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
  `name` varchar(128) NOT NULL,
  `status` varchar(15) NOT NULL,
  `blue_units` int(11) NOT NULL,
  `red_units` int(11) NOT NULL,
  `mgrs` varchar(20) NOT NULL,
  `latlong` varchar(30) NOT NULL,
  PRIMARY KEY (`capture_point_id`),
  KEY `FK_CP_ServerID_idx` (`server_id`),
  CONSTRAINT `FK_CP_ServerID` FOREIGN KEY (`server_id`) REFERENCES `server` (`server_id`) ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8;
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
  PRIMARY KEY (`depot_id`),
  KEY `FK_ServerID_idx` (`server_id`),
  CONSTRAINT `FK_ServerID` FOREIGN KEY (`server_id`) REFERENCES `server` (`server_id`) ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `objectives`
--

DROP TABLE IF EXISTS `objectives`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `objectives` (
  `objective_id` int(11) NOT NULL AUTO_INCREMENT,
  `type` varchar(10) NOT NULL,
  `status` varchar(20) NOT NULL,
  PRIMARY KEY (`objective_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
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
) ENGINE=InnoDB AUTO_INCREMENT=78 DEFAULT CHARSET=utf8;
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
  `airfield` varchar(60) DEFAULT NULL,
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
) ENGINE=InnoDB AUTO_INCREMENT=712 DEFAULT CHARSET=utf8;
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
  PRIMARY KEY (`server_id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8;
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
  PRIMARY KEY (`session_id`),
  KEY `server_id_idx` (`server_id`),
  CONSTRAINT `Session_ServerID` FOREIGN KEY (`server_id`) REFERENCES `server` (`server_id`) ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=369 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping events for database 'ki'
--

--
-- Dumping routines for database 'ki'
--
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
        IN Airfield VARCHAR(60),
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
									role, airfield, weapon, weapon_category, target_name, target_model, target_type,
									target_category, target_side, target_is_player, target_player_ucid, target_player_name,
                                    transport_unloaded_count, cargo)
    VALUES(ServerID, SessionID, SortieID, UCID, Event, PlayerName, PlayerSide, RealTime, GameTime, 
		   Role, Airfield, Weapon, WeaponCategory, TargetName, TargetModel, TargetType, 
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
        IN Status VARCHAR(15), 
        IN BlueUnits INT, 
        IN RedUnits INT,
        IN LatLong VARCHAR(30),
        IN MGRS VARCHAR(20)
	)
BEGIN
	IF ((SELECT EXISTS (SELECT 1 FROM capture_point WHERE capture_point.name = Name)) = 1) THEN
		UPDATE capture_point
        SET capture_point.name = Name,
			capture_point.status = Status,
            capture_point.latlong = LatLong,
            capture_point.mgrs = MGRS,
            capture_point.blue_units = BlueUnits,
            capture_point.red_units = RedUnits
		WHERE capture_point.name = Name AND capture_point.server_id = ServerID;
	ELSE
		INSERT INTO capture_point 
        (capture_point.server_id, capture_point.name, capture_point.latlong, capture_point.mgrs, capture_point.status, capture_point.blue_units, capture_point.red_units)
        VALUES (ServerID, Name, LatLong, MGRS, Status, BlueUnits, RedUnits);
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
        IN LatLong VARCHAR(30),
        IN MGRS VARCHAR(20),
        IN CurrentCapacity INT,
        IN Capacity INT,
        IN ResourceString VARCHAR(900),
        IN Status VARCHAR(45)
	)
BEGIN
	IF ((SELECT EXISTS (SELECT 1 FROM depot WHERE depot.name = Name)) = 1) THEN
		UPDATE depot
        SET depot.name = Name,
			depot.latlong = LatLong,
            depot.mgrs = MGRS,
            depot.current_capacity = CurrentCapacity,
            depot.capacity = Capacity,
            depot.resources = ResourceString,
			depot.status = Status
		WHERE depot.name = Name AND depot.server_id = ServerID;
	ELSE
		INSERT INTO depot 
        (depot.server_id, depot.name, depot.latlong, depot.mgrs, depot.current_capacity, depot.capacity, depot.resources, depot.status)
        VALUES (ServerID, Name, LatLong, MGRS, CurrentCapacity, Capacity, ResourceString, Status);
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
		ServerID INT
    )
BEGIN
	DELETE FROM online_players WHERE server_id = ServerID;
	INSERT INTO session (server_id, start)
    VALUES (ServerID, NOW());
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
        SessionID INT
    )
BEGIN
	DELETE FROM online_players WHERE server_id = ServerID;
    UPDATE session SET end = NOW() WHERE server_id = ServerID AND session_id = SessionID;
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
    Side INT
)
BEGIN
	UPDATE player
    SET player.lives = Lives, player.name = Name
    WHERE player.ucid = UCID;
    
    UPDATE online_players
    SET online_players.role = Role, online_players.side = Side
    WHERE online_players.server_id = ServerID AND online_players.ucid = UCID;
    
    SELECT UCID;
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

-- Dump completed on 2017-11-19 16:32:40
