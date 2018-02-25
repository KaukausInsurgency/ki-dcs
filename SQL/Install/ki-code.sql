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
/*!50106 CREATE*/ /*!50117 DEFINER=`root`@`localhost`*/ /*!50106 EVENT `e_DeleteInactiveMissions` ON SCHEDULE EVERY 5 MINUTE STARTS '2017-12-26 21:40:45' ON COMPLETION NOT PRESERVE ENABLE COMMENT 'Deletes inactive missions' DO DELETE FROM side_mission
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
/*!50106 CREATE*/ /*!50117 DEFINER=`root`@`localhost`*/ /*!50106 EVENT `e_PlayerGainLife` ON SCHEDULE EVERY 1 HOUR STARTS '2017-12-15 14:19:05' ON COMPLETION NOT PRESERVE ENABLE COMMENT 'Restores 1 life to each player every hour' DO UPDATE player
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
/*!50106 CREATE*/ /*!50117 DEFINER=`root`@`localhost`*/ /*!50106 EVENT `e_ServerStatusCheck` ON SCHEDULE EVERY 5 MINUTE STARTS '2017-12-15 15:49:29' ON COMPLETION NOT PRESERVE ENABLE COMMENT 'Checks the status of servers' DO UPDATE server
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
	IF (Status = "Red") THEN
		RETURN "Images/markers/depot-red-256x256.png";
	ELSEIF (Status = "Blue") THEN
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
	FROM server WHERE server_id = ServerID;
    
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
	FROM side_mission WHERE side_mission_id = SideMissionID;
    
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
/*!50003 DROP FUNCTION IF EXISTS `fnc_GetSessionLastHeartbeatInSeconds` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `fnc_GetSessionLastHeartbeatInSeconds`( ServerID INT, SessionID INT) RETURNS int(11)
BEGIN
	SET @LastHeartbeat = 0;
	SELECT TIME_TO_SEC( TIMEDIFF( NOW(), COALESCE(last_heartbeat, FROM_UNIXTIME(0)) )) INTO @LastHeartbeat
	FROM session WHERE server_id = ServerID AND session_id = SessionID;
    
    RETURN @LastHeartbeat;
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
        IN ModelTime BIGINT(32),
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
	INSERT INTO raw_gameevents_log (server_id, session_id, sortie_id, ucid, event, player_name, player_side, model_time, game_time, 
									role, location, weapon, weapon_category, target_name, target_model, target_type,
									target_category, target_side, target_is_player, target_player_ucid, target_player_name,
                                    transport_unloaded_count, cargo)
    VALUES(ServerID, SessionID, SortieID, UCID, Event, PlayerName, PlayerSide, ModelTime, GameTime, 
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
	UPDATE player SET banned = 1 WHERE player.ucid = UCID;
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
        GameTimeStart BIGINT,
        RefreshMissionData BOOL
    )
BEGIN
	IF RefreshMissionData THEN
		DELETE FROM capture_point WHERE server_id = ServerID;
        DELETE FROM depot WHERE server_id = ServerID;
	END IF;
	DELETE FROM online_players WHERE server_id = ServerID;
    UPDATE server SET status = "Online" WHERE server_id = ServerID;
	INSERT INTO session (server_id, start, real_time_start, game_time_start)
    VALUES (ServerID, NOW(), RealTimeStart, GameTimeStart);
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
        GameTimeEnd BIGINT,
        ServerStatus VARCHAR(10)
    )
BEGIN
	DELETE FROM online_players WHERE server_id = ServerID;
    UPDATE session 
		SET end = NOW(), 
			real_time_end = RealTimeEnd,
            game_time_end = GameTimeEnd
		WHERE server_id = ServerID AND session_id = SessionID;
    UPDATE server SET status = ServerStatus WHERE server_id = ServerID;
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
		INSERT INTO rpt_overall_stats (ucid)
        VALUES(UCID);
        
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
		UPDATE server SET name = ServerName WHERE ip_address = IP;
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
    SELECT banned, player.ucid AS UCID FROM player WHERE player.ucid = UCID;
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
	INSERT INTO sproc_log (sproc_log.sproc, sproc_log.text)
    VALUES (sproc, text);
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `rptsp_GetLast5SessionsBarGraph` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `rptsp_GetLast5SessionsBarGraph`(IN UCID VARCHAR(128))
BEGIN   
	SELECT 
	s.session_id AS SessionID,
	s.event AS Event,
	COUNT(s.event) AS EventCount
	FROM rpt_player_session_series s
	RIGHT JOIN
		( 	
			SELECT DISTINCT session_id
			FROM rpt_player_session_series sss
			WHERE sss.ucid = UCID
			ORDER BY session_id DESC
			LIMIT 5
		 ) ss
		ON s.session_id = ss.session_id
	WHERE (Event = "KILL" OR Event = "TAKEOFF" OR Event = "LAND") AND s.ucid = UCID
	GROUP BY SessionID, Event
    ORDER BY SessionID ASC;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `rptsp_GetLastSessionSeries` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `rptsp_GetLastSessionSeries`(IN UCID VARCHAR(128))
BEGIN   
    -- DECLARE SessionID INT;
    -- SET SessionID = 66;
	SELECT 
		s.event AS Event,
		s.game_time - ss.game_time_start AS Time
	FROM rpt_player_session_series s
    INNER JOIN session ss
		ON s.session_id = ss.session_id
	WHERE s.ucid = UCID AND s.session_id = 
		 ( 	
			SELECT MAX(session_id) 
			FROM rpt_player_session_series sss
            WHERE sss.ucid = UCID
		 );
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `rptsp_GetPlayerOverallStats` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `rptsp_GetPlayerOverallStats`(IN UCID VARCHAR(128))
BEGIN
	SELECT 
        p.name AS PlayerName,
        p.lives AS PlayerLives,
        p.banned AS PlayerBanned,
		game_time AS TotalGameTime,
        takeoffs AS TakeOffs,
        landings AS Landings,
        slingload_hooks AS SlingLoadHooks,
        slingload_unhooks AS SlingLoadUnhooks,
        kills AS Kills,
        deaths AS Deaths,
        ejects AS Ejects,
        transport_mounts AS TransportMounts,
        transport_dismounts AS TransportDismounts,
        depot_resupplies AS DepotResupplies,
        cargo_unpacked AS CargoUnpacked,
        landings / takeoffs AS SortieSuccessRatio,
        slingload_unhooks / slingload_hooks AS SlingLoadSuccessRatio,
        kills / CASE WHEN (deaths + ejects) = 0 THEN 1 ELSE (deaths + ejects) END AS KillDeathEjectRatio,
        transport_dismounts / transport_mounts AS TransportSuccessRatio
	FROM rpt_overall_stats r
    INNER JOIN player p
    ON r.ucid = p.ucid
    WHERE r.ucid = UCID;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `rptsp_GetTopAirframeSeries` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `rptsp_GetTopAirframeSeries`(IN UCID VARCHAR(128), IN RowLimit INT)
BEGIN
	SELECT 
		a.airframe AS Airframe,
        a.flight_time AS TotalTime
	FROM rpt_airframe_stats a
    WHERE a.ucid = UCID
    LIMIT RowLimit;
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
        IN SessionID INT,
        IN RestartTime INT
    )
BEGIN
	UPDATE server 
		SET last_heartbeat = NOW(),
        status = "Online",
		restart_time = RestartTime
	WHERE server_id = ServerID;
    UPDATE session
		SET last_heartbeat = NOW()
	WHERE server_id = ServerID and session_id = SessionID;
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
	UPDATE player SET banned = 0 WHERE player.ucid = UCID;
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
            c.status_changed as StatusChanged,
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
            d.status_changed as StatusChanged,
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
    INNER JOIN xref_game_map_server x
		ON m.game_map_id = x.game_map_id
    WHERE x.server_id = ServerID;
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
/*!50003 DROP PROCEDURE IF EXISTS `websp_GetServerInfo` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `websp_GetServerInfo`(ServerID INT)
BEGIN
	SELECT s.server_id as ServerID, 
           s.restart_time as RestartTime,
           s.status
	FROM server s
    WHERE s.server_id = ServerID;
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
            m.status_changed as StatusChanged,
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
/*!50003 DROP PROCEDURE IF EXISTS `websp_SearchPlayers` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `websp_SearchPlayers`(IN Criteria VARCHAR(128))
BEGIN
	SELECT player.ucid AS UCID,
		   player.name AS Name,
           player.banned AS Banned
    FROM player 
    WHERE LOWER(player.name) LIKE CONCAT("%", LOWER(Criteria), "%");
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `websp_SearchServers` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `websp_SearchServers`(IN Criteria VARCHAR(128))
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
	WHERE LOWER(s.name) LIKE CONCAT("%", LOWER(Criteria), "%")
	GROUP BY s.server_id, s.name;
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

-- Dump completed on 2018-02-25 11:17:58
