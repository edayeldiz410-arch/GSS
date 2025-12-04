-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Hôte : 127.0.0.1:3306
-- Généré le : mer. 03 sep. 2025 à 08:50
-- Version du serveur : 9.1.0
-- Version de PHP : 8.3.14

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de données : `school`
--

-- --------------------------------------------------------

--
-- Structure de la table `article`
--

DROP TABLE IF EXISTS `article`;
CREATE TABLE IF NOT EXISTS `article` (
  `id` int NOT NULL AUTO_INCREMENT,
  `categorie_id` int DEFAULT NULL,
  `code` varchar(100) DEFAULT NULL,
  `designation` varchar(255) NOT NULL,
  `description` text,
  `unite` varchar(50) DEFAULT 'pcs',
  `prix_achat` decimal(12,2) DEFAULT '0.00',
  `prix_vente` decimal(12,2) DEFAULT '0.00',
  `stock_min` int DEFAULT '0',
  `actif` tinyint(1) DEFAULT '1',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `code` (`code`),
  KEY `categorie_id` (`categorie_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Structure de la table `auth_group`
--

DROP TABLE IF EXISTS `auth_group`;
CREATE TABLE IF NOT EXISTS `auth_group` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(150) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Structure de la table `auth_group_permissions`
--

DROP TABLE IF EXISTS `auth_group_permissions`;
CREATE TABLE IF NOT EXISTS `auth_group_permissions` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `group_id` int NOT NULL,
  `permission_id` int NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `auth_group_permissions_group_id_permission_id_0cd325b0_uniq` (`group_id`,`permission_id`),
  KEY `auth_group_permissions_group_id_b120cbf9` (`group_id`),
  KEY `auth_group_permissions_permission_id_84c5c92e` (`permission_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Structure de la table `auth_permission`
--

DROP TABLE IF EXISTS `auth_permission`;
CREATE TABLE IF NOT EXISTS `auth_permission` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `content_type_id` int NOT NULL,
  `codename` varchar(100) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `auth_permission_content_type_id_codename_01ab375a_uniq` (`content_type_id`,`codename`),
  KEY `auth_permission_content_type_id_2f476e4b` (`content_type_id`)
) ENGINE=MyISAM AUTO_INCREMENT=89 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Déchargement des données de la table `auth_permission`
--

INSERT INTO `auth_permission` (`id`, `name`, `content_type_id`, `codename`) VALUES
(1, 'Can add log entry', 1, 'add_logentry'),
(2, 'Can change log entry', 1, 'change_logentry'),
(3, 'Can delete log entry', 1, 'delete_logentry'),
(4, 'Can view log entry', 1, 'view_logentry'),
(5, 'Can add permission', 2, 'add_permission'),
(6, 'Can change permission', 2, 'change_permission'),
(7, 'Can delete permission', 2, 'delete_permission'),
(8, 'Can view permission', 2, 'view_permission'),
(9, 'Can add group', 3, 'add_group'),
(10, 'Can change group', 3, 'change_group'),
(11, 'Can delete group', 3, 'delete_group'),
(12, 'Can view group', 3, 'view_group'),
(13, 'Can add user', 4, 'add_user'),
(14, 'Can change user', 4, 'change_user'),
(15, 'Can delete user', 4, 'delete_user'),
(16, 'Can view user', 4, 'view_user'),
(17, 'Can add content type', 5, 'add_contenttype'),
(18, 'Can change content type', 5, 'change_contenttype'),
(19, 'Can delete content type', 5, 'delete_contenttype'),
(20, 'Can view content type', 5, 'view_contenttype'),
(21, 'Can add session', 6, 'add_session'),
(22, 'Can change session', 6, 'change_session'),
(23, 'Can delete session', 6, 'delete_session'),
(24, 'Can view session', 6, 'view_session'),
(25, 'Can add etudiant', 7, 'add_etudiant'),
(26, 'Can change etudiant', 7, 'change_etudiant'),
(27, 'Can delete etudiant', 7, 'delete_etudiant'),
(28, 'Can view etudiant', 7, 'view_etudiant'),
(29, 'Can add availability formateur', 8, 'add_availabilityformateur'),
(30, 'Can change availability formateur', 8, 'change_availabilityformateur'),
(31, 'Can delete availability formateur', 8, 'delete_availabilityformateur'),
(32, 'Can view availability formateur', 8, 'view_availabilityformateur'),
(33, 'Can add bank reconciliation', 9, 'add_bankreconciliation'),
(34, 'Can change bank reconciliation', 9, 'change_bankreconciliation'),
(35, 'Can delete bank reconciliation', 9, 'delete_bankreconciliation'),
(36, 'Can view bank reconciliation', 9, 'view_bankreconciliation'),
(37, 'Can add calendar event', 10, 'add_calendarevent'),
(38, 'Can change calendar event', 10, 'change_calendarevent'),
(39, 'Can delete calendar event', 10, 'delete_calendarevent'),
(40, 'Can view calendar event', 10, 'view_calendarevent'),
(41, 'Can add certification', 11, 'add_certification'),
(42, 'Can change certification', 11, 'change_certification'),
(43, 'Can delete certification', 11, 'delete_certification'),
(44, 'Can view certification', 11, 'view_certification'),
(45, 'Can add formation', 12, 'add_formation'),
(46, 'Can change formation', 12, 'change_formation'),
(47, 'Can delete formation', 12, 'delete_formation'),
(48, 'Can view formation', 12, 'view_formation'),
(49, 'Can add inscription', 13, 'add_inscription'),
(50, 'Can change inscription', 13, 'change_inscription'),
(51, 'Can delete inscription', 13, 'delete_inscription'),
(52, 'Can view inscription', 13, 'view_inscription'),
(53, 'Can add invoice', 14, 'add_invoice'),
(54, 'Can change invoice', 14, 'change_invoice'),
(55, 'Can delete invoice', 14, 'delete_invoice'),
(56, 'Can view invoice', 14, 'view_invoice'),
(57, 'Can add module', 15, 'add_module'),
(58, 'Can change module', 15, 'change_module'),
(59, 'Can delete module', 15, 'delete_module'),
(60, 'Can view module', 15, 'view_module'),
(61, 'Can add paiement', 16, 'add_paiement'),
(62, 'Can change paiement', 16, 'change_paiement'),
(63, 'Can delete paiement', 16, 'delete_paiement'),
(64, 'Can view paiement', 16, 'view_paiement'),
(65, 'Can add payment plan', 17, 'add_paymentplan'),
(66, 'Can change payment plan', 17, 'change_paymentplan'),
(67, 'Can delete payment plan', 17, 'delete_paymentplan'),
(68, 'Can view payment plan', 17, 'view_paymentplan'),
(69, 'Can add progression module', 18, 'add_progressionmodule'),
(70, 'Can change progression module', 18, 'change_progressionmodule'),
(71, 'Can delete progression module', 18, 'delete_progressionmodule'),
(72, 'Can view progression module', 18, 'view_progressionmodule'),
(73, 'Can add salle', 19, 'add_salle'),
(74, 'Can change salle', 19, 'change_salle'),
(75, 'Can delete salle', 19, 'delete_salle'),
(76, 'Can view salle', 19, 'view_salle'),
(77, 'Can add session', 20, 'add_session'),
(78, 'Can change session', 20, 'change_session'),
(79, 'Can delete session', 20, 'delete_session'),
(80, 'Can view session', 20, 'view_session'),
(81, 'Can add support', 21, 'add_support'),
(82, 'Can change support', 21, 'change_support'),
(83, 'Can delete support', 21, 'delete_support'),
(84, 'Can view support', 21, 'view_support'),
(85, 'Can add utilisateur', 22, 'add_utilisateur'),
(86, 'Can change utilisateur', 22, 'change_utilisateur'),
(87, 'Can delete utilisateur', 22, 'delete_utilisateur'),
(88, 'Can view utilisateur', 22, 'view_utilisateur');

-- --------------------------------------------------------

--
-- Structure de la table `auth_user`
--

DROP TABLE IF EXISTS `auth_user`;
CREATE TABLE IF NOT EXISTS `auth_user` (
  `id` int NOT NULL AUTO_INCREMENT,
  `password` varchar(128) NOT NULL,
  `last_login` datetime(6) DEFAULT NULL,
  `is_superuser` tinyint(1) NOT NULL,
  `username` varchar(150) NOT NULL,
  `first_name` varchar(150) NOT NULL,
  `last_name` varchar(150) NOT NULL,
  `email` varchar(254) NOT NULL,
  `is_staff` tinyint(1) NOT NULL,
  `is_active` tinyint(1) NOT NULL,
  `date_joined` datetime(6) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `username` (`username`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Structure de la table `auth_user_groups`
--

DROP TABLE IF EXISTS `auth_user_groups`;
CREATE TABLE IF NOT EXISTS `auth_user_groups` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `group_id` int NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `auth_user_groups_user_id_group_id_94350c0c_uniq` (`user_id`,`group_id`),
  KEY `auth_user_groups_user_id_6a12ed8b` (`user_id`),
  KEY `auth_user_groups_group_id_97559544` (`group_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Structure de la table `auth_user_user_permissions`
--

DROP TABLE IF EXISTS `auth_user_user_permissions`;
CREATE TABLE IF NOT EXISTS `auth_user_user_permissions` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `permission_id` int NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `auth_user_user_permissions_user_id_permission_id_14a6b632_uniq` (`user_id`,`permission_id`),
  KEY `auth_user_user_permissions_user_id_a95ead1b` (`user_id`),
  KEY `auth_user_user_permissions_permission_id_1fbb5f2c` (`permission_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Structure de la table `availability_formateur`
--

DROP TABLE IF EXISTS `availability_formateur`;
CREATE TABLE IF NOT EXISTS `availability_formateur` (
  `id` int UNSIGNED NOT NULL AUTO_INCREMENT,
  `utilisateur_id` int UNSIGNED NOT NULL,
  `date` date DEFAULT NULL,
  `day_of_week` tinyint DEFAULT NULL,
  `start_time` time DEFAULT NULL,
  `end_time` time DEFAULT NULL,
  `note` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_avail_user` (`utilisateur_id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Déchargement des données de la table `availability_formateur`
--

INSERT INTO `availability_formateur` (`id`, `utilisateur_id`, `date`, `day_of_week`, `start_time`, `end_time`, `note`) VALUES
(1, 1, '2024-08-20', NULL, '09:00:00', '12:00:00', 'Disponible matinée'),
(2, 2, NULL, 2, '18:00:00', '20:00:00', 'Soirées (mardi)');

-- --------------------------------------------------------

--
-- Structure de la table `bank_reconciliation`
--

DROP TABLE IF EXISTS `bank_reconciliation`;
CREATE TABLE IF NOT EXISTS `bank_reconciliation` (
  `id` int UNSIGNED NOT NULL AUTO_INCREMENT,
  `paiement_id` int UNSIGNED DEFAULT NULL,
  `date_import` datetime DEFAULT NULL,
  `bank_ref` varchar(255) DEFAULT NULL,
  `amount` decimal(10,2) DEFAULT NULL,
  `matched` tinyint(1) DEFAULT '0',
  `notes` text,
  PRIMARY KEY (`id`),
  KEY `idx_bank_paiement` (`paiement_id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Déchargement des données de la table `bank_reconciliation`
--

INSERT INTO `bank_reconciliation` (`id`, `paiement_id`, `date_import`, `bank_ref`, `amount`, `matched`, `notes`) VALUES
(1, NULL, '2024-05-13 12:00:00', 'BANK-REF-001', 15000.00, 1, NULL);

-- --------------------------------------------------------

--
-- Structure de la table `calendar_event`
--

DROP TABLE IF EXISTS `calendar_event`;
CREATE TABLE IF NOT EXISTS `calendar_event` (
  `id` int UNSIGNED NOT NULL AUTO_INCREMENT,
  `titre` varchar(255) NOT NULL,
  `description` text,
  `start_datetime` datetime NOT NULL,
  `end_datetime` datetime DEFAULT NULL,
  `is_online` tinyint(1) DEFAULT '0',
  `salle_id` int UNSIGNED DEFAULT NULL,
  `formation_id` int UNSIGNED DEFAULT NULL,
  `session_id` int UNSIGNED DEFAULT NULL,
  `organisateur_id` int UNSIGNED DEFAULT NULL,
  `notifications_sent` tinyint(1) DEFAULT '0',
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_event_start` (`start_datetime`),
  KEY `idx_event_salle` (`salle_id`),
  KEY `idx_event_formation` (`formation_id`),
  KEY `fk_event_session` (`session_id`),
  KEY `fk_event_organisateur` (`organisateur_id`)
) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Déchargement des données de la table `calendar_event`
--

INSERT INTO `calendar_event` (`id`, `titre`, `description`, `start_datetime`, `end_datetime`, `is_online`, `salle_id`, `formation_id`, `session_id`, `organisateur_id`, `notifications_sent`, `created_at`) VALUES
(1, 'Examen Final Design', 'Examen de fin de module', '2024-09-05 09:00:00', '2024-09-05 12:00:00', 0, 1, NULL, NULL, 1, 0, '2025-08-15 15:24:23'),
(2, 'Webinaire Marketing', 'Webinaire SEO', '2024-10-10 18:00:00', '2024-10-10 19:30:00', 1, NULL, NULL, NULL, 2, 0, '2025-08-15 15:24:23'),
(8, 'FIBRE OPTIQUE ', NULL, '2025-08-17 09:00:00', '2025-08-17 10:00:00', 0, NULL, NULL, NULL, NULL, 0, NULL),
(9, 'rzezaz', NULL, '2025-08-17 07:00:00', '2025-08-17 08:00:00', 0, NULL, NULL, NULL, NULL, 0, NULL),
(11, 'fdsf', NULL, '2025-08-17 10:00:00', '2025-08-17 12:00:00', 0, NULL, NULL, NULL, NULL, 0, NULL),
(13, 'fdfss', NULL, '2025-08-20 10:00:00', '2025-08-20 08:00:00', 0, NULL, NULL, NULL, NULL, 0, NULL),
(14, 'z', NULL, '2025-08-23 07:00:00', '2025-08-23 08:00:00', 0, NULL, NULL, NULL, NULL, 0, NULL),
(16, 'Design Patterns', NULL, '2025-08-18 07:00:00', '2025-08-18 08:00:00', 0, NULL, NULL, NULL, NULL, 0, NULL),
(17, 'System Design', NULL, '2025-08-19 07:00:00', '2025-08-19 08:00:00', 0, NULL, NULL, NULL, NULL, 0, NULL),
(18, 'hh', NULL, '2025-08-17 07:00:00', '2025-08-17 08:00:00', 0, NULL, NULL, NULL, NULL, 0, NULL),
(19, 'GG', NULL, '2025-08-19 07:00:00', '2025-08-19 08:00:00', 0, NULL, NULL, NULL, NULL, 0, NULL),
(20, 'tgf', NULL, '2025-08-31 07:00:00', '2025-08-31 08:00:00', 0, NULL, NULL, NULL, NULL, 0, NULL);

-- --------------------------------------------------------

--
-- Structure de la table `categorie_article`
--

DROP TABLE IF EXISTS `categorie_article`;
CREATE TABLE IF NOT EXISTS `categorie_article` (
  `id` int NOT NULL AUTO_INCREMENT,
  `nom` varchar(150) NOT NULL,
  `description` text,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Structure de la table `certification`
--

DROP TABLE IF EXISTS `certification`;
CREATE TABLE IF NOT EXISTS `certification` (
  `id` int UNSIGNED NOT NULL AUTO_INCREMENT,
  `inscription_id` int UNSIGNED NOT NULL,
  `numero_certificat` varchar(100) DEFAULT NULL,
  `fichier_certificat` varchar(512) DEFAULT NULL,
  `date_delivrance` datetime DEFAULT NULL,
  `valide_jusqua` date DEFAULT NULL,
  `delivre_par` int UNSIGNED DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_cert_inscription` (`inscription_id`),
  KEY `idx_cert_delivre_par` (`delivre_par`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Structure de la table `commande_achat`
--

DROP TABLE IF EXISTS `commande_achat`;
CREATE TABLE IF NOT EXISTS `commande_achat` (
  `id` int NOT NULL AUTO_INCREMENT,
  `fournisseur_id` int NOT NULL,
  `reference` varchar(120) DEFAULT NULL,
  `date` date DEFAULT (curdate()),
  `statut` varchar(20) DEFAULT 'draft',
  `notes` text,
  `total_ht` decimal(12,2) DEFAULT '0.00',
  `total_ttc` decimal(12,2) DEFAULT '0.00',
  `devise` varchar(8) DEFAULT 'XAF',
  `cree_par_id` int UNSIGNED DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `fournisseur_id` (`fournisseur_id`),
  KEY `cree_par_id` (`cree_par_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Structure de la table `commande_achat_item`
--

DROP TABLE IF EXISTS `commande_achat_item`;
CREATE TABLE IF NOT EXISTS `commande_achat_item` (
  `id` int NOT NULL AUTO_INCREMENT,
  `commande_id` int NOT NULL,
  `article_id` int NOT NULL,
  `quantite` int DEFAULT '1',
  `prix_unitaire` decimal(12,2) NOT NULL,
  `total` decimal(12,2) GENERATED ALWAYS AS ((`quantite` * `prix_unitaire`)) STORED,
  PRIMARY KEY (`id`),
  KEY `commande_id` (`commande_id`),
  KEY `article_id` (`article_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Structure de la table `django_admin_log`
--

DROP TABLE IF EXISTS `django_admin_log`;
CREATE TABLE IF NOT EXISTS `django_admin_log` (
  `id` int NOT NULL AUTO_INCREMENT,
  `action_time` datetime(6) NOT NULL,
  `object_id` longtext,
  `object_repr` varchar(200) NOT NULL,
  `action_flag` smallint UNSIGNED NOT NULL,
  `change_message` longtext NOT NULL,
  `content_type_id` int DEFAULT NULL,
  `user_id` int NOT NULL,
  PRIMARY KEY (`id`),
  KEY `django_admin_log_content_type_id_c4bce8eb` (`content_type_id`),
  KEY `django_admin_log_user_id_c564eba6` (`user_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Structure de la table `django_content_type`
--

DROP TABLE IF EXISTS `django_content_type`;
CREATE TABLE IF NOT EXISTS `django_content_type` (
  `id` int NOT NULL AUTO_INCREMENT,
  `app_label` varchar(100) NOT NULL,
  `model` varchar(100) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `django_content_type_app_label_model_76bd3d3b_uniq` (`app_label`,`model`)
) ENGINE=MyISAM AUTO_INCREMENT=23 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Déchargement des données de la table `django_content_type`
--

INSERT INTO `django_content_type` (`id`, `app_label`, `model`) VALUES
(1, 'admin', 'logentry'),
(2, 'auth', 'permission'),
(3, 'auth', 'group'),
(4, 'auth', 'user'),
(5, 'contenttypes', 'contenttype'),
(6, 'sessions', 'session'),
(7, 'Schoolapp', 'etudiant'),
(8, 'Schoolapp', 'availabilityformateur'),
(9, 'Schoolapp', 'bankreconciliation'),
(10, 'Schoolapp', 'calendarevent'),
(11, 'Schoolapp', 'certification'),
(12, 'Schoolapp', 'formation'),
(13, 'Schoolapp', 'inscription'),
(14, 'Schoolapp', 'invoice'),
(15, 'Schoolapp', 'module'),
(16, 'Schoolapp', 'paiement'),
(17, 'Schoolapp', 'paymentplan'),
(18, 'Schoolapp', 'progressionmodule'),
(19, 'Schoolapp', 'salle'),
(20, 'Schoolapp', 'session'),
(21, 'Schoolapp', 'support'),
(22, 'Schoolapp', 'utilisateur');

-- --------------------------------------------------------

--
-- Structure de la table `django_migrations`
--

DROP TABLE IF EXISTS `django_migrations`;
CREATE TABLE IF NOT EXISTS `django_migrations` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `app` varchar(255) NOT NULL,
  `name` varchar(255) NOT NULL,
  `applied` datetime(6) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=22 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Déchargement des données de la table `django_migrations`
--

INSERT INTO `django_migrations` (`id`, `app`, `name`, `applied`) VALUES
(1, 'Schoolapp', '0001_initial', '2025-08-16 11:15:06.500200'),
(2, 'Schoolapp', '0002_availabilityformateur_bankreconciliation_and_more', '2025-08-16 11:17:03.099956'),
(3, 'contenttypes', '0001_initial', '2025-08-16 11:17:03.864699'),
(4, 'auth', '0001_initial', '2025-08-16 11:17:04.205040'),
(5, 'admin', '0001_initial', '2025-08-16 11:17:04.305181'),
(6, 'admin', '0002_logentry_remove_auto_add', '2025-08-16 11:17:04.311142'),
(7, 'admin', '0003_logentry_add_action_flag_choices', '2025-08-16 11:17:04.316931'),
(8, 'contenttypes', '0002_remove_content_type_name', '2025-08-16 11:17:04.381259'),
(9, 'auth', '0002_alter_permission_name_max_length', '2025-08-16 11:17:04.405489'),
(10, 'auth', '0003_alter_user_email_max_length', '2025-08-16 11:17:04.433561'),
(11, 'auth', '0004_alter_user_username_opts', '2025-08-16 11:17:04.440901'),
(12, 'auth', '0005_alter_user_last_login_null', '2025-08-16 11:17:04.468832'),
(13, 'auth', '0006_require_contenttypes_0002', '2025-08-16 11:17:04.469773'),
(14, 'auth', '0007_alter_validators_add_error_messages', '2025-08-16 11:17:04.477412'),
(15, 'auth', '0008_alter_user_username_max_length', '2025-08-16 11:17:04.501838'),
(16, 'auth', '0009_alter_user_last_name_max_length', '2025-08-16 11:17:04.527274'),
(17, 'auth', '0010_alter_group_name_max_length', '2025-08-16 11:17:04.581302'),
(18, 'auth', '0011_update_proxy_permissions', '2025-08-16 11:17:04.640278'),
(19, 'auth', '0012_alter_user_first_name_max_length', '2025-08-16 11:17:04.668803'),
(20, 'sessions', '0001_initial', '2025-08-16 11:17:04.695757'),
(21, 'Schoolapp', '0003_rename_formation_text', '2025-08-16 11:28:47.183258');

-- --------------------------------------------------------

--
-- Structure de la table `django_session`
--

DROP TABLE IF EXISTS `django_session`;
CREATE TABLE IF NOT EXISTS `django_session` (
  `session_key` varchar(40) NOT NULL,
  `session_data` longtext NOT NULL,
  `expire_date` datetime(6) NOT NULL,
  PRIMARY KEY (`session_key`),
  KEY `django_session_expire_date_a5c62663` (`expire_date`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Structure de la table `enseignant`
--

DROP TABLE IF EXISTS `enseignant`;
CREATE TABLE IF NOT EXISTS `enseignant` (
  `id` int UNSIGNED NOT NULL AUTO_INCREMENT,
  `matricule` varchar(64) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `nom` varchar(150) COLLATE utf8mb4_unicode_ci NOT NULL,
  `prenom` varchar(150) COLLATE utf8mb4_unicode_ci NOT NULL,
  `email` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `telephone` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `adresse` text COLLATE utf8mb4_unicode_ci,
  `date_naissance` date DEFAULT NULL,
  `sexe` enum('M','F','NB') COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `photo` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `specialite` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `bio` text COLLATE utf8mb4_unicode_ci,
  `date_embauche` date DEFAULT NULL,
  `salaire` decimal(12,2) DEFAULT '0.00',
  `statut` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT 'actif',
  `formation_id` int UNSIGNED DEFAULT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT '1',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `matricule` (`matricule`),
  KEY `formation_id` (`formation_id`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Déchargement des données de la table `enseignant`
--

INSERT INTO `enseignant` (`id`, `matricule`, `nom`, `prenom`, `email`, `telephone`, `adresse`, `date_naissance`, `sexe`, `photo`, `specialite`, `bio`, `date_embauche`, `salaire`, `statut`, `formation_id`, `is_active`, `created_at`, `updated_at`) VALUES
(1, 'ENS001', 'Bensaid', 'Karim', 'karim.bensaid@example.com', '+213555111222', 'Rue A, Alger', '1980-05-12', 'M', 'enseignants/5_H3_Ai_enhanced_2772e3ad7f_swuOy3U.webp', 'Marketing Digital', 'Expert en SEO et campagnes publicitaires en ligne.', '2020-09-01', 80000.00, 'actif', NULL, 1, '2025-08-18 08:35:17', '2025-08-18 08:34:07'),
(2, 'ENS002', 'Khelifi', 'Nadia', 'nadia.khelifi@example.com', '+213555222333', 'Rue B, Oran', '1985-11-23', 'F', 'enseignants/images (1).jfif', 'Informatique', 'Spécialiste en développement web et bases de données.', '2019-02-15', 95000.00, 'actif', 3, 1, '2025-08-18 08:35:17', '2025-08-18 06:48:40'),
(3, 'ENS003', 'Touati', 'Samir', 'samir.touati@example.com', '+213555444555', 'Rue C, Constantine', '1978-03-08', 'M', 'enseignants/5_H3_Ai_enhanced_2772e3ad7f_ltoHJtS.webp', 'Mathématiques Appliquées', 'Professeur de statistiques et analyse de données.', '2018-01-10', 70000.00, 'actif', 4, 1, '2025-08-18 08:35:17', '2025-08-18 06:51:02'),
(4, 'ENS004', 'Hachemi', 'Leila', 'leila.hachemi@example.com', '+213555666777', 'Rue D, Annaba', '1990-07-14', 'F', 'enseignants/images_izH7uJ6.jfif', 'Gestion & Finance', 'Formatrice en comptabilité et finance d’entreprise.', '2021-06-20', 72000.00, 'actif', 5, 1, '2025-08-18 08:35:17', '2025-08-18 06:48:30'),
(5, 'ENS005', 'MHTEKLEHRZ', 'Yassine', 'yassine.merzouki@example.com', '+213555888999', 'Rue E, Blida', '1987-09-30', 'M', 'enseignants/Anime-Profile-Picture-2.jpg', 'Design Web', 'Designer UI/UX et expert en prototypage.', '2022-03-05', 68000.00, 'actif', 6, 1, '2025-08-18 08:35:17', '2025-08-18 06:48:19'),
(7, NULL, 'zzzzzzzzz', 'eeeeeeeeee', 'fdfslkjsfd@gmail.com', '+213555666777', 'Boukhiama', NULL, NULL, 'enseignants/5fa500e772f3b355ebf94f09d32a6d62.jpg', NULL, NULL, NULL, 0.00, 'actif', NULL, 1, '2025-08-18 06:46:41', '2025-08-18 06:48:11'),
(8, NULL, 'mam', 'tokyo', 'tokyo@gmail.com', '021321333', 'SPAIN', NULL, NULL, 'enseignants/5fa500e772f3b355ebf94f09d32a6d62_KracAfy.jpg', NULL, NULL, NULL, 0.00, 'actif', NULL, 1, '2025-08-18 06:51:51', '2025-08-18 06:51:51'),
(9, NULL, 'bouchamaDS', 'HAMID', 'DSQSDS', '', 'Boukhiama', NULL, NULL, 'enseignants/xbox-series-x-3d-wallpaper_1920x1080.jpg', NULL, NULL, NULL, 0.00, 'actif', NULL, 1, '2025-08-22 19:24:59', '2025-09-01 10:02:47');

-- --------------------------------------------------------

--
-- Structure de la table `etudiant`
--

DROP TABLE IF EXISTS `etudiant`;
CREATE TABLE IF NOT EXISTS `etudiant` (
  `id` int UNSIGNED NOT NULL AUTO_INCREMENT,
  `nom` varchar(100) NOT NULL,
  `prenom` varchar(100) NOT NULL,
  `nom_arabe` varchar(100) DEFAULT NULL,
  `prenom_arabe` varchar(100) DEFAULT NULL,
  `sexe` varchar(10) DEFAULT NULL,
  `date_naissance` date DEFAULT NULL,
  `lieu_naissance` varchar(100) DEFAULT NULL,
  `nationalite` varchar(50) DEFAULT NULL,
  `nin` varchar(50) DEFAULT NULL,
  `adresse` text,
  `telephone` varchar(20) DEFAULT NULL,
  `mobile` varchar(20) DEFAULT NULL,
  `email` varchar(150) DEFAULT NULL,
  `rs` varchar(255) DEFAULT NULL,
  `niveau_etude` varchar(100) DEFAULT NULL,
  `dernier_diplome` varchar(100) DEFAULT NULL,
  `situation_professionnelle` varchar(100) DEFAULT NULL,
  `photo` varchar(255) DEFAULT NULL,
  `date_inscription` date DEFAULT NULL,
  `formation_id` int UNSIGNED DEFAULT NULL,
  `duree_formation` varchar(50) DEFAULT NULL,
  `salle` varchar(50) DEFAULT NULL,
  `statut` varchar(50) DEFAULT NULL,
  `remarques` text,
  `formation_text` varchar(255) DEFAULT NULL,
  `extrait_naissance_photo` varchar(255) DEFAULT NULL,
  `carte_identite_photo` varchar(255) DEFAULT NULL,
  `verification_step` int DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_nin` (`nin`),
  KEY `idx_etudiant_formation` (`formation_id`)
) ENGINE=InnoDB AUTO_INCREMENT=69 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Déchargement des données de la table `etudiant`
--

INSERT INTO `etudiant` (`id`, `nom`, `prenom`, `nom_arabe`, `prenom_arabe`, `sexe`, `date_naissance`, `lieu_naissance`, `nationalite`, `nin`, `adresse`, `telephone`, `mobile`, `email`, `rs`, `niveau_etude`, `dernier_diplome`, `situation_professionnelle`, `photo`, `date_inscription`, `formation_id`, `duree_formation`, `salle`, `statut`, `remarques`, `formation_text`, `extrait_naissance_photo`, `carte_identite_photo`, `verification_step`) VALUES
(1, 'HAMZA', 'riad', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '', '0555123456', NULL, 'h.hamza@example.com', NULL, 'universitaire', NULL, NULL, 'etudiants/images_HFIlp9s.jfif', '2024-05-10', NULL, NULL, NULL, 'inscrit', NULL, NULL, NULL, NULL, 0),
(2, 'MILANE', 'MOHAMED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '032414545', NULL, 'm.milane@example.com', NULL, NULL, NULL, NULL, 'etudiants/eaa52db1594c46408ffa6f47b99d4076_LGzKln4.webp', '2024-06-12', NULL, NULL, NULL, 'inscrit', NULL, NULL, NULL, NULL, 0),
(3, 'bouchama', 'HAMID', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '0555123456', NULL, 'rayneera654@gmail.com', NULL, 'universitaire', NULL, NULL, 'etudiants/images_GZTcPxT.jfif', NULL, NULL, NULL, NULL, 'inscrit', NULL, NULL, NULL, NULL, 0),
(17, 'Cherif', 'Leila', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Rue D, Annaba', '+213555333444', '+213661333444', 'leila.cherif@example.com', NULL, NULL, NULL, NULL, 'etudiants/surprised-jazz-hands-happy-asian-girl-smiling-looking-amazed-camera-announcing-smth-standing-white-background_1258-89582_IR1yMyX.jpg', '2025-03-10', NULL, NULL, NULL, 'non inscrit', NULL, NULL, NULL, NULL, 0),
(18, 'Djebali', 'Omar', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Rue E, Blida', '+213555555666', '+213661555666', 'omar.djebali@example.com', NULL, 'Terminal', NULL, NULL, 'etudiants/images.jfif', '2025-01-22', NULL, NULL, NULL, 'inscrit', NULL, NULL, NULL, NULL, 0),
(20, 'Amrani', 'Sofiane', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Rue G, Sétif', '+213555999000', '+213661999000', 'sofiane.amrani@example.com', NULL, NULL, NULL, NULL, 'etudiants/eaa52db1594c46408ffa6f47b99d4076.webp', '2025-03-12', NULL, NULL, NULL, 'non inscrit', NULL, NULL, NULL, NULL, 0),
(22, 'Belkacem', 'Rachid', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Rue I, Béjaïa', '+213555444555', '+213661444555', 'rachid.belkacem@example.com', NULL, NULL, NULL, NULL, 'etudiants/pedro-pascal-as-joel-miller-in-the-last-of-us-episode-9.webp', '2025-02-18', NULL, NULL, NULL, 'inscrit', NULL, NULL, NULL, NULL, 3),
(24, 'ZZZZZZZZZZ', 'ZZZZZZZZZZZ', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '08838222', NULL, 'garymartin1968@cholemail.com', NULL, NULL, NULL, NULL, 'etudiants/eaa52db1594c46408ffa6f47b99d4076_rjzk2l7.webp', NULL, 5, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0),
(25, 'BERBOUCHA', 'LYNA', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '0213214', NULL, 'lyna@gmail.com', NULL, NULL, NULL, NULL, 'etudiants/images_Gmmc5sO.jfif', NULL, 6, NULL, NULL, 'inscrit', NULL, NULL, NULL, NULL, 3),
(26, 'ggggggggg', 'azzzzzzzzzzzzz', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '068666666666', NULL, 'dqjf@gmail.com', NULL, NULL, NULL, NULL, 'etudiants/eaa52db1594c46408ffa6f47b99d4076_l5tDjzX.webp', NULL, 4, NULL, NULL, 'inscrit', NULL, NULL, NULL, NULL, 3),
(27, 'rrrrrrrrrrr', 'rrrrrrrr', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '05551234564', NULL, 'vadire37@gmail.com', NULL, NULL, NULL, NULL, 'etudiants/surprised-jazz-hands-happy-asian-girl-smiling-looking-amazed-camera-announcing-smth-standing-white-background_1258-89582_BQ7fv36.jpg', NULL, 5, NULL, NULL, 'inscrit', NULL, NULL, NULL, NULL, 3),
(28, 'KATARINA', 'NOXUS', NULL, NULL, 'homme', '2003-10-04', 'BEJAIA', 'ALGERIENNE', '167322424334', 'NOXUS,IONIA', '0643722444', NULL, 'KATA@GMAIL.com', NULL, 'TERMINAL', 'LICENSE', 'ETUDIANT', 'etudiants/5fa500e772f3b355ebf94f09d32a6d62.jpg', NULL, NULL, NULL, NULL, NULL, 'rien', NULL, NULL, NULL, 2),
(31, 'IRELIA', 'NOXUS', NULL, NULL, 'F', '2000-12-01', 'BEJAIA', 'ALGERIENNE', '163723844', 'ZAUN', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'etudiants/5_H3_Ai_enhanced_2772e3ad7f.webp', NULL, NULL, NULL, NULL, 'inscrit', NULL, NULL, NULL, NULL, 3),
(32, 'RIAD', 'MH', NULL, NULL, 'M', '2025-08-07', 'BEJAIA', 'ALGERIENNE', '39390234', 'PARIS', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'etudiants/Anime-Profile-Picture-2.jpg', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0),
(33, 'bouchama', 'HAMID', NULL, NULL, NULL, '2025-08-05', 'BEJAIA', NULL, NULL, 'Boukhiama', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'etudiants/cover-Cybersecurity-Budget-1.png', NULL, NULL, NULL, NULL, 'inscrit', 'ERRERE', NULL, NULL, NULL, 3),
(37, 'GAREN', 'DARIUS', NULL, NULL, NULL, '2025-08-13', 'BEJAIA', 'ALGERIENNE', NULL, 'Boukhiama', '0492344242', NULL, 'vadire7@gmail.com', NULL, NULL, NULL, NULL, 'etudiants/images (1)_Gdha3sI.jfif', NULL, NULL, NULL, NULL, 'inscrit', 'FSDSDF', NULL, NULL, NULL, 3),
(38, 'B', 'HAMID', NULL, NULL, NULL, '2025-08-09', 'BEJAIA', 'ALGERIENNE', NULL, 'Boukhiama', '0555123456', NULL, 'vadire73@gmail.com', NULL, NULL, NULL, NULL, 'etudiants/images (1)_0sWvkgD.jfif', NULL, NULL, NULL, NULL, 'inscrit', NULL, NULL, NULL, NULL, 1),
(39, 'BRIAREEZZ', 'HAMIDa', NULL, NULL, 'M', '2025-08-14', NULL, 'ALGERIENNE', NULL, 'Boukhiama', '+213555666777', NULL, '', NULL, NULL, NULL, NULL, 'etudiants/Anime-Profile-Picture-2_uYcslTr.jpg', NULL, NULL, NULL, NULL, 'inscrit', NULL, NULL, 'etudiants/39_extrait_Anime-Profile-Picture-2.jpg', 'etudiants/39_carte_FR-Daugherty-Digital-Technology-Business-1200x627-1200x627.jpg', 3),
(62, 'SDDS', 'Sds', NULL, NULL, NULL, '2003-10-04', 'FFDS', 'Albanais', '393902344424444444', NULL, '0555123456', NULL, '', NULL, NULL, NULL, NULL, 'etudiants/Capture_uBGXQtX.PNG', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1),
(63, 'HAMID', 'Salima', NULL, NULL, NULL, '2003-10-04', 'Amizour', 'Albanais', '393902344424443444', NULL, '0555123456', NULL, '', NULL, NULL, NULL, NULL, 'etudiants/wallpapersden_zUYkyLk.com_spirit-blossom-irelia-league-of-legends_1920x1080.jpg', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0),
(64, 'DSQDS', 'Sd', NULL, NULL, NULL, NULL, 'Amizour', 'Algérien', '393902344424444443', NULL, '0555123456', NULL, '', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0),
(65, 'HAMID', 'Salima', 'bouchama', NULL, NULL, NULL, 'Ferraoun', 'Albanais', '393902344424444446', NULL, '0555123456', NULL, '', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0),
(66, 'DXD', 'Dqdqsdqs', NULL, NULL, NULL, NULL, 'Amizour', 'Albanais', '393902344424444442', NULL, '0446783927', NULL, '', NULL, 'terminal', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0),
(67, 'HAMID', 'Hamid', 'bouchama', NULL, NULL, NULL, 'Ferraoun', 'Algérien', '393902344424444421', NULL, '055512345665656', NULL, '', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0),
(68, 'HAMID', 'Hamid', NULL, NULL, NULL, NULL, 'Ferraoun', 'Allemand', '393902344424444441', NULL, '05551234543', NULL, '', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0);

-- --------------------------------------------------------

--
-- Structure de la table `facture_fournisseur`
--

DROP TABLE IF EXISTS `facture_fournisseur`;
CREATE TABLE IF NOT EXISTS `facture_fournisseur` (
  `id` int NOT NULL AUTO_INCREMENT,
  `commande_id` int NOT NULL,
  `reference_facture` varchar(120) DEFAULT NULL,
  `date_facture` date DEFAULT (curdate()),
  `montant_total` decimal(12,2) NOT NULL,
  `statut` varchar(20) DEFAULT 'non_payee',
  `cree_par_id` int UNSIGNED DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `commande_id` (`commande_id`),
  KEY `cree_par_id` (`cree_par_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Structure de la table `formation`
--

DROP TABLE IF EXISTS `formation`;
CREATE TABLE IF NOT EXISTS `formation` (
  `id` int UNSIGNED NOT NULL AUTO_INCREMENT,
  `nom` varchar(150) NOT NULL,
  `description` text,
  `contenu` text,
  `photo` varchar(255) DEFAULT NULL,
  `prix_etudiant` decimal(10,2) DEFAULT NULL,
  `prix_fonctionnaire` decimal(10,2) DEFAULT NULL,
  `duree` varchar(50) DEFAULT NULL,
  `branche` varchar(100) DEFAULT NULL,
  `categorie` varchar(100) DEFAULT NULL,
  `niveau` varchar(50) DEFAULT NULL,
  `date_creation` datetime DEFAULT NULL,
  `statut` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Déchargement des données de la table `formation`
--

INSERT INTO `formation` (`id`, `nom`, `description`, `contenu`, `photo`, `prix_etudiant`, `prix_fonctionnaire`, `duree`, `branche`, `categorie`, `niveau`, `date_creation`, `statut`) VALUES
(3, 'Informatique', 'Développement web, backend et bases de données', NULL, 'formations/FR-Daugherty-Digital-Technology-Business-1200x627-1200x627.jpg', 500.00, 400.00, '3 mois', 'TI', 'Technique', 'Intermédiaire', '2025-01-10 00:00:00', 'active'),
(4, 'Mathématiques Appliquées', 'Analyse, statistiques et modélisation', NULL, 'formations/The-10-Biggest-Technology-Trends-That-Will-Transform-The-Next-Decade.jpg', 450.00, 360.00, '2 mois', 'Sciences', 'Technique', 'Débutant', '2025-02-01 00:00:00', 'active'),
(5, 'Gestion & Finance', 'Comptabilité, gestion financière et entreprise', NULL, 'formations/The-10-Biggest-Technology-Trends-That-Will-Transform-The-Next-Decade_y2OHtGZ.jpg', 600.00, 480.00, '4 mois', 'Management', 'Professionnel', 'Intermédiaire', '2025-03-05 00:00:00', 'active'),
(6, 'Design Web', 'UI/UX, HTML/CSS, prototypageDDD', NULL, 'formations/pngtree-admissions-training-course-flyer-picture-image_1052395_9HFhArE.jpg', 400.00, 320.00, '2 mois', 'Créatif', 'Technique', 'Débutant', '2025-01-20 00:00:00', 'active'),
(7, 'Marketing Digital', 'SEO, publicité en ligne, réseaux sociaux', NULL, 'formations/cover-Cybersecurity-Budget-1.png', 480.00, 384.00, '3 mois', 'Marketing', 'Professionnel', 'Intermédiaire', '2025-02-15 00:00:00', 'active'),
(8, 'Resauxxw', 'FIBRES', NULL, 'formations/FR-Daugherty-Digital-Technology-Business-1200x627-1200x627_RHEVjpP.jpg', 30000.00, 320.00, '60h', 'TI', 'Technique', 'Intermédiaire', NULL, 'active'),
(9, 'CYBERSECURITY', 'kali commands', NULL, 'formations/The-10-Biggest-Technology-Trends-That-Will-Transform-The-Next-Decade_uJmBLRH.jpg', 1000.00, 320.00, '3 mois', 'TI', 'Digital', 'Intermédiaire', NULL, 'active'),
(10, 'dfdfdf', 'FF', 'dfdf', 'formations/C.PNG', 600.00, 320.00, '2 mois', 'Marketing', 'Technique', 'Intermédiaire', NULL, 'active'),
(11, 'SOFTWARE TESTING', NULL, '-implementer les test D\'intégration \r\n-implementer les tests unitaire\r\n-ecrire les tests en langage curl\r\n-deployemenet aprés phase de test', 'formations/wallpapersden.com_spirit-blossom-irelia-league-of-legends_1920x1080.jpg', 600.00, 320.00, '2 mois', 'Marketing', 'Technique', 'Intermédiaire', NULL, 'active'),
(13, 'dxd', NULL, '', 'formations/Capture1_WYdVCAs.PNG', 32332.00, NULL, ' 6 MOIS', '', '', '', NULL, 'active');

-- --------------------------------------------------------

--
-- Structure de la table `fournisseur`
--

DROP TABLE IF EXISTS `fournisseur`;
CREATE TABLE IF NOT EXISTS `fournisseur` (
  `id` int NOT NULL AUTO_INCREMENT,
  `nom` varchar(200) NOT NULL,
  `code` varchar(50) DEFAULT NULL,
  `adresse` text,
  `email` varchar(254) DEFAULT NULL,
  `phone` varchar(40) DEFAULT NULL,
  `notes` text,
  `active` tinyint(1) DEFAULT '1',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `code` (`code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Structure de la table `inscription`
--

DROP TABLE IF EXISTS `inscription`;
CREATE TABLE IF NOT EXISTS `inscription` (
  `id` int UNSIGNED NOT NULL AUTO_INCREMENT,
  `etudiant_id` int UNSIGNED NOT NULL,
  `formation_id` int UNSIGNED NOT NULL,
  `date_inscription` datetime DEFAULT CURRENT_TIMESTAMP,
  `statut` varchar(50) DEFAULT 'inscrit',
  `progress_percent` decimal(5,2) DEFAULT '0.00',
  `prix_total` decimal(10,2) DEFAULT NULL,
  `remarques` text,
  `groupe` varchar(50) DEFAULT NULL,
  `session` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_inscription_etudiant_formation` (`etudiant_id`,`formation_id`),
  KEY `idx_inscription_etudiant` (`etudiant_id`),
  KEY `idx_inscription_formation` (`formation_id`)
) ENGINE=InnoDB AUTO_INCREMENT=24 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Déchargement des données de la table `inscription`
--

INSERT INTO `inscription` (`id`, `etudiant_id`, `formation_id`, `date_inscription`, `statut`, `progress_percent`, `prix_total`, `remarques`, `groupe`, `session`) VALUES
(6, 22, 4, '2025-08-16 20:33:46', 'inscrit', 0.00, NULL, NULL, NULL, NULL),
(10, 18, 3, '2025-08-17 19:20:05', 'inscrit', 0.00, NULL, 'groupe:G1', NULL, NULL),
(11, 25, 6, '2025-08-17 20:37:10', 'inscrit', 0.00, NULL, 'groupe:G2', NULL, NULL),
(12, 27, 4, '2025-08-17 20:42:31', 'inscrit', 0.00, NULL, 'groupe:G2', NULL, NULL),
(13, 2, 9, '2025-08-18 11:26:41', 'inscrit', 0.00, NULL, 'groupe:G2;formateur:3', NULL, NULL),
(14, 39, 4, '2025-08-20 08:59:23', 'inscrit', 0.00, NULL, 'groupe:G1', NULL, NULL),
(15, 1, 3, '2025-08-20 10:16:56', 'inscrit', 0.00, NULL, 'groupe:G1;formateur:3', NULL, NULL),
(16, 2, 4, '2025-08-22 19:35:40', 'inscrit', 0.00, NULL, 'groupe:G1;formateur:2', NULL, NULL),
(17, 3, 4, '2025-08-22 21:24:42', 'inscrit', 0.00, NULL, 'groupe:G1;formateur:1', NULL, NULL),
(18, 31, 3, '2025-08-22 21:51:35', 'inscrit', 0.00, NULL, 'groupe:G2', NULL, NULL),
(19, 37, 4, '2025-08-23 16:20:58', 'inscrit', 0.00, NULL, 'groupe:G1;formateur:1', NULL, NULL),
(20, 1, 4, '2025-08-23 16:59:36', 'inscrit', 0.00, NULL, 'groupe:GM1;formateur:5', 'GM1', 'session normale'),
(21, 26, 4, '2025-08-23 17:06:59', 'inscrit', 0.00, NULL, 'groupe:GM1;formateur:2', 'GM1', 'session normale'),
(22, 38, 4, '2025-08-23 17:59:35', 'inscrit', 0.00, NULL, 'groupe:GM1;formateur:3', 'GM1', 'session normale'),
(23, 33, 7, '2025-08-23 18:59:37', 'inscrit', 0.00, NULL, 'groupe:GM1;formateur:2', 'GM1', 'session normale');

-- --------------------------------------------------------

--
-- Structure de la table `invoice`
--

DROP TABLE IF EXISTS `invoice`;
CREATE TABLE IF NOT EXISTS `invoice` (
  `id` int UNSIGNED NOT NULL AUTO_INCREMENT,
  `inscription_id` int UNSIGNED DEFAULT NULL,
  `paiement_id` int UNSIGNED DEFAULT NULL,
  `numero` varchar(100) DEFAULT NULL,
  `montant` decimal(10,2) NOT NULL,
  `date_emission` datetime DEFAULT CURRENT_TIMESTAMP,
  `date_echeance` date DEFAULT NULL,
  `statut` varchar(50) DEFAULT 'emi',
  `remarques` text,
  PRIMARY KEY (`id`),
  KEY `idx_invoice_inscription` (`inscription_id`),
  KEY `idx_invoice_paiement` (`paiement_id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Déchargement des données de la table `invoice`
--

INSERT INTO `invoice` (`id`, `inscription_id`, `paiement_id`, `numero`, `montant`, `date_emission`, `date_echeance`, `statut`, `remarques`) VALUES
(1, NULL, NULL, 'INV-2024-0001', 25000.00, '2024-06-16 10:00:00', NULL, 'payée', NULL),
(2, NULL, NULL, 'INV-2024-0002', 15000.00, '2024-05-13 09:30:00', NULL, 'payée', NULL);

-- --------------------------------------------------------

--
-- Structure de la table `magasin`
--

DROP TABLE IF EXISTS `magasin`;
CREATE TABLE IF NOT EXISTS `magasin` (
  `id` int NOT NULL AUTO_INCREMENT,
  `nom` varchar(150) NOT NULL,
  `adresse` text,
  `responsable_id` int UNSIGNED DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `responsable_id` (`responsable_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Structure de la table `module`
--

DROP TABLE IF EXISTS `module`;
CREATE TABLE IF NOT EXISTS `module` (
  `id` int UNSIGNED NOT NULL AUTO_INCREMENT,
  `formation_id` int UNSIGNED NOT NULL,
  `titre` varchar(255) NOT NULL,
  `description` text,
  `ordre` int DEFAULT '0',
  `duree` varchar(50) DEFAULT NULL,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_module_formation` (`formation_id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Structure de la table `paiement`
--

DROP TABLE IF EXISTS `paiement`;
CREATE TABLE IF NOT EXISTS `paiement` (
  `id` int UNSIGNED NOT NULL AUTO_INCREMENT,
  `etudiant_id` int UNSIGNED NOT NULL,
  `formation_id` int UNSIGNED NOT NULL,
  `inscription_id` int UNSIGNED DEFAULT NULL,
  `montant` decimal(10,2) NOT NULL,
  `balance_after` decimal(10,2) DEFAULT NULL,
  `date_paiement` date NOT NULL,
  `mode_paiement` varchar(50) DEFAULT NULL,
  `statut` varchar(20) DEFAULT NULL,
  `reference` varchar(100) DEFAULT NULL,
  `remarques` text,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `ux_paiement_reference` (`reference`),
  KEY `idx_paiement_etudiant` (`etudiant_id`),
  KEY `idx_paiement_formation` (`formation_id`),
  KEY `idx_paiement_inscription` (`inscription_id`)
) ENGINE=InnoDB AUTO_INCREMENT=28 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Déchargement des données de la table `paiement`
--

INSERT INTO `paiement` (`id`, `etudiant_id`, `formation_id`, `inscription_id`, `montant`, `balance_after`, `date_paiement`, `mode_paiement`, `statut`, `reference`, `remarques`, `created_at`, `updated_at`) VALUES
(6, 27, 5, NULL, 50.00, 0.00, '2025-08-18', NULL, 'Réglé', 'RET6', NULL, '2025-08-18 14:04:20', '2025-08-18 14:04:20'),
(7, 27, 5, NULL, 30.00, 0.00, '2025-08-18', NULL, 'Réglé', 'RET7', NULL, '2025-08-18 14:17:04', '2025-08-18 14:17:04'),
(8, 25, 6, NULL, 30.00, 0.00, '2025-08-18', NULL, 'Réglé', 'RET8', NULL, '2025-08-18 14:18:34', '2025-08-18 14:18:34'),
(9, 25, 6, NULL, 30.00, 0.00, '2025-08-18', NULL, 'Réglé', 'RET9', NULL, '2025-08-18 14:25:06', '2025-08-18 14:25:06'),
(10, 25, 6, NULL, 50.00, 0.00, '2025-08-18', NULL, 'Réglé', 'RET10', NULL, '2025-08-18 14:26:29', '2025-08-18 14:26:29'),
(15, 25, 6, NULL, 30.00, 0.00, '2025-08-18', NULL, 'Réglé', 'RET15', NULL, '2025-08-18 15:49:43', '2025-08-18 15:49:43'),
(20, 18, 5, NULL, 23333.00, 0.00, '2025-08-22', NULL, 'Réglé', 'RET20', NULL, '2025-08-22 21:39:08', '2025-08-22 21:39:08'),
(22, 25, 4, NULL, 3333.00, 0.00, '2025-08-22', NULL, 'Réglé', 'RET22', NULL, '2025-08-22 21:41:22', '2025-08-22 21:41:22'),
(23, 25, 6, NULL, 30.00, -3363.00, '2025-08-23', NULL, 'Non réglé', 'RET23', NULL, '2025-08-22 22:01:18', '2025-08-23 00:01:17'),
(24, 2, 9, 13, 23444.00, -22824.00, '2025-08-23', NULL, 'Non réglé', 'RET24', NULL, '2025-08-22 22:07:18', '2025-08-23 00:07:17'),
(25, 25, 6, 11, 324.00, -3687.00, '2025-08-23', NULL, 'Non réglé', 'RET25', NULL, '2025-08-23 07:15:14', '2025-08-23 09:15:13'),
(26, 37, 4, 19, 100.00, 350.00, '2025-08-23', NULL, 'Non réglé', 'RET26', NULL, '2025-08-23 16:22:36', '2025-08-23 16:22:36'),
(27, 22, 4, 6, 3333333.00, -3333013.00, '2025-08-28', NULL, 'Non réglé', 'RET27', NULL, '2025-08-28 09:40:36', '2025-08-28 11:40:36');

-- --------------------------------------------------------

--
-- Structure de la table `paiement_fournisseur`
--

DROP TABLE IF EXISTS `paiement_fournisseur`;
CREATE TABLE IF NOT EXISTS `paiement_fournisseur` (
  `id` int NOT NULL AUTO_INCREMENT,
  `commande_id` int NOT NULL,
  `montant` decimal(12,2) NOT NULL,
  `mode_paiement` varchar(50) DEFAULT NULL,
  `reference_paiement` varchar(120) DEFAULT NULL,
  `date_paiement` date DEFAULT (curdate()),
  `cree_par_id` int UNSIGNED DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `commande_id` (`commande_id`),
  KEY `cree_par_id` (`cree_par_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Structure de la table `payment_plan`
--

DROP TABLE IF EXISTS `payment_plan`;
CREATE TABLE IF NOT EXISTS `payment_plan` (
  `id` int UNSIGNED NOT NULL AUTO_INCREMENT,
  `inscription_id` int UNSIGNED NOT NULL,
  `total` decimal(10,2) NOT NULL,
  `installments` int DEFAULT '1',
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `note` text,
  PRIMARY KEY (`id`),
  KEY `idx_plan_inscription` (`inscription_id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Structure de la table `progression_module`
--

DROP TABLE IF EXISTS `progression_module`;
CREATE TABLE IF NOT EXISTS `progression_module` (
  `id` int UNSIGNED NOT NULL AUTO_INCREMENT,
  `inscription_id` int UNSIGNED NOT NULL,
  `module_id` int UNSIGNED NOT NULL,
  `complet` tinyint(1) DEFAULT '0',
  `score` decimal(5,2) DEFAULT NULL,
  `date_completion` datetime DEFAULT NULL,
  `remarques` text,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_prog_insc_module` (`inscription_id`,`module_id`),
  KEY `idx_prog_insc` (`inscription_id`),
  KEY `idx_prog_module` (`module_id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Structure de la table `reception_fournisseur`
--

DROP TABLE IF EXISTS `reception_fournisseur`;
CREATE TABLE IF NOT EXISTS `reception_fournisseur` (
  `id` int NOT NULL AUTO_INCREMENT,
  `commande_id` int NOT NULL,
  `magasin_id` int NOT NULL,
  `date_reception` date DEFAULT (curdate()),
  `notes` text,
  `cree_par_id` int UNSIGNED DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `commande_id` (`commande_id`),
  KEY `magasin_id` (`magasin_id`),
  KEY `cree_par_id` (`cree_par_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Structure de la table `reglement_enseignants`
--

DROP TABLE IF EXISTS `reglement_enseignants`;
CREATE TABLE IF NOT EXISTS `reglement_enseignants` (
  `id` int UNSIGNED NOT NULL AUTO_INCREMENT,
  `enseignant_id` int UNSIGNED NOT NULL,
  `montant` decimal(10,2) NOT NULL,
  `balance_after` decimal(10,2) DEFAULT NULL,
  `date_reglement` date NOT NULL,
  `mode_reglement` varchar(50) DEFAULT NULL,
  `statut` varchar(20) DEFAULT NULL,
  `reference` varchar(100) DEFAULT NULL,
  `remarques` text,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `ux_reglement_reference` (`reference`),
  KEY `idx_reglement_enseignant` (`enseignant_id`)
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Déchargement des données de la table `reglement_enseignants`
--

INSERT INTO `reglement_enseignants` (`id`, `enseignant_id`, `montant`, `balance_after`, `date_reglement`, `mode_reglement`, `statut`, `reference`, `remarques`, `created_at`, `updated_at`) VALUES
(2, 3, 500.00, NULL, '2025-08-14', 'virement', 'ff', 'REN2', 'kl', '2025-08-19 14:03:06', '2025-08-19 16:03:06'),
(4, 2, 30.00, NULL, '2025-08-06', '', '', 'REN4', '', '2025-08-27 10:48:44', '2025-08-27 12:48:44'),
(5, 2, 5000.00, NULL, '2025-08-13', '', '', 'REN5', '', '2025-08-28 09:32:11', '2025-08-28 11:32:10'),
(6, 3, 12000.00, NULL, '2025-08-28', '', '', 'REN6', '', '2025-08-28 09:32:50', '2025-08-28 11:32:49'),
(13, 2, 3333333.00, NULL, '2025-06-12', '', '', 'REN13', '', '2025-08-28 09:46:21', '2025-08-28 11:46:20'),
(15, 3, 333333.00, NULL, '2025-08-28', '', '', 'REN15', '', '2025-08-28 09:50:24', '2025-08-28 11:50:24');

-- --------------------------------------------------------

--
-- Structure de la table `salle`
--

DROP TABLE IF EXISTS `salle`;
CREATE TABLE IF NOT EXISTS `salle` (
  `id` int UNSIGNED NOT NULL AUTO_INCREMENT,
  `nom` varchar(100) NOT NULL,
  `capacite` int DEFAULT NULL,
  `equipements` text,
  `statut` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Déchargement des données de la table `salle`
--

INSERT INTO `salle` (`id`, `nom`, `capacite`, `equipements`, `statut`) VALUES
(1, 'Salle A', 25, 'Projecteur,Tables', 'disponible');

-- --------------------------------------------------------

--
-- Structure de la table `session`
--

DROP TABLE IF EXISTS `session`;
CREATE TABLE IF NOT EXISTS `session` (
  `id` int UNSIGNED NOT NULL AUTO_INCREMENT,
  `formation_id` int UNSIGNED NOT NULL,
  `salle_id` int UNSIGNED DEFAULT NULL,
  `formateur_id` int UNSIGNED DEFAULT NULL,
  `date_debut` date NOT NULL,
  `date_fin` date DEFAULT NULL,
  `horaire_debut` time DEFAULT NULL,
  `horaire_fin` time DEFAULT NULL,
  `statut` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_session_formation` (`formation_id`),
  KEY `idx_session_salle` (`salle_id`),
  KEY `idx_session_formateur` (`formateur_id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Structure de la table `stock_inventaire`
--

DROP TABLE IF EXISTS `stock_inventaire`;
CREATE TABLE IF NOT EXISTS `stock_inventaire` (
  `id` int NOT NULL AUTO_INCREMENT,
  `magasin_id` int NOT NULL,
  `article_id` int NOT NULL,
  `quantite` int DEFAULT '0',
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_stock` (`magasin_id`,`article_id`),
  KEY `article_id` (`article_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Structure de la table `stock_mouvement`
--

DROP TABLE IF EXISTS `stock_mouvement`;
CREATE TABLE IF NOT EXISTS `stock_mouvement` (
  `id` int NOT NULL AUTO_INCREMENT,
  `magasin_id` int NOT NULL,
  `article_id` int NOT NULL,
  `type` enum('entree','sortie','ajustement') NOT NULL,
  `quantite` int NOT NULL,
  `reference` varchar(120) DEFAULT NULL,
  `origine` varchar(50) DEFAULT NULL,
  `cree_par_id` int UNSIGNED DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `magasin_id` (`magasin_id`),
  KEY `article_id` (`article_id`),
  KEY `cree_par_id` (`cree_par_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Structure de la table `support`
--

DROP TABLE IF EXISTS `support`;
CREATE TABLE IF NOT EXISTS `support` (
  `id` int UNSIGNED NOT NULL AUTO_INCREMENT,
  `formation_id` int UNSIGNED DEFAULT NULL,
  `module_id` int UNSIGNED DEFAULT NULL,
  `titre` varchar(255) NOT NULL,
  `type` varchar(50) DEFAULT 'document',
  `file_path` varchar(512) DEFAULT NULL,
  `url` varchar(1024) DEFAULT NULL,
  `meta` json DEFAULT NULL,
  `uploaded_by` int UNSIGNED DEFAULT NULL,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_support_formation` (`formation_id`),
  KEY `idx_support_module` (`module_id`),
  KEY `idx_support_uploaded_by` (`uploaded_by`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Déchargement des données de la table `support`
--

INSERT INTO `support` (`id`, `formation_id`, `module_id`, `titre`, `type`, `file_path`, `url`, `meta`, `uploaded_by`, `created_at`) VALUES
(1, NULL, NULL, 'Slides Intro', 'document', '/media/supports/intro_design.pdf', NULL, NULL, 1, '2025-08-15 15:23:18'),
(2, NULL, NULL, 'Exercice Photoshop', 'document', '/media/supports/exo_ps.pdf', NULL, NULL, 1, '2025-08-15 15:23:18'),
(3, NULL, NULL, 'Checklist SEO', 'document', '/media/supports/seo_check.pdf', NULL, NULL, 2, '2025-08-15 15:23:18');

-- --------------------------------------------------------

--
-- Structure de la table `utilisateur`
--

DROP TABLE IF EXISTS `utilisateur`;
CREATE TABLE IF NOT EXISTS `utilisateur` (
  `id` int UNSIGNED NOT NULL AUTO_INCREMENT,
  `nom` varchar(100) NOT NULL,
  `prenom` varchar(100) NOT NULL,
  `email` varchar(150) NOT NULL,
  `mot_de_passe` varchar(255) NOT NULL,
  `statut` varchar(50) DEFAULT NULL,
  `photo` varchar(255) DEFAULT NULL,
  `etat_compte` varchar(50) DEFAULT NULL,
  `date_creation` datetime DEFAULT NULL,
  `derniere_connexion` datetime DEFAULT NULL,
  `code_utilisateur` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_utilisateur_email` (`email`),
  UNIQUE KEY `uq_utilisateur_code` (`code_utilisateur`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Déchargement des données de la table `utilisateur`
--

INSERT INTO `utilisateur` (`id`, `nom`, `prenom`, `email`, `mot_de_passe`, `statut`, `photo`, `etat_compte`, `date_creation`, `derniere_connexion`, `code_utilisateur`) VALUES
(1, 'Dupont', 'Alice', 'alice.dupont@example.com', 'hashpwd1', 'actif', NULL, NULL, '2024-01-10 09:00:00', NULL, NULL),
(2, 'Bernard', 'Omar', 'omar.bernard@example.com', 'hashpwd2', 'actif', NULL, NULL, '2024-02-02 10:30:00', NULL, NULL);

--
-- Contraintes pour les tables déchargées
--

--
-- Contraintes pour la table `article`
--
ALTER TABLE `article`
  ADD CONSTRAINT `article_ibfk_1` FOREIGN KEY (`categorie_id`) REFERENCES `categorie_article` (`id`) ON DELETE SET NULL;

--
-- Contraintes pour la table `availability_formateur`
--
ALTER TABLE `availability_formateur`
  ADD CONSTRAINT `fk_avail_user` FOREIGN KEY (`utilisateur_id`) REFERENCES `utilisateur` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Contraintes pour la table `bank_reconciliation`
--
ALTER TABLE `bank_reconciliation`
  ADD CONSTRAINT `fk_bank_paiement` FOREIGN KEY (`paiement_id`) REFERENCES `paiement` (`id`) ON DELETE SET NULL ON UPDATE CASCADE;

--
-- Contraintes pour la table `calendar_event`
--
ALTER TABLE `calendar_event`
  ADD CONSTRAINT `fk_event_formation` FOREIGN KEY (`formation_id`) REFERENCES `formation` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_event_organisateur` FOREIGN KEY (`organisateur_id`) REFERENCES `utilisateur` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_event_salle` FOREIGN KEY (`salle_id`) REFERENCES `salle` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_event_session` FOREIGN KEY (`session_id`) REFERENCES `session` (`id`) ON DELETE SET NULL ON UPDATE CASCADE;

--
-- Contraintes pour la table `certification`
--
ALTER TABLE `certification`
  ADD CONSTRAINT `fk_cert_delivre_par` FOREIGN KEY (`delivre_par`) REFERENCES `utilisateur` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_cert_insc` FOREIGN KEY (`inscription_id`) REFERENCES `inscription` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Contraintes pour la table `commande_achat`
--
ALTER TABLE `commande_achat`
  ADD CONSTRAINT `commande_achat_ibfk_1` FOREIGN KEY (`fournisseur_id`) REFERENCES `fournisseur` (`id`) ON DELETE RESTRICT,
  ADD CONSTRAINT `commande_achat_ibfk_2` FOREIGN KEY (`cree_par_id`) REFERENCES `utilisateur` (`id`) ON DELETE SET NULL;

--
-- Contraintes pour la table `commande_achat_item`
--
ALTER TABLE `commande_achat_item`
  ADD CONSTRAINT `commande_achat_item_ibfk_1` FOREIGN KEY (`commande_id`) REFERENCES `commande_achat` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `commande_achat_item_ibfk_2` FOREIGN KEY (`article_id`) REFERENCES `article` (`id`) ON DELETE RESTRICT;

--
-- Contraintes pour la table `enseignant`
--
ALTER TABLE `enseignant`
  ADD CONSTRAINT `enseignant_ibfk_1` FOREIGN KEY (`formation_id`) REFERENCES `formation` (`id`);

--
-- Contraintes pour la table `etudiant`
--
ALTER TABLE `etudiant`
  ADD CONSTRAINT `fk_etudiant_formation` FOREIGN KEY (`formation_id`) REFERENCES `formation` (`id`) ON DELETE SET NULL ON UPDATE CASCADE;

--
-- Contraintes pour la table `facture_fournisseur`
--
ALTER TABLE `facture_fournisseur`
  ADD CONSTRAINT `facture_fournisseur_ibfk_1` FOREIGN KEY (`commande_id`) REFERENCES `commande_achat` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `facture_fournisseur_ibfk_2` FOREIGN KEY (`cree_par_id`) REFERENCES `utilisateur` (`id`) ON DELETE SET NULL;

--
-- Contraintes pour la table `inscription`
--
ALTER TABLE `inscription`
  ADD CONSTRAINT `fk_insc_etudiant` FOREIGN KEY (`etudiant_id`) REFERENCES `etudiant` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_insc_formation` FOREIGN KEY (`formation_id`) REFERENCES `formation` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Contraintes pour la table `invoice`
--
ALTER TABLE `invoice`
  ADD CONSTRAINT `fk_invoice_insc` FOREIGN KEY (`inscription_id`) REFERENCES `inscription` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_invoice_paiement` FOREIGN KEY (`paiement_id`) REFERENCES `paiement` (`id`) ON DELETE SET NULL ON UPDATE CASCADE;

--
-- Contraintes pour la table `magasin`
--
ALTER TABLE `magasin`
  ADD CONSTRAINT `magasin_ibfk_1` FOREIGN KEY (`responsable_id`) REFERENCES `utilisateur` (`id`) ON DELETE SET NULL;

--
-- Contraintes pour la table `module`
--
ALTER TABLE `module`
  ADD CONSTRAINT `fk_module_formation` FOREIGN KEY (`formation_id`) REFERENCES `formation` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Contraintes pour la table `paiement`
--
ALTER TABLE `paiement`
  ADD CONSTRAINT `fk_paiement_formation` FOREIGN KEY (`formation_id`) REFERENCES `formation` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Contraintes pour la table `paiement_fournisseur`
--
ALTER TABLE `paiement_fournisseur`
  ADD CONSTRAINT `paiement_fournisseur_ibfk_1` FOREIGN KEY (`commande_id`) REFERENCES `commande_achat` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `paiement_fournisseur_ibfk_2` FOREIGN KEY (`cree_par_id`) REFERENCES `utilisateur` (`id`) ON DELETE SET NULL;

--
-- Contraintes pour la table `payment_plan`
--
ALTER TABLE `payment_plan`
  ADD CONSTRAINT `fk_plan_insc` FOREIGN KEY (`inscription_id`) REFERENCES `inscription` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Contraintes pour la table `progression_module`
--
ALTER TABLE `progression_module`
  ADD CONSTRAINT `fk_prog_insc` FOREIGN KEY (`inscription_id`) REFERENCES `inscription` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_prog_module` FOREIGN KEY (`module_id`) REFERENCES `module` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Contraintes pour la table `reception_fournisseur`
--
ALTER TABLE `reception_fournisseur`
  ADD CONSTRAINT `reception_fournisseur_ibfk_1` FOREIGN KEY (`commande_id`) REFERENCES `commande_achat` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `reception_fournisseur_ibfk_2` FOREIGN KEY (`magasin_id`) REFERENCES `magasin` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `reception_fournisseur_ibfk_3` FOREIGN KEY (`cree_par_id`) REFERENCES `utilisateur` (`id`) ON DELETE SET NULL;

--
-- Contraintes pour la table `reglement_enseignants`
--
ALTER TABLE `reglement_enseignants`
  ADD CONSTRAINT `fk_reglement_enseignant` FOREIGN KEY (`enseignant_id`) REFERENCES `enseignant` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Contraintes pour la table `session`
--
ALTER TABLE `session`
  ADD CONSTRAINT `fk_session_formateur` FOREIGN KEY (`formateur_id`) REFERENCES `utilisateur` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_session_formation` FOREIGN KEY (`formation_id`) REFERENCES `formation` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_session_salle` FOREIGN KEY (`salle_id`) REFERENCES `salle` (`id`) ON DELETE SET NULL ON UPDATE CASCADE;

--
-- Contraintes pour la table `stock_inventaire`
--
ALTER TABLE `stock_inventaire`
  ADD CONSTRAINT `stock_inventaire_ibfk_1` FOREIGN KEY (`magasin_id`) REFERENCES `magasin` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `stock_inventaire_ibfk_2` FOREIGN KEY (`article_id`) REFERENCES `article` (`id`) ON DELETE CASCADE;

--
-- Contraintes pour la table `stock_mouvement`
--
ALTER TABLE `stock_mouvement`
  ADD CONSTRAINT `stock_mouvement_ibfk_1` FOREIGN KEY (`magasin_id`) REFERENCES `magasin` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `stock_mouvement_ibfk_2` FOREIGN KEY (`article_id`) REFERENCES `article` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `stock_mouvement_ibfk_3` FOREIGN KEY (`cree_par_id`) REFERENCES `utilisateur` (`id`) ON DELETE SET NULL;

--
-- Contraintes pour la table `support`
--
ALTER TABLE `support`
  ADD CONSTRAINT `fk_support_formation` FOREIGN KEY (`formation_id`) REFERENCES `formation` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_support_module` FOREIGN KEY (`module_id`) REFERENCES `module` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_support_uploaded_by` FOREIGN KEY (`uploaded_by`) REFERENCES `utilisateur` (`id`) ON DELETE SET NULL ON UPDATE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
