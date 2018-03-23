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
-- Table structure for table `backup_connection_log`
--

DROP TABLE IF EXISTS `backup_connection_log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `backup_connection_log` (
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
) ENGINE=InnoDB AUTO_INCREMENT=584 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `backup_gameevents_log`
--

DROP TABLE IF EXISTS `backup_gameevents_log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `backup_gameevents_log` (
  `id` bigint(32) NOT NULL AUTO_INCREMENT,
  `server_id` int(11) NOT NULL,
  `session_id` bigint(32) NOT NULL,
  `sortie_id` bigint(32) DEFAULT NULL,
  `ucid` varchar(128) DEFAULT NULL,
  `event` varchar(45) NOT NULL,
  `player_name` varchar(128) NOT NULL,
  `player_side` int(11) DEFAULT NULL,
  `model_time` bigint(32) NOT NULL,
  `game_time` bigint(32) NOT NULL,
  `role` varchar(45) DEFAULT NULL,
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
) ENGINE=InnoDB AUTO_INCREMENT=2023 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

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
  `status_changed` bit(1) NOT NULL DEFAULT b'0',
  PRIMARY KEY (`capture_point_id`),
  KEY `FK_CP_ServerID_idx` (`server_id`),
  CONSTRAINT `FK_CP_ServerID` FOREIGN KEY (`server_id`) REFERENCES `server` (`server_id`) ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=308 DEFAULT CHARSET=utf8;
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
  `status_changed` bit(1) NOT NULL DEFAULT b'0',
  PRIMARY KEY (`depot_id`),
  KEY `FK_ServerID_idx` (`server_id`),
  CONSTRAINT `FK_ServerID` FOREIGN KEY (`server_id`) REFERENCES `server` (`server_id`) ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=168 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `game_map`
--

