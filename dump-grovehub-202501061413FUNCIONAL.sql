-- MySQL dump 10.13  Distrib 8.0.19, for Win64 (x86_64)
--
-- Host: localhost    Database: grovehub
-- ------------------------------------------------------
-- Server version	5.5.5-10.4.32-MariaDB

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `album_genres`
--

DROP TABLE IF EXISTS `album_genres`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `album_genres` (
  `album_id` varchar(36) NOT NULL,
  `genre_id` int(11) NOT NULL,
  PRIMARY KEY (`album_id`,`genre_id`),
  KEY `genre_id` (`genre_id`),
  CONSTRAINT `album_genres_ibfk_1` FOREIGN KEY (`album_id`) REFERENCES `albums` (`id`) ON DELETE CASCADE,
  CONSTRAINT `album_genres_ibfk_2` FOREIGN KEY (`genre_id`) REFERENCES `genres` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `album_genres`
--

LOCK TABLES `album_genres` WRITE;
/*!40000 ALTER TABLE `album_genres` DISABLE KEYS */;
/*!40000 ALTER TABLE `album_genres` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `albums`
--

DROP TABLE IF EXISTS `albums`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `albums` (
  `id` varchar(36) NOT NULL,
  `artist_id` varchar(36) NOT NULL,
  `title` varchar(255) NOT NULL,
  `description` text DEFAULT NULL,
  `cover_art_url` varchar(512) DEFAULT NULL,
  `release_date` date DEFAULT NULL,
  `type` enum('album','ep','single','demo') NOT NULL,
  `price` decimal(10,2) DEFAULT NULL,
  `status` enum('draft','published','archived') DEFAULT 'draft',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `artist_id` (`artist_id`),
  CONSTRAINT `albums_ibfk_1` FOREIGN KEY (`artist_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `albums`
--

LOCK TABLES `albums` WRITE;
/*!40000 ALTER TABLE `albums` DISABLE KEYS */;
/*!40000 ALTER TABLE `albums` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `analytics`
--

DROP TABLE IF EXISTS `analytics`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `analytics` (
  `id` varchar(36) NOT NULL,
  `entity_type` enum('song','album','artist','playlist') NOT NULL,
  `entity_id` varchar(36) NOT NULL,
  `metric_type` varchar(50) NOT NULL,
  `value` int(11) NOT NULL,
  `date` date NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `idx_analytics_entity` (`entity_type`,`entity_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `analytics`
--

LOCK TABLES `analytics` WRITE;
/*!40000 ALTER TABLE `analytics` DISABLE KEYS */;
/*!40000 ALTER TABLE `analytics` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `artist_payments`
--

DROP TABLE IF EXISTS `artist_payments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `artist_payments` (
  `id` varchar(36) NOT NULL,
  `artist_id` varchar(36) NOT NULL,
  `amount` decimal(10,2) NOT NULL,
  `period_start` date NOT NULL,
  `period_end` date NOT NULL,
  `status` enum('pending','processed','paid') NOT NULL,
  `payment_method` varchar(50) DEFAULT NULL,
  `transaction_id` varchar(255) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `artist_id` (`artist_id`),
  CONSTRAINT `artist_payments_ibfk_1` FOREIGN KEY (`artist_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `artist_payments`
--

LOCK TABLES `artist_payments` WRITE;
/*!40000 ALTER TABLE `artist_payments` DISABLE KEYS */;
/*!40000 ALTER TABLE `artist_payments` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `comments`
--

DROP TABLE IF EXISTS `comments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `comments` (
  `id` varchar(36) NOT NULL,
  `user_id` varchar(36) NOT NULL,
  `post_id` varchar(36) DEFAULT NULL,
  `song_id` varchar(36) DEFAULT NULL,
  `album_id` varchar(36) DEFAULT NULL,
  `content` text NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `user_id` (`user_id`),
  KEY `song_id` (`song_id`),
  KEY `album_id` (`album_id`),
  KEY `post_id` (`post_id`),
  CONSTRAINT `comments_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  CONSTRAINT `comments_ibfk_2` FOREIGN KEY (`song_id`) REFERENCES `songs` (`id`) ON DELETE CASCADE,
  CONSTRAINT `comments_ibfk_3` FOREIGN KEY (`album_id`) REFERENCES `albums` (`id`) ON DELETE CASCADE,
  CONSTRAINT `comments_ibfk_4` FOREIGN KEY (`post_id`) REFERENCES `posts` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `comments`
--

LOCK TABLES `comments` WRITE;
/*!40000 ALTER TABLE `comments` DISABLE KEYS */;
INSERT INTO `comments` VALUES ('2dc1555c-1375-4cb1-86b4-c2a211160113','05ebc6a0-777e-4eb0-bd1e-0def22dfc9b1','5cf5667a-230c-41e6-97eb-9f54b5943e98',NULL,NULL,'interesante ','2025-01-06 16:40:50','2025-01-06 16:40:50'),('b92f9bbd-c973-4b7c-9b04-30d8a905d20c','f2f7a194-d799-42a2-a449-59e7e613aa48','72da68bb-59d1-4972-9086-577ba37c962d',NULL,NULL,'me gustaria participar tambien en tu proyecto ','2025-01-04 21:09:29','2025-01-04 21:09:29'),('d9fb914d-8f34-4bd9-9598-b148d58defba','fb7e6fd9-9058-41e3-a537-7fecba436dd5','72da68bb-59d1-4972-9086-577ba37c962d',NULL,NULL,'claro dejame datos de contacto ','2025-01-04 21:07:08','2025-01-04 21:07:08');
/*!40000 ALTER TABLE `comments` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `genres`
--

DROP TABLE IF EXISTS `genres`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `genres` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  `description` text DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `genres`
--

LOCK TABLES `genres` WRITE;
/*!40000 ALTER TABLE `genres` DISABLE KEYS */;
INSERT INTO `genres` VALUES (1,'Rock','Género musical caracterizado por el uso de guitarras eléctricas','2024-12-31 17:12:02'),(2,'Pop','Música popular contemporánea','2024-12-31 17:12:02'),(3,'Hip Hop','Género musical que incorpora rap, DJing y producción de beats','2024-12-31 17:12:02'),(4,'Jazz','Género musical caracterizado por la improvisación','2024-12-31 17:12:02'),(5,'Electronic','Música producida principalmente con instrumentos electrónicos','2024-12-31 17:12:02');
/*!40000 ALTER TABLE `genres` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `licenses`
--

DROP TABLE IF EXISTS `licenses`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `licenses` (
  `id` varchar(36) NOT NULL,
  `name` varchar(255) NOT NULL,
  `description` text NOT NULL,
  `price` decimal(10,2) NOT NULL,
  `rights_description` text NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `licenses`
--

LOCK TABLES `licenses` WRITE;
/*!40000 ALTER TABLE `licenses` DISABLE KEYS */;
INSERT INTO `licenses` VALUES ('5a8c34cb-c79a-11ef-81c6-3c7c3f1535fc','Básica','Licencia para uso personal',9.99,'Solo uso personal, sin derechos comerciales','2024-12-31 17:12:02'),('5a8c4cff-c79a-11ef-81c6-3c7c3f1535fc','Comercial','Licencia para uso comercial',49.99,'Uso comercial permitido, sin exclusividad','2024-12-31 17:12:02'),('5a8c4dee-c79a-11ef-81c6-3c7c3f1535fc','Exclusiva','Licencia exclusiva',499.99,'Derechos exclusivos de uso comercial','2024-12-31 17:12:02');
/*!40000 ALTER TABLE `licenses` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `likes`
--

DROP TABLE IF EXISTS `likes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `likes` (
  `id` varchar(36) NOT NULL,
  `user_id` varchar(36) NOT NULL,
  `post_id` varchar(36) DEFAULT NULL,
  `comment_id` varchar(36) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_like` (`user_id`,`post_id`,`comment_id`),
  KEY `post_id` (`post_id`),
  KEY `comment_id` (`comment_id`),
  CONSTRAINT `likes_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  CONSTRAINT `likes_ibfk_2` FOREIGN KEY (`post_id`) REFERENCES `posts` (`id`) ON DELETE CASCADE,
  CONSTRAINT `likes_ibfk_3` FOREIGN KEY (`comment_id`) REFERENCES `comments` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `likes`
--

LOCK TABLES `likes` WRITE;
/*!40000 ALTER TABLE `likes` DISABLE KEYS */;
INSERT INTO `likes` VALUES ('36221987-c6b3-4158-ab6b-68875850bc9f','f2f7a194-d799-42a2-a449-59e7e613aa48','72da68bb-59d1-4972-9086-577ba37c962d',NULL,'2025-01-04 21:09:49'),('7124c6a9-6cb4-46cc-af06-681dfa445c0e','05ebc6a0-777e-4eb0-bd1e-0def22dfc9b1','72da68bb-59d1-4972-9086-577ba37c962d',NULL,'2025-01-06 16:40:59');
/*!40000 ALTER TABLE `likes` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `notifications`
--

DROP TABLE IF EXISTS `notifications`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `notifications` (
  `id` varchar(36) NOT NULL,
  `user_id` varchar(36) NOT NULL,
  `type` varchar(50) NOT NULL,
  `title` varchar(255) NOT NULL,
  `message` text NOT NULL,
  `read` tinyint(1) DEFAULT 0,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `idx_notifications_user` (`user_id`),
  CONSTRAINT `notifications_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `notifications`
--

LOCK TABLES `notifications` WRITE;
/*!40000 ALTER TABLE `notifications` DISABLE KEYS */;
/*!40000 ALTER TABLE `notifications` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `play_statistics`
--

DROP TABLE IF EXISTS `play_statistics`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `play_statistics` (
  `id` varchar(36) NOT NULL,
  `song_id` varchar(36) NOT NULL,
  `user_id` varchar(36) DEFAULT NULL,
  `ip_address` varchar(45) DEFAULT NULL,
  `country` varchar(2) DEFAULT NULL,
  `device_type` varchar(50) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `user_id` (`user_id`),
  KEY `idx_play_stats_song` (`song_id`),
  CONSTRAINT `play_statistics_ibfk_1` FOREIGN KEY (`song_id`) REFERENCES `songs` (`id`) ON DELETE CASCADE,
  CONSTRAINT `play_statistics_ibfk_2` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `play_statistics`
--

LOCK TABLES `play_statistics` WRITE;
/*!40000 ALTER TABLE `play_statistics` DISABLE KEYS */;
/*!40000 ALTER TABLE `play_statistics` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `playlist_songs`
--

DROP TABLE IF EXISTS `playlist_songs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `playlist_songs` (
  `playlist_id` varchar(36) NOT NULL,
  `song_id` varchar(36) NOT NULL,
  `position` int(11) NOT NULL,
  `added_at` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`playlist_id`,`song_id`),
  KEY `song_id` (`song_id`),
  CONSTRAINT `playlist_songs_ibfk_1` FOREIGN KEY (`playlist_id`) REFERENCES `playlists` (`id`) ON DELETE CASCADE,
  CONSTRAINT `playlist_songs_ibfk_2` FOREIGN KEY (`song_id`) REFERENCES `songs` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `playlist_songs`
--

LOCK TABLES `playlist_songs` WRITE;
/*!40000 ALTER TABLE `playlist_songs` DISABLE KEYS */;
/*!40000 ALTER TABLE `playlist_songs` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `playlists`
--

DROP TABLE IF EXISTS `playlists`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `playlists` (
  `id` varchar(36) NOT NULL,
  `user_id` varchar(36) NOT NULL,
  `title` varchar(255) NOT NULL,
  `description` text DEFAULT NULL,
  `cover_art_url` varchar(512) DEFAULT NULL,
  `is_public` tinyint(1) DEFAULT 1,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `user_id` (`user_id`),
  CONSTRAINT `playlists_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `playlists`
--

LOCK TABLES `playlists` WRITE;
/*!40000 ALTER TABLE `playlists` DISABLE KEYS */;
/*!40000 ALTER TABLE `playlists` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `posts`
--

DROP TABLE IF EXISTS `posts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `posts` (
  `id` varchar(36) NOT NULL,
  `user_id` varchar(36) NOT NULL,
  `title` varchar(255) NOT NULL,
  `content` text NOT NULL,
  `status` enum('active','hidden','deleted') DEFAULT 'active',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `user_id` (`user_id`),
  CONSTRAINT `posts_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `posts`
--

LOCK TABLES `posts` WRITE;
/*!40000 ALTER TABLE `posts` DISABLE KEYS */;
INSERT INTO `posts` VALUES ('5cf5667a-230c-41e6-97eb-9f54b5943e98','5075bbad-8c35-4f42-baa6-3e35642ad9ea','Primer album en 2025','Compartir mi primer disco genero pop para este año se presentaran unaa demo el dia de hoy y ccada 20 de mes se subiran el resto hasta junio','active','2025-01-04 20:50:56','2025-01-04 20:52:11'),('72da68bb-59d1-4972-9086-577ba37c962d','5075bbad-8c35-4f42-baa6-3e35642ad9ea','Necesito alguien que pueda producir mi diso','Necisto alguien que producir mi nuevo remix tengo presencia en redes y puedo reomendar ','active','2025-01-03 23:06:54','2025-01-04 20:53:19');
/*!40000 ALTER TABLE `posts` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `roles`
--

DROP TABLE IF EXISTS `roles`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `roles` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(50) NOT NULL,
  `description` text DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `roles`
--

LOCK TABLES `roles` WRITE;
/*!40000 ALTER TABLE `roles` DISABLE KEYS */;
INSERT INTO `roles` VALUES (1,'admin','Administrador del sistema'),(2,'artist','Músico o banda'),(3,'listener','Usuario regular'),(4,'moderator','Moderador de contenido');
/*!40000 ALTER TABLE `roles` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sales`
--

DROP TABLE IF EXISTS `sales`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sales` (
  `id` varchar(36) NOT NULL,
  `buyer_id` varchar(36) NOT NULL,
  `song_id` varchar(36) DEFAULT NULL,
  `album_id` varchar(36) DEFAULT NULL,
  `license_id` varchar(36) DEFAULT NULL,
  `amount` decimal(10,2) NOT NULL,
  `commission_amount` decimal(10,2) NOT NULL,
  `artist_amount` decimal(10,2) NOT NULL,
  `transaction_id` varchar(255) DEFAULT NULL,
  `status` enum('pending','completed','failed','refunded') NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `song_id` (`song_id`),
  KEY `album_id` (`album_id`),
  KEY `license_id` (`license_id`),
  KEY `idx_sales_buyer` (`buyer_id`),
  CONSTRAINT `sales_ibfk_1` FOREIGN KEY (`buyer_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  CONSTRAINT `sales_ibfk_2` FOREIGN KEY (`song_id`) REFERENCES `songs` (`id`) ON DELETE SET NULL,
  CONSTRAINT `sales_ibfk_3` FOREIGN KEY (`album_id`) REFERENCES `albums` (`id`) ON DELETE SET NULL,
  CONSTRAINT `sales_ibfk_4` FOREIGN KEY (`license_id`) REFERENCES `licenses` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sales`
--

LOCK TABLES `sales` WRITE;
/*!40000 ALTER TABLE `sales` DISABLE KEYS */;
/*!40000 ALTER TABLE `sales` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `song_genres`
--

DROP TABLE IF EXISTS `song_genres`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `song_genres` (
  `song_id` varchar(36) NOT NULL,
  `genre_id` int(11) NOT NULL,
  PRIMARY KEY (`song_id`,`genre_id`),
  KEY `genre_id` (`genre_id`),
  CONSTRAINT `song_genres_ibfk_1` FOREIGN KEY (`song_id`) REFERENCES `songs` (`id`) ON DELETE CASCADE,
  CONSTRAINT `song_genres_ibfk_2` FOREIGN KEY (`genre_id`) REFERENCES `genres` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `song_genres`
--

LOCK TABLES `song_genres` WRITE;
/*!40000 ALTER TABLE `song_genres` DISABLE KEYS */;
/*!40000 ALTER TABLE `song_genres` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `songs`
--

DROP TABLE IF EXISTS `songs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `songs` (
  `id` varchar(36) NOT NULL,
  `album_id` varchar(36) DEFAULT NULL,
  `artist_id` varchar(36) NOT NULL,
  `title` varchar(255) DEFAULT NULL,
  `genre` varchar(100) DEFAULT NULL,
  `description` text DEFAULT NULL,
  `duration` int(11) DEFAULT NULL,
  `file_path` varchar(512) NOT NULL,
  `cover_art_url` varchar(512) DEFAULT NULL,
  `price` decimal(10,2) DEFAULT NULL,
  `lyrics` text DEFAULT NULL,
  `track_number` int(11) DEFAULT NULL,
  `plays_count` int(11) DEFAULT 0,
  `downloads_count` int(11) DEFAULT 0,
  `status` enum('draft','pending_info','published','archived') DEFAULT 'pending_info',
  `upload_date` timestamp NOT NULL DEFAULT current_timestamp(),
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `idx_songs_artist` (`artist_id`),
  KEY `idx_songs_album` (`album_id`),
  CONSTRAINT `songs_ibfk_1` FOREIGN KEY (`album_id`) REFERENCES `albums` (`id`) ON DELETE SET NULL,
  CONSTRAINT `songs_ibfk_2` FOREIGN KEY (`artist_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `songs`
--

LOCK TABLES `songs` WRITE;
/*!40000 ALTER TABLE `songs` DISABLE KEYS */;
INSERT INTO `songs` VALUES ('008ee0ae-29f1-4328-b3fe-c8c685f1116c',NULL,'5075bbad-8c35-4f42-baa6-3e35642ad9ea',NULL,NULL,NULL,NULL,'short-10-228139.mp3',NULL,NULL,NULL,NULL,0,0,'pending_info','2025-01-03 19:53:08','2025-01-03 19:53:08','2025-01-03 19:53:08'),('05f958c2-3dc2-474c-8b39-bc1e3e30627f',NULL,'5075bbad-8c35-4f42-baa6-3e35642ad9ea',NULL,NULL,NULL,NULL,'short-10-228139.mp3',NULL,NULL,NULL,NULL,0,0,'pending_info','2025-01-03 15:52:42','2025-01-03 15:52:42','2025-01-03 15:52:42'),('13fe7355-bf34-4f2b-bbfe-a7a1d150c459',NULL,'fb7e6fd9-9058-41e3-a537-7fecba436dd5','calvin harris','Pop','calvin harris pop summer style futurama anime',NULL,'calvin harris final.mp3','6779c9b452864.jpg',NULL,NULL,NULL,5,0,'published','2025-01-06 00:09:38','2025-01-06 00:09:38','2025-01-06 17:58:52'),('1a3a8942-65cb-4484-ac06-5bd030fd2c3e',NULL,'5075bbad-8c35-4f42-baa6-3e35642ad9ea',NULL,NULL,NULL,NULL,'93c4f2ddc25e52291f2c529c56b83636.mp3',NULL,NULL,NULL,NULL,0,0,'pending_info','2025-01-03 15:40:39','2025-01-03 15:40:39','2025-01-03 15:40:39'),('26cb4d4c-3e9e-4ede-8ea5-d35d9a5a2aa2',NULL,'5075bbad-8c35-4f42-baa6-3e35642ad9ea',NULL,NULL,NULL,NULL,'short-10-228139.mp3',NULL,NULL,NULL,NULL,0,0,'pending_info','2025-01-03 15:49:53','2025-01-03 15:49:53','2025-01-03 15:49:53'),('2777bdd6-235f-4c0f-b634-75714a18c635',NULL,'5075bbad-8c35-4f42-baa6-3e35642ad9ea',NULL,NULL,NULL,NULL,'25298cdfc08546a11203ab0075f43791.mp3',NULL,NULL,NULL,NULL,0,0,'pending_info','2025-01-03 15:43:28','2025-01-03 15:43:28','2025-01-03 15:43:28'),('648a2763-a467-4a29-8f52-7fd4637c9089',NULL,'5075bbad-8c35-4f42-baa6-3e35642ad9ea',NULL,NULL,NULL,NULL,'short-10-228139.mp3',NULL,NULL,NULL,NULL,0,0,'pending_info','2025-01-03 15:48:21','2025-01-03 15:48:21','2025-01-03 15:48:21'),('7b226d10-870d-41ac-915a-babf487f8cf5',NULL,'fb7e6fd9-9058-41e3-a537-7fecba436dd5',NULL,NULL,NULL,NULL,'limbo oficil.mp3',NULL,NULL,NULL,NULL,0,0,'pending_info','2025-01-06 00:06:47','2025-01-06 00:06:47','2025-01-06 00:06:47'),('8644c85d-5ec7-4a3d-a28a-5f1311a6fa40',NULL,'5075bbad-8c35-4f42-baa6-3e35642ad9ea',NULL,NULL,NULL,NULL,'9df61cc00c49d4090724ac22b22d5691.mp3',NULL,NULL,NULL,NULL,0,0,'pending_info','2025-01-03 15:42:35','2025-01-03 15:42:35','2025-01-03 15:42:35'),('87f8d944-08ec-4245-9bf5-40361baccd9a',NULL,'fb7e6fd9-9058-41e3-a537-7fecba436dd5',NULL,NULL,NULL,NULL,'paraelisa_e5026d654966142.wav',NULL,NULL,NULL,NULL,0,0,'pending_info','2025-01-04 22:28:33','2025-01-04 22:28:33','2025-01-04 22:28:33'),('9a975251-aa1b-4ea3-8cd5-e5d50dbf1a2e',NULL,'5075bbad-8c35-4f42-baa6-3e35642ad9ea',NULL,NULL,NULL,NULL,'split (1).wav',NULL,NULL,NULL,NULL,0,0,'pending_info','2025-01-03 16:02:35','2025-01-03 16:02:35','2025-01-03 16:02:35'),('a5b07e79-52e4-4996-9c73-99902c1c979f',NULL,'5075bbad-8c35-4f42-baa6-3e35642ad9ea',NULL,NULL,NULL,NULL,'short-10-228139.mp3',NULL,NULL,NULL,NULL,0,0,'pending_info','2025-01-03 19:45:14','2025-01-03 19:45:14','2025-01-03 19:45:14'),('aa00bb2b-35c3-43fa-ad4c-1ae982ba5a63',NULL,'fb7e6fd9-9058-41e3-a537-7fecba436dd5',NULL,NULL,NULL,NULL,'paraelisa_e5026d654966142.wav',NULL,NULL,NULL,NULL,0,0,'pending_info','2025-01-04 23:51:22','2025-01-04 23:51:22','2025-01-04 23:51:22'),('af17fb1d-f2c5-41f4-88d9-5837d2936c1f',NULL,'5075bbad-8c35-4f42-baa6-3e35642ad9ea',NULL,NULL,NULL,NULL,'short-10-228139.mp3',NULL,NULL,NULL,NULL,0,0,'pending_info','2025-01-03 15:56:07','2025-01-03 15:56:07','2025-01-03 15:56:07'),('b276ce77-fb0c-4416-9310-61a71eaeb692',NULL,'5075bbad-8c35-4f42-baa6-3e35642ad9ea',NULL,NULL,NULL,NULL,'paraelisa.mp3',NULL,NULL,NULL,NULL,0,0,'pending_info','2025-01-03 15:54:35','2025-01-03 15:54:35','2025-01-03 15:54:35'),('b89ed3ad-2e70-4a53-b2d5-7f337f69ff25',NULL,'fb7e6fd9-9058-41e3-a537-7fecba436dd5',NULL,NULL,NULL,NULL,'see you again.mp3',NULL,NULL,NULL,NULL,0,0,'pending_info','2025-01-05 23:52:54','2025-01-05 23:52:54','2025-01-05 23:52:54'),('bfe3f9ee-15ce-401c-bb90-825439d23784',NULL,'5075bbad-8c35-4f42-baa6-3e35642ad9ea',NULL,NULL,NULL,NULL,'short-10-228139.mp3',NULL,NULL,NULL,NULL,0,0,'pending_info','2025-01-03 19:47:37','2025-01-03 19:47:37','2025-01-03 19:47:37'),('c14aaf0d-561d-493a-be91-38fe36d3c24c',NULL,'5075bbad-8c35-4f42-baa6-3e35642ad9ea',NULL,NULL,NULL,NULL,'a0d7cbd5ea64c4a5d5966075c5b9502e.mp3',NULL,NULL,NULL,NULL,0,0,'pending_info','2025-01-03 15:42:09','2025-01-03 15:42:09','2025-01-03 15:42:09'),('cab02736-626b-414d-ae3f-d441ce401903',NULL,'5075bbad-8c35-4f42-baa6-3e35642ad9ea',NULL,NULL,NULL,NULL,'yt1s.com - Música De Fondo Para Videos Y Presentaciones Corporativas I Deeper por esoundtrax.mp3',NULL,NULL,NULL,NULL,0,0,'pending_info','2025-01-03 23:19:10','2025-01-03 23:19:10','2025-01-03 23:19:10'),('cac501d9-1463-4f8f-836d-301f51023bb1',NULL,'5075bbad-8c35-4f42-baa6-3e35642ad9ea',NULL,NULL,NULL,NULL,'yt1s.com - Música De Fondo Para Videos Y Presentaciones Corporativas I Deeper por esoundtrax.mp3',NULL,NULL,NULL,NULL,0,0,'pending_info','2025-01-03 15:53:02','2025-01-03 15:53:02','2025-01-03 15:53:02'),('d6354468-71df-40df-a51c-ec5bfeeafc3f',NULL,'5075bbad-8c35-4f42-baa6-3e35642ad9ea',NULL,NULL,NULL,NULL,'0c325a3f9d8316ad1a0a7033a0f995d3.mp3',NULL,NULL,NULL,NULL,0,0,'pending_info','2025-01-03 15:44:00','2025-01-03 15:44:00','2025-01-03 15:44:00'),('e3be6efc-2e7e-4a2b-94eb-09c6ff5a42b3',NULL,'5075bbad-8c35-4f42-baa6-3e35642ad9ea',NULL,NULL,NULL,NULL,'short-10-228139.mp3','6779ca756fd95.jpg',NULL,NULL,NULL,0,0,'pending_info','2025-01-03 15:52:32','2025-01-03 15:52:32','2025-01-05 00:19:33'),('f503e0f9-2efd-44fd-b872-c4fd3340ad4f',NULL,'5075bbad-8c35-4f42-baa6-3e35642ad9ea','remix full','',NULL,NULL,'paraelisa.mp3','677b1b8611030.jpg',NULL,NULL,NULL,3,0,'published','2025-01-03 15:15:12','2025-01-03 15:15:12','2025-01-06 16:52:26');
/*!40000 ALTER TABLE `songs` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tags`
--

DROP TABLE IF EXISTS `tags`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tags` (
  `id` varchar(36) NOT NULL,
  `name` varchar(50) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tags`
--

LOCK TABLES `tags` WRITE;
/*!40000 ALTER TABLE `tags` DISABLE KEYS */;
/*!40000 ALTER TABLE `tags` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `url_cloud`
--

DROP TABLE IF EXISTS `url_cloud`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `url_cloud` (
  `url` varchar(254) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `url_cloud`
--

LOCK TABLES `url_cloud` WRITE;
/*!40000 ALTER TABLE `url_cloud` DISABLE KEYS */;
INSERT INTO `url_cloud` VALUES ('hjlgezzxlmjhajywdxr3');
/*!40000 ALTER TABLE `url_cloud` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `users` (
  `id` varchar(36) NOT NULL,
  `username` varchar(255) NOT NULL,
  `email` varchar(255) NOT NULL,
  `password_hash` varchar(255) NOT NULL,
  `full_name` varchar(255) DEFAULT NULL,
  `artist_name` varchar(255) DEFAULT NULL,
  `bio` text DEFAULT NULL,
  `avatar_url` varchar(512) DEFAULT NULL,
  `banner_url` varchar(512) DEFAULT NULL,
  `website` varchar(255) DEFAULT NULL,
  `paypal_email` varchar(255) DEFAULT NULL,
  `stripe_account_id` varchar(255) DEFAULT NULL,
  `instagram_id` varchar(255) DEFAULT NULL,
  `verified_artist` tinyint(1) DEFAULT 0,
  `country` varchar(100) DEFAULT NULL,
  `role` enum('admin','artist','listener','moderator') NOT NULL DEFAULT 'listener',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `username` (`username`),
  UNIQUE KEY `email` (`email`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES ('05ebc6a0-777e-4eb0-bd1e-0def22dfc9b1','maxp28 ','guido.25@hotmail.com','$2y$10$J8FzXDTUyokBEYza0ErZXOJ7lFq.lY8jbsaRPxTaFubhBi1ebigAW','max power',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,'artist','2025-01-06 16:39:44','2025-01-06 16:39:44'),('5075bbad-8c35-4f42-baa6-3e35642ad9ea','guido','nuesvos@usuario.com','$2y$10$uwh8yoO8hsn/Kh7XBG6zCO2bkxVrkoMBFIYFu3jF9r3.fV8apDcvO','guido guti',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,'listener','2024-12-31 17:17:20','2025-01-04 20:49:45'),('86655643-fbe8-4786-a746-920eef6ebca9','guido25','guidoroberto.25@gmail.com','$2y$10$t8qVAeiDXiLFpGw1Vj0R1Oqxe2.c.5Qp8d4wtuJhtUD6xHBWGVVa2','gguido',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,'moderator','2025-01-04 16:59:46','2025-01-04 16:59:46'),('8748cbd4-2dcb-4f77-9838-73b58d646a8c','carlos','carlos@example.com','$2y$10$6KWreng0yFThFgCyH3T7Z.fPExsZ.MPeTxCDmL3SOu3yOY5ANFPUq','carlossa',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,'listener','2025-01-04 20:44:04','2025-01-04 20:44:04'),('99c86ecb-54d5-4d96-988f-63325d9838eb','admin1','nuevos@usuario.com','$2y$10$1C02R5kdUVVrM4gw8SqCzeFjPARt6IW/coWZp3KR0mGDJmoxXkX5q','guido guti',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,'admin','2024-12-31 17:16:50','2025-01-04 17:52:10'),('f2f7a194-d799-42a2-a449-59e7e613aa48','doge','doge@example.com','$2y$10$yZPXsgZUldrnwj3BepByTO9xxpUgK1msPbyvJZI8U01zThpxJMBZ.','dogeoin ',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,'listener','2025-01-04 20:42:26','2025-01-04 20:42:26'),('f4845640-373c-4554-8882-264e7f550dc0','clouddogeuser','guido@example.com','$2y$10$f00P6NxBku2wh.2bd//Qo.LbxMcwmgipzlEDhwE2kd2cjTyQhaf8C','max power',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,'listener','2025-01-04 20:38:28','2025-01-04 20:38:28'),('fb7e6fd9-9058-41e3-a537-7fecba436dd5','marias2','maria@example.com','$2y$10$zu5R6XLzR4fF2U29Vs5XLO8.XmsQeu/HTP/lq3j/FXFINUDPM2vCO','maria serrano',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,2,NULL,'artist','2025-01-04 20:45:30','2025-01-06 14:27:12');
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping routines for database 'grovehub'
--
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2025-01-06 14:13:04
