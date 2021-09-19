-- --------------------------------------------------------
-- Host:                         127.0.0.1
-- Server version:               10.4.20-MariaDB - mariadb.org binary distribution
-- Server OS:                    Win64
-- HeidiSQL Version:             11.3.0.6295
-- --------------------------------------------------------

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET NAMES utf8 */;
/*!50503 SET NAMES utf8mb4 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

-- Dumping structure for table qbcoreframework_440fe4.sbshops
CREATE TABLE IF NOT EXISTS `sbshops` (
  `id` int(255) NOT NULL AUTO_INCREMENT,
  `citizenid` varchar(50) DEFAULT NULL,
  `shopName` varchar(50) DEFAULT NULL,
  `items` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL DEFAULT '[]',
  `accountMoney` int(11) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  KEY `citizenid` (`citizenid`) USING BTREE,
  KEY `shopName` (`shopName`)
) ENGINE=InnoDB AUTO_INCREMENT=158 DEFAULT CHARSET=utf8mb4;

-- Dumping data for table qbcoreframework_440fe4.sbshops: ~15 rows (approximately)
/*!40000 ALTER TABLE `sbshops` DISABLE KEYS */;
INSERT INTO `sbshops` (`id`, `citizenid`, `shopName`, `items`, `accountMoney`) VALUES
	(134, NULL, 'Shop1', '[]', 0),
	(135, NULL, 'Shop2', '[]', 0),
	(136, NULL, 'Shop3', '[]', 0),
	(137, NULL, 'Shop4', '[]', 0),
	(138, NULL, 'Shop5', '[]', 0),
	(139, NULL, 'Shop6', '[]', 0),
	(140, NULL, 'Shop7', '[]', 0),
	(141, NULL, 'Shop8', '[]', 0),
	(142, NULL, 'Shop9', '[]', 0),
	(143, NULL, 'Shop10', '[]', 0),
	(144, NULL, 'Shop11', '[{"slot":2,"name":"lockpick","price":10,"amount":100},{"slot":1,"name":"sandwich","price":10,"amount":100}]', 0),
	(145, NULL, 'Shop12', '[]', 0),
	(146, NULL, 'Shop13', '[]', 0),
	(147, NULL, 'Shop14', '[]', 0),
	(148, NULL, 'Shop15', '[]', 0),
	(155, NULL, 'Shop16', '[]', 0),
	(156, NULL, 'Shop17', '[]', 0);
/*!40000 ALTER TABLE `sbshops` ENABLE KEYS */;

/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IFNULL(@OLD_FOREIGN_KEY_CHECKS, 1) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40111 SET SQL_NOTES=IFNULL(@OLD_SQL_NOTES, 1) */;