DROP TABLE IF EXISTS `game_map`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `game_map` (
  `game_map_id` int(11) NOT NULL AUTO_INCREMENT,
  `base_image` varchar(132) NOT NULL,
  `resolution_x` double NOT NULL,
  `resolution_y` double NOT NULL,
  `dcs_origin_x` double NOT NULL,
  `dcs_origin_y` double NOT NULL,
  `ratio` double NOT NULL,
  PRIMARY KEY (`game_map_id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;
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
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8;
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
) ENGINE=InnoDB AUTO_INCREMENT=63 DEFAULT CHARSET=utf8;
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
  `model_time` bigint(32) NOT NULL,
  `game_time` bigint(32) NOT NULL,
  `role` varchar(45) DEFAULT NULL,
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
) ENGINE=InnoDB AUTO_INCREMENT=17 DEFAULT CHARSET=utf8;
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
) ENGINE=InnoDB AUTO_INCREMENT=24 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `rpt_airframe_kd`
--

DROP TABLE IF EXISTS `rpt_airframe_kd`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `rpt_airframe_kd` (
  `ucid` varchar(128) NOT NULL,
  `airframe` varchar(45) NOT NULL,
  `name` varchar(60) NOT NULL,
  `kills` int(11) NOT NULL DEFAULT '0',
  `deaths` int(11) NOT NULL DEFAULT '0',
  `is_model` bit(1) NOT NULL DEFAULT b'0',
  `is_type` bit(1) NOT NULL DEFAULT b'0',
  `is_category` bit(1) NOT NULL DEFAULT b'0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `rpt_airframe_sortie`
--

DROP TABLE IF EXISTS `rpt_airframe_sortie`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `rpt_airframe_sortie` (
  `sortie_id` int(11) NOT NULL AUTO_INCREMENT,
  `ucid` varchar(128) NOT NULL,
  `airframe` varchar(45) NOT NULL,
  `sortie_time` bigint(64) NOT NULL,
  `shots` int(11) NOT NULL,
  `gunshots` int(11) NOT NULL,
  `hits` int(11) NOT NULL,
  `kills` int(11) NOT NULL,
  `transport_mount` int(11) NOT NULL,
  `transport_dismount` int(11) NOT NULL,
  `cargo_unpacked` int(11) NOT NULL,
  `depot_resupply` int(11) NOT NULL,
  `cargo_hooked` int(11) NOT NULL,
  `cargo_unhooked` int(11) NOT NULL,
  PRIMARY KEY (`sortie_id`)
) ENGINE=InnoDB AUTO_INCREMENT=155 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `rpt_airframe_stats`
--

DROP TABLE IF EXISTS `rpt_airframe_stats`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `rpt_airframe_stats` (
  `ucid` varchar(128) NOT NULL,
  `airframe` varchar(45) NOT NULL,
  `flight_time` bigint(64) NOT NULL DEFAULT '0',
  `avg_flight_time` bigint(64) NOT NULL DEFAULT '0',
  `takeoffs` int(11) NOT NULL DEFAULT '0',
  `landings` int(11) NOT NULL DEFAULT '0',
  `slingload_hooks` int(11) NOT NULL DEFAULT '0',
  `slingload_unhooks` int(11) NOT NULL DEFAULT '0',
  `kills` int(11) NOT NULL DEFAULT '0',
  `kills_player` int(11) NOT NULL DEFAULT '0',
  `kills_friendly` int(11) NOT NULL DEFAULT '0',
  `deaths` int(11) NOT NULL DEFAULT '0',
  `transport_mounts` int(11) NOT NULL DEFAULT '0',
  `transport_dismounts` int(11) NOT NULL DEFAULT '0',
  `depot_resupplies` int(11) NOT NULL DEFAULT '0',
  `cargo_unpacked` int(11) NOT NULL DEFAULT '0',
  `ejects` int(11) NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `rpt_airframe_weapon`
--

DROP TABLE IF EXISTS `rpt_airframe_weapon`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `rpt_airframe_weapon` (
  `ucid` varchar(128) NOT NULL,
  `airframe` varchar(45) NOT NULL,
  `weapon` varchar(60) NOT NULL,
  `shots` int(11) NOT NULL DEFAULT '0',
  `hits` int(11) NOT NULL DEFAULT '0',
  `kills` int(11) NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `rpt_overall_server_traffic`
--

DROP TABLE IF EXISTS `rpt_overall_server_traffic`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `rpt_overall_server_traffic` (
  `server_id` int(11) NOT NULL,
  `ucid` varchar(128) NOT NULL,
  `num_connects` int(11) NOT NULL DEFAULT '0',
  `avg_online_time` bigint(64) NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `rpt_overall_stats`
--

DROP TABLE IF EXISTS `rpt_overall_stats`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `rpt_overall_stats` (
  `ucid` varchar(128) NOT NULL,
  `game_time` bigint(64) NOT NULL DEFAULT '0' COMMENT 'total in game time in seconds',
  `takeoffs` int(11) NOT NULL DEFAULT '0',
  `landings` int(11) NOT NULL DEFAULT '0',
  `slingload_hooks` int(11) NOT NULL DEFAULT '0',
  `slingload_unhooks` int(11) NOT NULL DEFAULT '0',
  `kills` int(11) NOT NULL DEFAULT '0',
  `deaths` int(11) NOT NULL DEFAULT '0',
  `ejects` int(11) NOT NULL DEFAULT '0',
  `transport_mounts` int(11) NOT NULL DEFAULT '0',
  `transport_dismounts` int(11) NOT NULL DEFAULT '0',
  `depot_resupplies` int(11) NOT NULL DEFAULT '0',
  `cargo_unpacked` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`ucid`),
  UNIQUE KEY `ucid_UNIQUE` (`ucid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `rpt_player_session_series`
--

DROP TABLE IF EXISTS `rpt_player_session_series`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `rpt_player_session_series` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `ucid` varchar(128) NOT NULL,
  `session_id` bigint(32) NOT NULL,
  `event` varchar(45) NOT NULL,
  `game_time` bigint(32) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_session_idx` (`session_id`),
  CONSTRAINT `fk_session` FOREIGN KEY (`session_id`) REFERENCES `session` (`session_id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=1303 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `rpt_updated`
--

DROP TABLE IF EXISTS `rpt_updated`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `rpt_updated` (
  `last_updated` datetime(1) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
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
  `game_time_start` bigint(32) DEFAULT NULL,
  `game_time_end` bigint(32) DEFAULT NULL,
  `last_heartbeat` datetime DEFAULT NULL,
  PRIMARY KEY (`session_id`),
  KEY `server_id_idx` (`server_id`),
  CONSTRAINT `Session_ServerID` FOREIGN KEY (`server_id`) REFERENCES `server` (`server_id`) ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=663 DEFAULT CHARSET=utf8;
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
  `status_changed` bit(1) NOT NULL DEFAULT b'0',
  PRIMARY KEY (`side_mission_id`),
  KEY `fk_server_id_idx` (`server_id`),
  CONSTRAINT `fk_server_id` FOREIGN KEY (`server_id`) REFERENCES `server` (`server_id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=387 DEFAULT CHARSET=utf8;
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
-- Table structure for table `target`
--

DROP TABLE IF EXISTS `target`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `target` (
  `target_id` int(11) NOT NULL AUTO_INCREMENT,
  `model` varchar(60) NOT NULL,
  `type` varchar(25) DEFAULT NULL COMMENT 'NOTE - type is nullable as not all DCS objects have a type ''ie buildings do not have a type to them, they are simply counted as STRUCTURES)',
  `category` varchar(15) NOT NULL,
  PRIMARY KEY (`target_id`)
) ENGINE=InnoDB AUTO_INCREMENT=89 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `weapon`
--

DROP TABLE IF EXISTS `weapon`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `weapon` (
  `weapon_id` int(11) NOT NULL,
  `name` varchar(60) NOT NULL,
  `category` varchar(20) NOT NULL,
  PRIMARY KEY (`weapon_id`),
  UNIQUE KEY `unique_weapon` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `xref_game_map_server`
--

DROP TABLE IF EXISTS `xref_game_map_server`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `xref_game_map_server` (
  `xref_game_map_server_id` int(11) NOT NULL AUTO_INCREMENT,
  `game_map_id` int(11) NOT NULL,
  `server_id` int(11) NOT NULL,
  PRIMARY KEY (`xref_game_map_server_id`),
  UNIQUE KEY `server_id_UNIQUE` (`server_id`),
  KEY `fk_game_map_idx` (`game_map_id`),
  CONSTRAINT `fk_game_map` FOREIGN KEY (`game_map_id`) REFERENCES `game_map` (`game_map_id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_server` FOREIGN KEY (`server_id`) REFERENCES `server` (`server_id`) ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2018-02-27 22:10:16
