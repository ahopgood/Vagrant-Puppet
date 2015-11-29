-- MySQL dump 10.13  Distrib 5.6.19, for Linux (x86_64)
--
-- Host: localhost    Database: kanboard
-- ------------------------------------------------------
-- Server version	5.6.19

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
-- Table structure for table `action_has_params`
--

DROP TABLE IF EXISTS `action_has_params`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `action_has_params` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `action_id` int(11) NOT NULL,
  `name` varchar(50) NOT NULL,
  `value` varchar(50) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `action_id` (`action_id`),
  CONSTRAINT `action_has_params_ibfk_1` FOREIGN KEY (`action_id`) REFERENCES `actions` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `action_has_params`
--

LOCK TABLES `action_has_params` WRITE;
/*!40000 ALTER TABLE `action_has_params` DISABLE KEYS */;
/*!40000 ALTER TABLE `action_has_params` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `actions`
--

DROP TABLE IF EXISTS `actions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `actions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `project_id` int(11) NOT NULL,
  `event_name` varchar(50) NOT NULL,
  `action_name` varchar(50) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `project_id` (`project_id`),
  CONSTRAINT `actions_ibfk_1` FOREIGN KEY (`project_id`) REFERENCES `projects` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `actions`
--

LOCK TABLES `actions` WRITE;
/*!40000 ALTER TABLE `actions` DISABLE KEYS */;
/*!40000 ALTER TABLE `actions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `columns`
--

DROP TABLE IF EXISTS `columns`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `columns` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `title` varchar(255) NOT NULL,
  `position` int(11) NOT NULL,
  `project_id` int(11) NOT NULL,
  `task_limit` int(11) DEFAULT '0',
  `description` text,
  PRIMARY KEY (`id`),
  UNIQUE KEY `idx_title_project` (`title`,`project_id`),
  KEY `columns_project_idx` (`project_id`),
  CONSTRAINT `columns_ibfk_1` FOREIGN KEY (`project_id`) REFERENCES `projects` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `columns`
--

LOCK TABLES `columns` WRITE;
/*!40000 ALTER TABLE `columns` DISABLE KEYS */;
INSERT INTO `columns` VALUES (1,'Backlog',1,1,0,''),(2,'Ready',2,1,0,''),(3,'Development',3,1,0,''),(4,'Testing',4,1,0,''),(5,'Release',5,1,0,''),(6,'Done',6,1,0,''),(7,'Backlog',1,2,0,''),(8,'Ready',2,2,0,''),(9,'Work in progress',3,2,0,''),(10,'Done',4,2,0,'');
/*!40000 ALTER TABLE `columns` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `comments`
--

DROP TABLE IF EXISTS `comments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `comments` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `task_id` int(11) NOT NULL,
  `user_id` int(11) DEFAULT '0',
  `date_creation` bigint(20) DEFAULT NULL,
  `comment` text,
  `reference` varchar(50) DEFAULT '',
  PRIMARY KEY (`id`),
  KEY `user_id` (`user_id`),
  KEY `comments_reference_idx` (`reference`),
  KEY `comments_task_idx` (`task_id`),
  CONSTRAINT `comments_ibfk_1` FOREIGN KEY (`task_id`) REFERENCES `tasks` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `comments`
--

LOCK TABLES `comments` WRITE;
/*!40000 ALTER TABLE `comments` DISABLE KEYS */;
/*!40000 ALTER TABLE `comments` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `currencies`
--

DROP TABLE IF EXISTS `currencies`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `currencies` (
  `currency` char(3) NOT NULL,
  `rate` float DEFAULT '0',
  UNIQUE KEY `currency` (`currency`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `currencies`
--

LOCK TABLES `currencies` WRITE;
/*!40000 ALTER TABLE `currencies` DISABLE KEYS */;
/*!40000 ALTER TABLE `currencies` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `custom_filters`
--

DROP TABLE IF EXISTS `custom_filters`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `custom_filters` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `filter` varchar(100) NOT NULL,
  `project_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `name` varchar(100) NOT NULL,
  `is_shared` tinyint(1) DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `project_id` (`project_id`),
  KEY `user_id` (`user_id`),
  CONSTRAINT `custom_filters_ibfk_1` FOREIGN KEY (`project_id`) REFERENCES `projects` (`id`) ON DELETE CASCADE,
  CONSTRAINT `custom_filters_ibfk_2` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `custom_filters`
--

LOCK TABLES `custom_filters` WRITE;
/*!40000 ALTER TABLE `custom_filters` DISABLE KEYS */;
/*!40000 ALTER TABLE `custom_filters` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `files`
--

DROP TABLE IF EXISTS `files`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `files` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `path` varchar(255) DEFAULT NULL,
  `is_image` tinyint(1) DEFAULT '0',
  `task_id` int(11) NOT NULL,
  `date` bigint(20) DEFAULT NULL,
  `user_id` int(11) NOT NULL DEFAULT '0',
  `size` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `files_task_idx` (`task_id`),
  CONSTRAINT `files_ibfk_1` FOREIGN KEY (`task_id`) REFERENCES `tasks` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `files`
--

LOCK TABLES `files` WRITE;
/*!40000 ALTER TABLE `files` DISABLE KEYS */;
/*!40000 ALTER TABLE `files` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `last_logins`
--

DROP TABLE IF EXISTS `last_logins`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `last_logins` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `auth_type` varchar(25) DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL,
  `ip` varchar(40) DEFAULT NULL,
  `user_agent` varchar(255) DEFAULT NULL,
  `date_creation` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `user_id` (`user_id`),
  CONSTRAINT `last_logins_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `last_logins`
--

LOCK TABLES `last_logins` WRITE;
/*!40000 ALTER TABLE `last_logins` DISABLE KEYS */;
INSERT INTO `last_logins` VALUES (1,'Database',1,'192.168.33.1','Mozilla/5.0 (Windows NT 6.3; WOW64; rv:42.0) Gecko/20100101 Firefox/42.0',1448832376);
/*!40000 ALTER TABLE `last_logins` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `links`
--

DROP TABLE IF EXISTS `links`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `links` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `label` varchar(255) NOT NULL,
  `opposite_id` int(11) DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `label` (`label`)
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `links`
--

LOCK TABLES `links` WRITE;
/*!40000 ALTER TABLE `links` DISABLE KEYS */;
INSERT INTO `links` VALUES (1,'relates to',0),(2,'blocks',3),(3,'is blocked by',2),(4,'duplicates',5),(5,'is duplicated by',4),(6,'is a child of',7),(7,'is a parent of',6),(8,'targets milestone',9),(9,'is a milestone of',8),(10,'fixes',11),(11,'is fixed by',10);
/*!40000 ALTER TABLE `links` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `plugin_schema_versions`
--

DROP TABLE IF EXISTS `plugin_schema_versions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `plugin_schema_versions` (
  `plugin` varchar(80) NOT NULL,
  `version` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`plugin`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `plugin_schema_versions`
--

LOCK TABLES `plugin_schema_versions` WRITE;
/*!40000 ALTER TABLE `plugin_schema_versions` DISABLE KEYS */;
/*!40000 ALTER TABLE `plugin_schema_versions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `project_activities`
--

DROP TABLE IF EXISTS `project_activities`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `project_activities` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `date_creation` bigint(20) DEFAULT NULL,
  `event_name` varchar(50) NOT NULL,
  `creator_id` int(11) DEFAULT NULL,
  `project_id` int(11) DEFAULT NULL,
  `task_id` int(11) DEFAULT NULL,
  `data` text,
  PRIMARY KEY (`id`),
  KEY `creator_id` (`creator_id`),
  KEY `project_id` (`project_id`),
  KEY `task_id` (`task_id`),
  CONSTRAINT `project_activities_ibfk_1` FOREIGN KEY (`creator_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  CONSTRAINT `project_activities_ibfk_2` FOREIGN KEY (`project_id`) REFERENCES `projects` (`id`) ON DELETE CASCADE,
  CONSTRAINT `project_activities_ibfk_3` FOREIGN KEY (`task_id`) REFERENCES `tasks` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `project_activities`
--

LOCK TABLES `project_activities` WRITE;
/*!40000 ALTER TABLE `project_activities` DISABLE KEYS */;
INSERT INTO `project_activities` VALUES (1,1445548061,'task.create',1,1,1,'{\"task\":{\"id\":\"1\",\"reference\":\"\",\"title\":\"Puppetise Kanboard\",\"description\":\"* Create a config.default.php.erb file with mysql settings\\r\\n* Local yum repos \\r\\n* Unzip exec\\r\\n* Chown\\r\\n* iptables port exemption\\r\\n* Kanboard db creation\",\"date_creation\":\"1445548061\",\"date_completed\":null,\"date_modification\":\"1445548061\",\"date_due\":\"0\",\"date_started\":null,\"time_estimated\":\"0\",\"time_spent\":\"0\",\"color_id\":\"yellow\",\"project_id\":\"1\",\"column_id\":\"1\",\"owner_id\":\"1\",\"creator_id\":\"1\",\"position\":\"1\",\"is_active\":\"1\",\"score\":\"0\",\"category_id\":\"0\",\"swimlane_id\":\"0\",\"date_moved\":\"1445548061\",\"recurrence_status\":\"0\",\"recurrence_trigger\":\"0\",\"recurrence_factor\":\"0\",\"recurrence_timeframe\":\"0\",\"recurrence_basedate\":\"0\",\"recurrence_parent\":null,\"recurrence_child\":null,\"category_name\":null,\"swimlane_name\":null,\"project_name\":\"Career\",\"default_swimlane\":\"Default swimlane\",\"column_title\":\"Backlog\",\"assignee_username\":\"admin\",\"assignee_name\":null,\"creator_username\":\"admin\",\"creator_name\":null},\"changes\":[]}'),(2,1445548122,'subtask.create',1,1,1,'{\"task\":{\"id\":\"1\",\"reference\":\"\",\"title\":\"Puppetise Kanboard\",\"description\":\"* Create a config.default.php.erb file with mysql settings\\r\\n* Local yum repos \\r\\n* Unzip exec\\r\\n* Chown\\r\\n* iptables port exemption\\r\\n* Kanboard db creation\",\"date_creation\":\"1445548061\",\"date_completed\":null,\"date_modification\":\"1445548061\",\"date_due\":\"0\",\"date_started\":null,\"time_estimated\":\"0\",\"time_spent\":\"0\",\"color_id\":\"yellow\",\"project_id\":\"1\",\"column_id\":\"1\",\"owner_id\":\"1\",\"creator_id\":\"1\",\"position\":\"1\",\"is_active\":\"1\",\"score\":\"0\",\"category_id\":\"0\",\"swimlane_id\":\"0\",\"date_moved\":\"1445548061\",\"recurrence_status\":\"0\",\"recurrence_trigger\":\"0\",\"recurrence_factor\":\"0\",\"recurrence_timeframe\":\"0\",\"recurrence_basedate\":\"0\",\"recurrence_parent\":null,\"recurrence_child\":null,\"category_name\":null,\"swimlane_name\":null,\"project_name\":\"Career\",\"default_swimlane\":\"Default swimlane\",\"column_title\":\"Backlog\",\"assignee_username\":\"admin\",\"assignee_name\":null,\"creator_username\":\"admin\",\"creator_name\":null},\"changes\":[],\"subtask\":{\"id\":\"1\",\"title\":\"Create a config.default.php.erb file with mysql settings\",\"status\":\"0\",\"time_estimated\":\"0\",\"time_spent\":\"0\",\"task_id\":\"1\",\"user_id\":\"0\",\"position\":\"1\",\"username\":null,\"name\":null,\"timer_start_date\":0,\"status_name\":\"Todo\",\"is_timer_started\":false}}');
INSERT INTO `project_activities` VALUES (3,1445548177,'subtask.create',1,1,1,'{\"task\":{\"id\":\"1\",\"reference\":\"\",\"title\":\"Puppetise Kanboard\",\"description\":\"* Create a config.default.php.erb file with mysql settings\\r\\n* Local yum repos \\r\\n* Unzip exec\\r\\n* Chown\\r\\n* iptables port exemption\\r\\n* Kanboard db creation\",\"date_creation\":\"1445548061\",\"date_completed\":null,\"date_modification\":\"1445548061\",\"date_due\":\"0\",\"date_started\":null,\"time_estimated\":\"0\",\"time_spent\":\"0\",\"color_id\":\"yellow\",\"project_id\":\"1\",\"column_id\":\"1\",\"owner_id\":\"1\",\"creator_id\":\"1\",\"position\":\"1\",\"is_active\":\"1\",\"score\":\"0\",\"category_id\":\"0\",\"swimlane_id\":\"0\",\"date_moved\":\"1445548061\",\"recurrence_status\":\"0\",\"recurrence_trigger\":\"0\",\"recurrence_factor\":\"0\",\"recurrence_timeframe\":\"0\",\"recurrence_basedate\":\"0\",\"recurrence_parent\":null,\"recurrence_child\":null,\"category_name\":null,\"swimlane_name\":null,\"project_name\":\"Career\",\"default_swimlane\":\"Default swimlane\",\"column_title\":\"Backlog\",\"assignee_username\":\"admin\",\"assignee_name\":null,\"creator_username\":\"admin\",\"creator_name\":null},\"changes\":[],\"subtask\":{\"id\":\"2\",\"title\":\"Local yum repos\",\"status\":\"0\",\"time_estimated\":\"0\",\"time_spent\":\"0\",\"task_id\":\"1\",\"user_id\":\"0\",\"position\":\"2\",\"username\":null,\"name\":null,\"timer_start_date\":0,\"status_name\":\"Todo\",\"is_timer_started\":false}}'),(4,1445548189,'subtask.create',1,1,1,'{\"task\":{\"id\":\"1\",\"reference\":\"\",\"title\":\"Puppetise Kanboard\",\"description\":\"* Create a config.default.php.erb file with mysql settings\\r\\n* Local yum repos \\r\\n* Unzip exec\\r\\n* Chown\\r\\n* iptables port exemption\\r\\n* Kanboard db creation\",\"date_creation\":\"1445548061\",\"date_completed\":null,\"date_modification\":\"1445548061\",\"date_due\":\"0\",\"date_started\":null,\"time_estimated\":\"0\",\"time_spent\":\"0\",\"color_id\":\"yellow\",\"project_id\":\"1\",\"column_id\":\"1\",\"owner_id\":\"1\",\"creator_id\":\"1\",\"position\":\"1\",\"is_active\":\"1\",\"score\":\"0\",\"category_id\":\"0\",\"swimlane_id\":\"0\",\"date_moved\":\"1445548061\",\"recurrence_status\":\"0\",\"recurrence_trigger\":\"0\",\"recurrence_factor\":\"0\",\"recurrence_timeframe\":\"0\",\"recurrence_basedate\":\"0\",\"recurrence_parent\":null,\"recurrence_child\":null,\"category_name\":null,\"swimlane_name\":null,\"project_name\":\"Career\",\"default_swimlane\":\"Default swimlane\",\"column_title\":\"Backlog\",\"assignee_username\":\"admin\",\"assignee_name\":null,\"creator_username\":\"admin\",\"creator_name\":null},\"changes\":[],\"subtask\":{\"id\":\"3\",\"title\":\"Unzip exec\",\"status\":\"0\",\"time_estimated\":\"0\",\"time_spent\":\"0\",\"task_id\":\"1\",\"user_id\":\"0\",\"position\":\"3\",\"username\":null,\"name\":null,\"timer_start_date\":0,\"status_name\":\"Todo\",\"is_timer_started\":false}}');
INSERT INTO `project_activities` VALUES (5,1445548201,'subtask.create',1,1,1,'{\"task\":{\"id\":\"1\",\"reference\":\"\",\"title\":\"Puppetise Kanboard\",\"description\":\"* Create a config.default.php.erb file with mysql settings\\r\\n* Local yum repos \\r\\n* Unzip exec\\r\\n* Chown\\r\\n* iptables port exemption\\r\\n* Kanboard db creation\",\"date_creation\":\"1445548061\",\"date_completed\":null,\"date_modification\":\"1445548061\",\"date_due\":\"0\",\"date_started\":null,\"time_estimated\":\"0\",\"time_spent\":\"0\",\"color_id\":\"yellow\",\"project_id\":\"1\",\"column_id\":\"1\",\"owner_id\":\"1\",\"creator_id\":\"1\",\"position\":\"1\",\"is_active\":\"1\",\"score\":\"0\",\"category_id\":\"0\",\"swimlane_id\":\"0\",\"date_moved\":\"1445548061\",\"recurrence_status\":\"0\",\"recurrence_trigger\":\"0\",\"recurrence_factor\":\"0\",\"recurrence_timeframe\":\"0\",\"recurrence_basedate\":\"0\",\"recurrence_parent\":null,\"recurrence_child\":null,\"category_name\":null,\"swimlane_name\":null,\"project_name\":\"Career\",\"default_swimlane\":\"Default swimlane\",\"column_title\":\"Backlog\",\"assignee_username\":\"admin\",\"assignee_name\":null,\"creator_username\":\"admin\",\"creator_name\":null},\"changes\":[],\"subtask\":{\"id\":\"4\",\"title\":\"Chown\",\"status\":\"0\",\"time_estimated\":\"0\",\"time_spent\":\"0\",\"task_id\":\"1\",\"user_id\":\"0\",\"position\":\"4\",\"username\":null,\"name\":null,\"timer_start_date\":0,\"status_name\":\"Todo\",\"is_timer_started\":false}}'),(6,1445548218,'subtask.create',1,1,1,'{\"task\":{\"id\":\"1\",\"reference\":\"\",\"title\":\"Puppetise Kanboard\",\"description\":\"* Create a config.default.php.erb file with mysql settings\\r\\n* Local yum repos \\r\\n* Unzip exec\\r\\n* Chown\\r\\n* iptables port exemption\\r\\n* Kanboard db creation\",\"date_creation\":\"1445548061\",\"date_completed\":null,\"date_modification\":\"1445548061\",\"date_due\":\"0\",\"date_started\":null,\"time_estimated\":\"0\",\"time_spent\":\"0\",\"color_id\":\"yellow\",\"project_id\":\"1\",\"column_id\":\"1\",\"owner_id\":\"1\",\"creator_id\":\"1\",\"position\":\"1\",\"is_active\":\"1\",\"score\":\"0\",\"category_id\":\"0\",\"swimlane_id\":\"0\",\"date_moved\":\"1445548061\",\"recurrence_status\":\"0\",\"recurrence_trigger\":\"0\",\"recurrence_factor\":\"0\",\"recurrence_timeframe\":\"0\",\"recurrence_basedate\":\"0\",\"recurrence_parent\":null,\"recurrence_child\":null,\"category_name\":null,\"swimlane_name\":null,\"project_name\":\"Career\",\"default_swimlane\":\"Default swimlane\",\"column_title\":\"Backlog\",\"assignee_username\":\"admin\",\"assignee_name\":null,\"creator_username\":\"admin\",\"creator_name\":null},\"changes\":[],\"subtask\":{\"id\":\"5\",\"title\":\"Iptables port exemption on port 8080\",\"status\":\"0\",\"time_estimated\":\"0\",\"time_spent\":\"0\",\"task_id\":\"1\",\"user_id\":\"0\",\"position\":\"5\",\"username\":null,\"name\":null,\"timer_start_date\":0,\"status_name\":\"Todo\",\"is_timer_started\":false}}');
INSERT INTO `project_activities` VALUES (7,1445548228,'subtask.create',1,1,1,'{\"task\":{\"id\":\"1\",\"reference\":\"\",\"title\":\"Puppetise Kanboard\",\"description\":\"* Create a config.default.php.erb file with mysql settings\\r\\n* Local yum repos \\r\\n* Unzip exec\\r\\n* Chown\\r\\n* iptables port exemption\\r\\n* Kanboard db creation\",\"date_creation\":\"1445548061\",\"date_completed\":null,\"date_modification\":\"1445548061\",\"date_due\":\"0\",\"date_started\":null,\"time_estimated\":\"0\",\"time_spent\":\"0\",\"color_id\":\"yellow\",\"project_id\":\"1\",\"column_id\":\"1\",\"owner_id\":\"1\",\"creator_id\":\"1\",\"position\":\"1\",\"is_active\":\"1\",\"score\":\"0\",\"category_id\":\"0\",\"swimlane_id\":\"0\",\"date_moved\":\"1445548061\",\"recurrence_status\":\"0\",\"recurrence_trigger\":\"0\",\"recurrence_factor\":\"0\",\"recurrence_timeframe\":\"0\",\"recurrence_basedate\":\"0\",\"recurrence_parent\":null,\"recurrence_child\":null,\"category_name\":null,\"swimlane_name\":null,\"project_name\":\"Career\",\"default_swimlane\":\"Default swimlane\",\"column_title\":\"Backlog\",\"assignee_username\":\"admin\",\"assignee_name\":null,\"creator_username\":\"admin\",\"creator_name\":null},\"changes\":[],\"subtask\":{\"id\":\"6\",\"title\":\"Kanboard db creation\",\"status\":\"0\",\"time_estimated\":\"0\",\"time_spent\":\"0\",\"task_id\":\"1\",\"user_id\":\"0\",\"position\":\"6\",\"username\":null,\"name\":null,\"timer_start_date\":0,\"status_name\":\"Todo\",\"is_timer_started\":false}}'),(8,1445548325,'subtask.create',1,1,1,'{\"task\":{\"id\":\"1\",\"reference\":\"\",\"title\":\"Puppetise Kanboard\",\"description\":\"* Create a config.default.php.erb file with mysql settings\\r\\n* Local yum repos \\r\\n* Unzip exec\\r\\n* Chown\\r\\n* iptables port exemption\\r\\n* Kanboard db creation\",\"date_creation\":\"1445548061\",\"date_completed\":null,\"date_modification\":\"1445548061\",\"date_due\":\"0\",\"date_started\":null,\"time_estimated\":\"0\",\"time_spent\":\"0\",\"color_id\":\"yellow\",\"project_id\":\"1\",\"column_id\":\"1\",\"owner_id\":\"1\",\"creator_id\":\"1\",\"position\":\"1\",\"is_active\":\"1\",\"score\":\"0\",\"category_id\":\"0\",\"swimlane_id\":\"0\",\"date_moved\":\"1445548061\",\"recurrence_status\":\"0\",\"recurrence_trigger\":\"0\",\"recurrence_factor\":\"0\",\"recurrence_timeframe\":\"0\",\"recurrence_basedate\":\"0\",\"recurrence_parent\":null,\"recurrence_child\":null,\"category_name\":null,\"swimlane_name\":null,\"project_name\":\"Career\",\"default_swimlane\":\"Default swimlane\",\"column_title\":\"Backlog\",\"assignee_username\":\"admin\",\"assignee_name\":null,\"creator_username\":\"admin\",\"creator_name\":null},\"changes\":[],\"subtask\":{\"id\":\"7\",\"title\":\"Database backup\",\"status\":\"0\",\"time_estimated\":\"0\",\"time_spent\":\"0\",\"task_id\":\"1\",\"user_id\":\"0\",\"position\":\"7\",\"username\":null,\"name\":null,\"timer_start_date\":0,\"status_name\":\"Todo\",\"is_timer_started\":false}}');
INSERT INTO `project_activities` VALUES (9,1445548437,'subtask.create',1,1,1,'{\"task\":{\"id\":\"1\",\"reference\":\"\",\"title\":\"Puppetise Kanboard\",\"description\":\"* Create a config.default.php.erb file with mysql settings\\r\\n* Local yum repos \\r\\n* Unzip exec\\r\\n* Chown\\r\\n* iptables port exemption\\r\\n* Kanboard db creation\",\"date_creation\":\"1445548061\",\"date_completed\":null,\"date_modification\":\"1445548061\",\"date_due\":\"0\",\"date_started\":null,\"time_estimated\":\"0\",\"time_spent\":\"0\",\"color_id\":\"yellow\",\"project_id\":\"1\",\"column_id\":\"1\",\"owner_id\":\"1\",\"creator_id\":\"1\",\"position\":\"1\",\"is_active\":\"1\",\"score\":\"0\",\"category_id\":\"0\",\"swimlane_id\":\"0\",\"date_moved\":\"1445548061\",\"recurrence_status\":\"0\",\"recurrence_trigger\":\"0\",\"recurrence_factor\":\"0\",\"recurrence_timeframe\":\"0\",\"recurrence_basedate\":\"0\",\"recurrence_parent\":null,\"recurrence_child\":null,\"category_name\":null,\"swimlane_name\":null,\"project_name\":\"Career\",\"default_swimlane\":\"Default swimlane\",\"column_title\":\"Backlog\",\"assignee_username\":\"admin\",\"assignee_name\":null,\"creator_username\":\"admin\",\"creator_name\":null},\"changes\":[],\"subtask\":{\"id\":\"8\",\"title\":\"Kanboard versioning\",\"status\":\"0\",\"time_estimated\":\"0\",\"time_spent\":\"0\",\"task_id\":\"1\",\"user_id\":\"0\",\"position\":\"8\",\"username\":null,\"name\":null,\"timer_start_date\":0,\"status_name\":\"Todo\",\"is_timer_started\":false}}'),(10,1445548655,'task.create',1,1,2,'{\"task\":{\"id\":\"2\",\"reference\":\"\",\"title\":\"Augeas tool\",\"description\":\"Create a blog post to explain the usage of Augeas for puppet.\\r\\n\\r\\nFocus on debugging using augtool.\\r\\n\\r\\nInclude silent failures.\\r\\n\\r\\nExplanation of lenses.\",\"date_creation\":\"1445548655\",\"date_completed\":null,\"date_modification\":\"1445548655\",\"date_due\":\"0\",\"date_started\":null,\"time_estimated\":\"0\",\"time_spent\":\"0\",\"color_id\":\"yellow\",\"project_id\":\"1\",\"column_id\":\"1\",\"owner_id\":\"1\",\"creator_id\":\"1\",\"position\":\"2\",\"is_active\":\"1\",\"score\":\"0\",\"category_id\":\"0\",\"swimlane_id\":\"0\",\"date_moved\":\"1445548655\",\"recurrence_status\":\"0\",\"recurrence_trigger\":\"0\",\"recurrence_factor\":\"0\",\"recurrence_timeframe\":\"0\",\"recurrence_basedate\":\"0\",\"recurrence_parent\":null,\"recurrence_child\":null,\"category_name\":null,\"swimlane_name\":null,\"project_name\":\"Career\",\"default_swimlane\":\"Default swimlane\",\"column_title\":\"Backlog\",\"assignee_username\":\"admin\",\"assignee_name\":null,\"creator_username\":\"admin\",\"creator_name\":null},\"changes\":[]}');
INSERT INTO `project_activities` VALUES (11,1445550145,'subtask.create',1,1,1,'{\"task\":{\"id\":\"1\",\"reference\":\"\",\"title\":\"Puppetise Kanboard\",\"description\":\"* Create a config.default.php.erb file with mysql settings\\r\\n* Local yum repos \\r\\n* Unzip exec\\r\\n* Chown\\r\\n* iptables port exemption\\r\\n* Kanboard db creation\",\"date_creation\":\"1445548061\",\"date_completed\":null,\"date_modification\":\"1445548061\",\"date_due\":\"0\",\"date_started\":null,\"time_estimated\":\"0\",\"time_spent\":\"0\",\"color_id\":\"yellow\",\"project_id\":\"1\",\"column_id\":\"1\",\"owner_id\":\"1\",\"creator_id\":\"1\",\"position\":\"1\",\"is_active\":\"1\",\"score\":\"0\",\"category_id\":\"0\",\"swimlane_id\":\"0\",\"date_moved\":\"1445548061\",\"recurrence_status\":\"0\",\"recurrence_trigger\":\"0\",\"recurrence_factor\":\"0\",\"recurrence_timeframe\":\"0\",\"recurrence_basedate\":\"0\",\"recurrence_parent\":null,\"recurrence_child\":null,\"category_name\":null,\"swimlane_name\":null,\"project_name\":\"Career\",\"default_swimlane\":\"Default swimlane\",\"column_title\":\"Backlog\",\"assignee_username\":\"admin\",\"assignee_name\":null,\"creator_username\":\"admin\",\"creator_name\":null},\"changes\":[],\"subtask\":{\"id\":\"9\",\"title\":\"External port & dynamic DNS\",\"status\":\"0\",\"time_estimated\":\"0\",\"time_spent\":\"0\",\"task_id\":\"1\",\"user_id\":\"0\",\"position\":\"9\",\"username\":null,\"name\":null,\"timer_start_date\":0,\"status_name\":\"Todo\",\"is_timer_started\":false}}'),(12,1446045812,'task.create',1,1,3,'{\"task\":{\"id\":\"3\",\"reference\":\"\",\"title\":\"Domain name setup\",\"description\":\"Get my domain name(s) working with the internal sky router and a VM.\",\"date_creation\":\"1446045812\",\"date_completed\":null,\"date_modification\":\"1446045812\",\"date_due\":\"0\",\"date_started\":null,\"time_estimated\":\"0\",\"time_spent\":\"0\",\"color_id\":\"yellow\",\"project_id\":\"1\",\"column_id\":\"1\",\"owner_id\":\"1\",\"creator_id\":\"1\",\"position\":\"3\",\"is_active\":\"1\",\"score\":\"0\",\"category_id\":\"0\",\"swimlane_id\":\"0\",\"date_moved\":\"1446045812\",\"recurrence_status\":\"0\",\"recurrence_trigger\":\"0\",\"recurrence_factor\":\"0\",\"recurrence_timeframe\":\"0\",\"recurrence_basedate\":\"0\",\"recurrence_parent\":null,\"recurrence_child\":null,\"category_name\":null,\"swimlane_name\":null,\"project_name\":\"Career\",\"default_swimlane\":\"Default swimlane\",\"column_title\":\"Backlog\",\"assignee_username\":\"admin\",\"assignee_name\":null,\"creator_username\":\"admin\",\"creator_name\":null},\"changes\":[]}'),(13,1446063888,'subtask.create',1,1,3,'{\"task\":{\"id\":\"3\",\"reference\":\"\",\"title\":\"Domain name setup\",\"description\":\"Get my domain name(s) working with the internal sky router and a VM.\",\"date_creation\":\"1446045812\",\"date_completed\":null,\"date_modification\":\"1446045812\",\"date_due\":\"0\",\"date_started\":null,\"time_estimated\":\"0\",\"time_spent\":\"0\",\"color_id\":\"yellow\",\"project_id\":\"1\",\"column_id\":\"1\",\"owner_id\":\"1\",\"creator_id\":\"1\",\"position\":\"3\",\"is_active\":\"1\",\"score\":\"0\",\"category_id\":\"0\",\"swimlane_id\":\"0\",\"date_moved\":\"1446045812\",\"recurrence_status\":\"0\",\"recurrence_trigger\":\"0\",\"recurrence_factor\":\"0\",\"recurrence_timeframe\":\"0\",\"recurrence_basedate\":\"0\",\"recurrence_parent\":null,\"recurrence_child\":null,\"category_name\":null,\"swimlane_name\":null,\"project_name\":\"Career\",\"default_swimlane\":\"Default swimlane\",\"column_title\":\"Backlog\",\"assignee_username\":\"admin\",\"assignee_name\":null,\"creator_username\":\"admin\",\"creator_name\":null},\"changes\":[],\"subtask\":{\"id\":\"10\",\"title\":\"Set up port forwarding on 8100 on router\",\"status\":\"0\",\"time_estimated\":\"0\",\"time_spent\":\"0\",\"task_id\":\"3\",\"user_id\":\"0\",\"position\":\"1\",\"username\":null,\"name\":null,\"timer_start_date\":0,\"status_name\":\"Todo\",\"is_timer_started\":false}}');
INSERT INTO `project_activities` VALUES (14,1448832617,'task.create',1,2,4,'{\"task\":{\"id\":\"4\",\"reference\":\"\",\"title\":\"NRE LDB Creds\",\"description\":\"Get National Rail Enquiries credentials for the live depature boards service.\\r\\n\\r\\nhttps:\\/\\/lite.realtime.nationalrail.co.uk\\/OpenLDBWS\\/\",\"date_creation\":\"1448832616\",\"date_completed\":null,\"date_modification\":\"1448832616\",\"date_due\":\"0\",\"date_started\":null,\"time_estimated\":\"0\",\"time_spent\":\"0\",\"color_id\":\"yellow\",\"project_id\":\"2\",\"column_id\":\"7\",\"owner_id\":\"1\",\"creator_id\":\"1\",\"position\":\"1\",\"is_active\":\"1\",\"score\":\"0\",\"category_id\":\"0\",\"swimlane_id\":\"0\",\"date_moved\":\"1448832616\",\"recurrence_status\":\"0\",\"recurrence_trigger\":\"0\",\"recurrence_factor\":\"0\",\"recurrence_timeframe\":\"0\",\"recurrence_basedate\":\"0\",\"recurrence_parent\":null,\"recurrence_child\":null,\"category_name\":null,\"swimlane_name\":null,\"project_name\":\"Beverley\",\"default_swimlane\":\"Default swimlane\",\"column_title\":\"Backlog\",\"assignee_username\":\"admin\",\"assignee_name\":null,\"creator_username\":\"admin\",\"creator_name\":null},\"changes\":[]}'),(15,1448835093,'task.create',1,2,5,'{\"task\":{\"id\":\"5\",\"reference\":\"\",\"title\":\"Download WSDL files\",\"description\":\"Download the web service description language (WSDL) files from the nation rail enquiries web site.\",\"date_creation\":\"1448835093\",\"date_completed\":null,\"date_modification\":\"1448835093\",\"date_due\":\"0\",\"date_started\":null,\"time_estimated\":\"0\",\"time_spent\":\"0\",\"color_id\":\"yellow\",\"project_id\":\"2\",\"column_id\":\"7\",\"owner_id\":\"1\",\"creator_id\":\"1\",\"position\":\"2\",\"is_active\":\"1\",\"score\":\"0\",\"category_id\":\"0\",\"swimlane_id\":\"0\",\"date_moved\":\"1448835093\",\"recurrence_status\":\"0\",\"recurrence_trigger\":\"0\",\"recurrence_factor\":\"0\",\"recurrence_timeframe\":\"0\",\"recurrence_basedate\":\"0\",\"recurrence_parent\":null,\"recurrence_child\":null,\"category_name\":null,\"swimlane_name\":null,\"project_name\":\"Beverley\",\"default_swimlane\":\"Default swimlane\",\"column_title\":\"Backlog\",\"assignee_username\":\"admin\",\"assignee_name\":null,\"creator_username\":\"admin\",\"creator_name\":null},\"changes\":[]}');
/*!40000 ALTER TABLE `project_activities` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `project_daily_column_stats`
--

DROP TABLE IF EXISTS `project_daily_column_stats`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `project_daily_column_stats` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `day` char(10) NOT NULL,
  `project_id` int(11) NOT NULL,
  `column_id` int(11) NOT NULL,
  `total` int(11) NOT NULL DEFAULT '0',
  `score` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `project_daily_column_stats_idx` (`day`,`project_id`,`column_id`),
  KEY `column_id` (`column_id`),
  KEY `project_id` (`project_id`),
  CONSTRAINT `project_daily_column_stats_ibfk_1` FOREIGN KEY (`column_id`) REFERENCES `columns` (`id`) ON DELETE CASCADE,
  CONSTRAINT `project_daily_column_stats_ibfk_2` FOREIGN KEY (`project_id`) REFERENCES `projects` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `project_daily_column_stats`
--

LOCK TABLES `project_daily_column_stats` WRITE;
/*!40000 ALTER TABLE `project_daily_column_stats` DISABLE KEYS */;
INSERT INTO `project_daily_column_stats` VALUES (1,'2015-10-22',1,1,2,0),(2,'2015-10-22',1,2,0,0),(3,'2015-10-22',1,3,0,0),(4,'2015-10-22',1,4,0,0),(5,'2015-10-22',1,5,0,0),(6,'2015-10-22',1,6,0,0),(7,'2015-10-28',1,1,3,0),(8,'2015-10-28',1,2,0,0),(9,'2015-10-28',1,3,0,0),(10,'2015-10-28',1,4,0,0),(11,'2015-10-28',1,5,0,0),(12,'2015-10-28',1,6,0,0),(13,'2015-11-29',2,7,2,0),(14,'2015-11-29',2,8,0,0),(15,'2015-11-29',2,9,0,0),(16,'2015-11-29',2,10,0,0);
/*!40000 ALTER TABLE `project_daily_column_stats` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `project_daily_stats`
--

DROP TABLE IF EXISTS `project_daily_stats`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `project_daily_stats` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `day` char(10) NOT NULL,
  `project_id` int(11) NOT NULL,
  `avg_lead_time` int(11) NOT NULL DEFAULT '0',
  `avg_cycle_time` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `project_daily_stats_idx` (`day`,`project_id`),
  KEY `project_id` (`project_id`),
  CONSTRAINT `project_daily_stats_ibfk_1` FOREIGN KEY (`project_id`) REFERENCES `projects` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `project_daily_stats`
--

LOCK TABLES `project_daily_stats` WRITE;
/*!40000 ALTER TABLE `project_daily_stats` DISABLE KEYS */;
INSERT INTO `project_daily_stats` VALUES (1,'2015-10-22',1,297,0),(2,'2015-10-28',1,331636,0),(3,'2015-11-29',2,1238,0);
/*!40000 ALTER TABLE `project_daily_stats` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `project_has_categories`
--

DROP TABLE IF EXISTS `project_has_categories`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `project_has_categories` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `project_id` int(11) NOT NULL,
  `description` text,
  PRIMARY KEY (`id`),
  UNIQUE KEY `idx_project_category` (`project_id`,`name`),
  KEY `categories_project_idx` (`project_id`),
  CONSTRAINT `project_has_categories_ibfk_1` FOREIGN KEY (`project_id`) REFERENCES `projects` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `project_has_categories`
--

LOCK TABLES `project_has_categories` WRITE;
/*!40000 ALTER TABLE `project_has_categories` DISABLE KEYS */;
INSERT INTO `project_has_categories` VALUES (1,'Bug',1,NULL),(2,'Feature',1,NULL),(3,'Platform',1,NULL),(4,'Improvement',1,NULL),(5,'Spike',1,NULL),(6,'Blog',1,NULL);
/*!40000 ALTER TABLE `project_has_categories` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `project_has_users`
--

DROP TABLE IF EXISTS `project_has_users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `project_has_users` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `project_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `is_owner` tinyint(1) DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `idx_project_user` (`project_id`,`user_id`),
  KEY `user_id` (`user_id`),
  CONSTRAINT `project_has_users_ibfk_1` FOREIGN KEY (`project_id`) REFERENCES `projects` (`id`) ON DELETE CASCADE,
  CONSTRAINT `project_has_users_ibfk_2` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `project_has_users`
--

LOCK TABLES `project_has_users` WRITE;
/*!40000 ALTER TABLE `project_has_users` DISABLE KEYS */;
INSERT INTO `project_has_users` VALUES (1,1,1,1),(2,2,1,1);
/*!40000 ALTER TABLE `project_has_users` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `project_integrations`
--

DROP TABLE IF EXISTS `project_integrations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `project_integrations` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `project_id` int(11) NOT NULL,
  `hipchat` tinyint(1) DEFAULT '0',
  `hipchat_api_url` varchar(255) DEFAULT 'https://api.hipchat.com',
  `hipchat_room_id` varchar(255) DEFAULT NULL,
  `hipchat_room_token` varchar(255) DEFAULT NULL,
  `slack` tinyint(1) DEFAULT '0',
  `slack_webhook_url` varchar(255) DEFAULT NULL,
  `jabber` int(11) DEFAULT '0',
  `jabber_server` varchar(255) DEFAULT '',
  `jabber_domain` varchar(255) DEFAULT '',
  `jabber_username` varchar(255) DEFAULT '',
  `jabber_password` varchar(255) DEFAULT '',
  `jabber_nickname` varchar(255) DEFAULT 'kanboard',
  `jabber_room` varchar(255) DEFAULT '',
  `slack_webhook_channel` varchar(255) DEFAULT '',
  PRIMARY KEY (`id`),
  UNIQUE KEY `project_id` (`project_id`),
  CONSTRAINT `project_integrations_ibfk_1` FOREIGN KEY (`project_id`) REFERENCES `projects` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `project_integrations`
--

LOCK TABLES `project_integrations` WRITE;
/*!40000 ALTER TABLE `project_integrations` DISABLE KEYS */;
/*!40000 ALTER TABLE `project_integrations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `projects`
--

DROP TABLE IF EXISTS `projects`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `projects` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `is_active` tinyint(4) DEFAULT '1',
  `token` varchar(255) DEFAULT NULL,
  `last_modified` bigint(20) DEFAULT NULL,
  `is_public` tinyint(1) DEFAULT '0',
  `is_private` tinyint(1) DEFAULT '0',
  `is_everybody_allowed` tinyint(1) DEFAULT '0',
  `default_swimlane` varchar(200) DEFAULT 'Default swimlane',
  `show_default_swimlane` int(11) DEFAULT '1',
  `description` text,
  `identifier` varchar(50) DEFAULT '',
  `start_date` varchar(10) DEFAULT '',
  `end_date` varchar(10) DEFAULT '',
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`),
  UNIQUE KEY `name_2` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `projects`
--

LOCK TABLES `projects` WRITE;
/*!40000 ALTER TABLE `projects` DISABLE KEYS */;
INSERT INTO `projects` VALUES (1,'Career',1,'',1446045812,0,0,0,'Default swimlane',1,'A place for tasks that contribute towards my career e.g.:\r\n* Curriculum Vitae\r\n* Blogging\r\n* Skills','CA','2015-10-22',''),(2,'Beverley',1,'',1448835093,0,0,0,'Default swimlane',1,NULL,'','','');
/*!40000 ALTER TABLE `projects` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `remember_me`
--

DROP TABLE IF EXISTS `remember_me`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `remember_me` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) DEFAULT NULL,
  `ip` varchar(40) DEFAULT NULL,
  `user_agent` varchar(255) DEFAULT NULL,
  `token` varchar(255) DEFAULT NULL,
  `sequence` varchar(255) DEFAULT NULL,
  `expiration` int(11) DEFAULT NULL,
  `date_creation` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `user_id` (`user_id`),
  CONSTRAINT `remember_me_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `remember_me`
--

LOCK TABLES `remember_me` WRITE;
/*!40000 ALTER TABLE `remember_me` DISABLE KEYS */;
INSERT INTO `remember_me` VALUES (1,1,'192.168.33.1','Mozilla/5.0 (Windows NT 6.3; WOW64; rv:42.0) Gecko/20100101 Firefox/42.0','c21534081f5e94e005fc88dc461f1793a084d6061a17581fcabd61532f49d0bb','26b989bb365e8b0a10b564e23e052946f9c26927da46733513f7f80d593a',1454016376,1448832376);
/*!40000 ALTER TABLE `remember_me` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `schema_version`
--

DROP TABLE IF EXISTS `schema_version`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `schema_version` (
  `version` int(11) DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `schema_version`
--

LOCK TABLES `schema_version` WRITE;
/*!40000 ALTER TABLE `schema_version` DISABLE KEYS */;
INSERT INTO `schema_version` VALUES (90);
/*!40000 ALTER TABLE `schema_version` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `settings`
--

DROP TABLE IF EXISTS `settings`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `settings` (
  `option` varchar(100) NOT NULL,
  `value` varchar(255) DEFAULT '',
  PRIMARY KEY (`option`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `settings`
--

LOCK TABLES `settings` WRITE;
/*!40000 ALTER TABLE `settings` DISABLE KEYS */;
INSERT INTO `settings` VALUES ('api_token','3f5147052e932f6664048dc45cfa501fd1bf4ce1e31660281a88290267fb'),('application_currency','USD'),('application_date_format','m/d/Y'),('application_language','en_US'),('application_stylesheet',''),('application_timezone','UTC'),('application_url',''),('board_columns','Backlog, Ready, Development, Testing, Release, Done'),('board_highlight_period','172800'),('board_private_refresh_interval','10'),('board_public_refresh_interval','60'),('calendar_project_tasks','date_started'),('calendar_user_subtasks_time_tracking','0'),('calendar_user_tasks','date_started'),('cfd_include_closed_tasks','1'),('default_color','yellow'),('integration_gravatar','0'),('integration_hipchat','0'),('integration_hipchat_api_url','https://api.hipchat.com'),('integration_hipchat_room_id',''),('integration_hipchat_room_token',''),('integration_jabber','0'),('integration_jabber_domain',''),('integration_jabber_nickname','kanboard'),('integration_jabber_password',''),('integration_jabber_room',''),('integration_jabber_server',''),('integration_jabber_username',''),('integration_slack_webhook','0'),('integration_slack_webhook_channel',''),('integration_slack_webhook_url',''),('project_categories','Bug, Feature, Platform, Improvement, Spike, Blog'),('subtask_restriction','0'),('subtask_time_tracking','1'),('webhook_token','0c6dba84aa5a5ea1390da6ef1e0112ac092625356d09a60c89b670aeb1aa'),('webhook_url','');
/*!40000 ALTER TABLE `settings` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `subtask_time_tracking`
--

DROP TABLE IF EXISTS `subtask_time_tracking`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `subtask_time_tracking` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `subtask_id` int(11) NOT NULL,
  `start` bigint(20) DEFAULT NULL,
  `end` bigint(20) DEFAULT NULL,
  `time_spent` float DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `user_id` (`user_id`),
  KEY `subtask_id` (`subtask_id`),
  CONSTRAINT `subtask_time_tracking_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  CONSTRAINT `subtask_time_tracking_ibfk_2` FOREIGN KEY (`subtask_id`) REFERENCES `subtasks` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `subtask_time_tracking`
--

LOCK TABLES `subtask_time_tracking` WRITE;
/*!40000 ALTER TABLE `subtask_time_tracking` DISABLE KEYS */;
/*!40000 ALTER TABLE `subtask_time_tracking` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `subtasks`
--

DROP TABLE IF EXISTS `subtasks`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `subtasks` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `title` varchar(255) NOT NULL,
  `status` int(11) DEFAULT '0',
  `time_estimated` float DEFAULT NULL,
  `time_spent` float DEFAULT NULL,
  `task_id` int(11) NOT NULL,
  `user_id` int(11) DEFAULT NULL,
  `position` int(11) DEFAULT '1',
  PRIMARY KEY (`id`),
  KEY `subtasks_task_idx` (`task_id`),
  CONSTRAINT `subtasks_ibfk_1` FOREIGN KEY (`task_id`) REFERENCES `tasks` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `subtasks`
--

LOCK TABLES `subtasks` WRITE;
/*!40000 ALTER TABLE `subtasks` DISABLE KEYS */;
INSERT INTO `subtasks` VALUES (1,'Create a config.default.php.erb file with mysql settings',0,0,0,1,0,1),(2,'Local yum repos',0,0,0,1,0,2),(3,'Unzip exec',0,0,0,1,0,3),(4,'Chown',0,0,0,1,0,4),(5,'Iptables port exemption on port 8080',0,0,0,1,0,5),(6,'Kanboard db creation',0,0,0,1,0,6),(7,'Database backup',0,0,0,1,0,7),(8,'Kanboard versioning',0,0,0,1,0,8),(9,'External port & dynamic DNS',0,0,0,1,0,9),(10,'Set up port forwarding on 8100 on router',0,0,0,3,0,1);
/*!40000 ALTER TABLE `subtasks` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `swimlanes`
--

DROP TABLE IF EXISTS `swimlanes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `swimlanes` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(200) NOT NULL,
  `position` int(11) DEFAULT '1',
  `is_active` int(11) DEFAULT '1',
  `project_id` int(11) DEFAULT NULL,
  `description` text,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`,`project_id`),
  KEY `swimlanes_project_idx` (`project_id`),
  CONSTRAINT `swimlanes_ibfk_1` FOREIGN KEY (`project_id`) REFERENCES `projects` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `swimlanes`
--

LOCK TABLES `swimlanes` WRITE;
/*!40000 ALTER TABLE `swimlanes` DISABLE KEYS */;
/*!40000 ALTER TABLE `swimlanes` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `task_has_links`
--

DROP TABLE IF EXISTS `task_has_links`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `task_has_links` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `link_id` int(11) NOT NULL,
  `task_id` int(11) NOT NULL,
  `opposite_task_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `task_has_links_unique` (`link_id`,`task_id`,`opposite_task_id`),
  KEY `opposite_task_id` (`opposite_task_id`),
  KEY `task_has_links_task_index` (`task_id`),
  CONSTRAINT `task_has_links_ibfk_1` FOREIGN KEY (`link_id`) REFERENCES `links` (`id`) ON DELETE CASCADE,
  CONSTRAINT `task_has_links_ibfk_2` FOREIGN KEY (`task_id`) REFERENCES `tasks` (`id`) ON DELETE CASCADE,
  CONSTRAINT `task_has_links_ibfk_3` FOREIGN KEY (`opposite_task_id`) REFERENCES `tasks` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `task_has_links`
--

LOCK TABLES `task_has_links` WRITE;
/*!40000 ALTER TABLE `task_has_links` DISABLE KEYS */;
/*!40000 ALTER TABLE `task_has_links` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tasks`
--

DROP TABLE IF EXISTS `tasks`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tasks` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `title` varchar(255) NOT NULL,
  `description` text,
  `date_creation` bigint(20) DEFAULT NULL,
  `date_completed` bigint(20) DEFAULT NULL,
  `date_due` bigint(20) DEFAULT NULL,
  `color_id` varchar(50) DEFAULT NULL,
  `project_id` int(11) NOT NULL,
  `column_id` int(11) NOT NULL,
  `owner_id` int(11) DEFAULT '0',
  `position` int(11) DEFAULT NULL,
  `score` int(11) DEFAULT NULL,
  `is_active` tinyint(4) DEFAULT '1',
  `category_id` int(11) DEFAULT '0',
  `creator_id` int(11) DEFAULT '0',
  `date_modification` int(11) DEFAULT '0',
  `reference` varchar(50) DEFAULT '',
  `date_started` bigint(20) DEFAULT NULL,
  `time_spent` float DEFAULT '0',
  `time_estimated` float DEFAULT '0',
  `swimlane_id` int(11) DEFAULT '0',
  `date_moved` bigint(20) DEFAULT NULL,
  `recurrence_status` int(11) NOT NULL DEFAULT '0',
  `recurrence_trigger` int(11) NOT NULL DEFAULT '0',
  `recurrence_factor` int(11) NOT NULL DEFAULT '0',
  `recurrence_timeframe` int(11) NOT NULL DEFAULT '0',
  `recurrence_basedate` int(11) NOT NULL DEFAULT '0',
  `recurrence_parent` int(11) DEFAULT NULL,
  `recurrence_child` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_task_active` (`is_active`),
  KEY `column_id` (`column_id`),
  KEY `tasks_reference_idx` (`reference`),
  KEY `tasks_project_idx` (`project_id`),
  CONSTRAINT `tasks_ibfk_1` FOREIGN KEY (`project_id`) REFERENCES `projects` (`id`) ON DELETE CASCADE,
  CONSTRAINT `tasks_ibfk_2` FOREIGN KEY (`column_id`) REFERENCES `columns` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tasks`
--

LOCK TABLES `tasks` WRITE;
/*!40000 ALTER TABLE `tasks` DISABLE KEYS */;
INSERT INTO `tasks` VALUES (1,'Puppetise Kanboard','* Create a config.default.php.erb file with mysql settings\r\n* Local yum repos \r\n* Unzip exec\r\n* Chown\r\n* iptables port exemption\r\n* Kanboard db creation',1445548061,NULL,0,'yellow',1,1,1,1,0,1,0,1,1445548061,'',NULL,0,0,0,1445548061,0,0,0,0,0,NULL,NULL),(2,'Augeas tool','Create a blog post to explain the usage of Augeas for puppet.\r\n\r\nFocus on debugging using augtool.\r\n\r\nInclude silent failures.\r\n\r\nExplanation of lenses.',1445548655,NULL,0,'yellow',1,1,1,2,0,1,0,1,1445548655,'',NULL,0,0,0,1445548655,0,0,0,0,0,NULL,NULL),(3,'Domain name setup','Get my domain name(s) working with the internal sky router and a VM.',1446045812,NULL,0,'yellow',1,1,1,3,0,1,0,1,1446045812,'',NULL,0,0,0,1446045812,0,0,0,0,0,NULL,NULL),(4,'NRE LDB Creds','Get National Rail Enquiries credentials for the live depature boards service.\r\n\r\nhttps://lite.realtime.nationalrail.co.uk/OpenLDBWS/',1448832616,NULL,0,'yellow',2,7,1,1,0,1,0,1,1448832616,'',NULL,0,0,0,1448832616,0,0,0,0,0,NULL,NULL),(5,'Download WSDL files','Download the web service description language (WSDL) files from the nation rail enquiries web site.',1448835093,NULL,0,'yellow',2,7,1,2,0,1,0,1,1448835093,'',NULL,0,0,0,1448835093,0,0,0,0,0,NULL,NULL);
/*!40000 ALTER TABLE `tasks` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `transitions`
--

DROP TABLE IF EXISTS `transitions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `transitions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `project_id` int(11) NOT NULL,
  `task_id` int(11) NOT NULL,
  `src_column_id` int(11) NOT NULL,
  `dst_column_id` int(11) NOT NULL,
  `date` bigint(20) DEFAULT NULL,
  `time_spent` int(11) DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `src_column_id` (`src_column_id`),
  KEY `dst_column_id` (`dst_column_id`),
  KEY `transitions_task_index` (`task_id`),
  KEY `transitions_project_index` (`project_id`),
  KEY `transitions_user_index` (`user_id`),
  CONSTRAINT `transitions_ibfk_1` FOREIGN KEY (`src_column_id`) REFERENCES `columns` (`id`) ON DELETE CASCADE,
  CONSTRAINT `transitions_ibfk_2` FOREIGN KEY (`dst_column_id`) REFERENCES `columns` (`id`) ON DELETE CASCADE,
  CONSTRAINT `transitions_ibfk_3` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  CONSTRAINT `transitions_ibfk_4` FOREIGN KEY (`project_id`) REFERENCES `projects` (`id`) ON DELETE CASCADE,
  CONSTRAINT `transitions_ibfk_5` FOREIGN KEY (`task_id`) REFERENCES `tasks` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `transitions`
--

LOCK TABLES `transitions` WRITE;
/*!40000 ALTER TABLE `transitions` DISABLE KEYS */;
/*!40000 ALTER TABLE `transitions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user_has_notification_types`
--

DROP TABLE IF EXISTS `user_has_notification_types`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_has_notification_types` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `notification_type` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_has_notification_types_user_idx` (`user_id`,`notification_type`),
  CONSTRAINT `user_has_notification_types_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user_has_notification_types`
--

LOCK TABLES `user_has_notification_types` WRITE;
/*!40000 ALTER TABLE `user_has_notification_types` DISABLE KEYS */;
/*!40000 ALTER TABLE `user_has_notification_types` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user_has_notifications`
--

DROP TABLE IF EXISTS `user_has_notifications`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_has_notifications` (
  `user_id` int(11) NOT NULL,
  `project_id` int(11) NOT NULL,
  UNIQUE KEY `project_id` (`project_id`,`user_id`),
  KEY `user_id` (`user_id`),
  CONSTRAINT `user_has_notifications_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  CONSTRAINT `user_has_notifications_ibfk_2` FOREIGN KEY (`project_id`) REFERENCES `projects` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user_has_notifications`
--

LOCK TABLES `user_has_notifications` WRITE;
/*!40000 ALTER TABLE `user_has_notifications` DISABLE KEYS */;
/*!40000 ALTER TABLE `user_has_notifications` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user_has_unread_notifications`
--

DROP TABLE IF EXISTS `user_has_unread_notifications`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_has_unread_notifications` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `date_creation` bigint(20) NOT NULL,
  `event_name` varchar(50) NOT NULL,
  `event_data` text NOT NULL,
  PRIMARY KEY (`id`),
  KEY `user_id` (`user_id`),
  CONSTRAINT `user_has_unread_notifications_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user_has_unread_notifications`
--

LOCK TABLES `user_has_unread_notifications` WRITE;
/*!40000 ALTER TABLE `user_has_unread_notifications` DISABLE KEYS */;
/*!40000 ALTER TABLE `user_has_unread_notifications` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `users` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `username` varchar(50) NOT NULL,
  `password` varchar(255) DEFAULT NULL,
  `is_admin` tinyint(4) DEFAULT '0',
  `is_ldap_user` tinyint(1) DEFAULT '0',
  `name` varchar(255) DEFAULT NULL,
  `email` varchar(255) DEFAULT NULL,
  `google_id` varchar(30) DEFAULT NULL,
  `github_id` varchar(30) DEFAULT NULL,
  `notifications_enabled` tinyint(1) DEFAULT '0',
  `timezone` varchar(50) DEFAULT NULL,
  `language` char(5) DEFAULT NULL,
  `disable_login_form` tinyint(1) DEFAULT '0',
  `twofactor_activated` tinyint(1) DEFAULT '0',
  `twofactor_secret` char(16) DEFAULT NULL,
  `token` varchar(255) DEFAULT '',
  `notifications_filter` int(11) DEFAULT '4',
  `nb_failed_login` int(11) DEFAULT '0',
  `lock_expiration_date` bigint(20) DEFAULT NULL,
  `is_project_admin` int(11) DEFAULT '0',
  `gitlab_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `users_username_idx` (`username`),
  KEY `users_admin_idx` (`is_admin`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES (1,'admin','$2a$10$KZgszX3ElTGzk8SP2smKoujkw6bhdKglxgqbs50DF/zBCXgRf0qv2',1,0,NULL,NULL,NULL,NULL,0,NULL,NULL,0,0,NULL,'',4,0,0,0,NULL);
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2015-11-29 22:11:42
