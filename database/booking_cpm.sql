-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1:3307
-- Generation Time: Jun 21, 2026 at 11:53 AM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `booking_cpm`
--

-- --------------------------------------------------------

--
-- Table structure for table `booking`
--

CREATE TABLE `booking` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `booking_code` varchar(255) NOT NULL,
  `user_id` bigint(20) UNSIGNED NOT NULL,
  `slot_id` bigint(20) UNSIGNED NOT NULL,
  `booking_time` datetime NOT NULL,
  `expired_time` datetime DEFAULT NULL,
  `check_in_time` datetime DEFAULT NULL,
  `check_out_time` datetime DEFAULT NULL,
  `total_payment` int(11) NOT NULL DEFAULT 0,
  `status` enum('pending_dp','active','checked_in','completed','cancelled') DEFAULT 'pending_dp',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `booking`
--

INSERT INTO `booking` (`id`, `booking_code`, `user_id`, `slot_id`, `booking_time`, `expired_time`, `check_in_time`, `check_out_time`, `total_payment`, `status`, `created_at`, `updated_at`) VALUES
(1, 'BK-IYRUQG5ITU4EF', 1, 32, '2026-06-12 07:59:07', '2026-06-12 08:29:07', NULL, NULL, 5000, 'active', '2026-06-12 00:59:07', '2026-06-12 00:59:19'),
(2, 'BK-EEUZTZTV8TKJA', 2, 1, '2026-06-12 09:14:41', '2026-06-12 09:44:41', '2026-06-16 07:42:20', '2026-06-16 09:18:49', 8000, 'completed', '2026-06-12 02:14:41', '2026-06-16 02:19:03'),
(3, 'BK-AFFCVPKUKWB02', 3, 2, '2026-06-13 11:54:17', '2026-06-13 12:24:17', NULL, NULL, 5000, 'active', '2026-06-13 04:54:17', '2026-06-13 04:55:59'),
(4, 'BK-DLMMIOY7ZJOZC', 2, 9, '2026-06-16 07:16:11', '2026-06-16 07:46:11', '2026-06-16 07:43:31', '2026-06-17 12:17:29', 89000, 'completed', '2026-06-16 00:16:11', '2026-06-17 05:18:04'),
(5, 'BK-SW17GBJ4GV9YJ', 2, 10, '2026-06-16 07:16:49', '2026-06-16 07:46:49', '2026-06-17 12:14:06', '2026-06-21 09:48:41', 284000, 'completed', '2026-06-16 00:16:49', '2026-06-21 02:48:52'),
(6, 'BK-1SXZVMPKHQ1YQ', 2, 1, '2026-06-16 09:22:10', '2026-06-16 09:52:10', '2026-06-16 09:22:28', '2026-06-16 09:23:05', 5000, 'completed', '2026-06-16 02:22:10', '2026-06-16 02:23:09'),
(7, 'BK-JBRUIYYTZQXZC', 2, 11, '2026-06-16 09:47:32', '2026-06-16 10:17:32', '2026-06-16 09:48:04', '2026-06-16 09:48:54', 5000, 'completed', '2026-06-16 02:47:32', '2026-06-16 02:49:27'),
(8, 'BK-MIEV6X9XCC79Z', 4, 4, '2026-06-17 11:37:47', '2026-06-17 12:07:47', NULL, NULL, 5000, 'pending_dp', '2026-06-17 04:37:47', '2026-06-17 04:37:47'),
(9, 'BK-4WKUCAFP5CURR', 2, 11, '2026-06-17 11:41:37', '2026-06-17 12:11:37', '2026-06-17 11:42:01', '2026-06-17 11:42:37', 5000, 'completed', '2026-06-17 04:41:37', '2026-06-17 04:42:40'),
(10, 'BK-DQ31S87KDWJNE', 2, 11, '2026-06-17 11:44:06', '2026-06-17 12:14:06', NULL, NULL, 5000, 'cancelled', '2026-06-17 04:44:06', '2026-06-21 02:32:58'),
(11, 'BK-PBIPUYYUEYHIU', 2, 12, '2026-06-17 12:06:27', '2026-06-17 12:36:27', '2026-06-17 12:07:10', '2026-06-17 12:08:04', 5000, 'completed', '2026-06-17 05:06:27', '2026-06-17 05:08:25'),
(12, 'BK-ZEICVVZOYDATQ', 2, 13, '2026-06-17 12:10:47', '2026-06-17 12:40:47', NULL, NULL, 5000, 'cancelled', '2026-06-17 05:10:47', '2026-06-21 02:32:57'),
(13, 'BK-BSO3BSRZNF0U3', 2, 14, '2026-06-17 12:11:24', '2026-06-17 12:41:24', NULL, NULL, 5000, 'cancelled', '2026-06-17 05:11:24', '2026-06-21 02:32:57'),
(14, 'BK-BYDITM50HEX5U', 2, 1, '2026-06-21 06:20:43', '2026-06-21 06:50:43', NULL, NULL, 5000, 'cancelled', '2026-06-20 23:20:43', '2026-06-21 02:32:56'),
(15, 'BK-FJGQP45NG69L0', 2, 9, '2026-06-21 07:22:27', '2026-06-21 07:52:27', NULL, NULL, 5000, 'cancelled', '2026-06-21 00:22:27', '2026-06-21 02:32:56'),
(16, 'BK-R2BOWIWZAZIHF', 2, 12, '2026-06-21 07:26:54', '2026-06-21 07:56:54', NULL, NULL, 5000, 'cancelled', '2026-06-21 00:26:54', '2026-06-21 02:32:55'),
(17, 'BK-DF0US4TV17SHM', 2, 9, '2026-06-21 07:34:25', '2026-06-21 08:04:25', NULL, NULL, 5000, 'cancelled', '2026-06-21 00:34:25', '2026-06-21 02:32:55'),
(18, 'BK-1UJQOJOE01CAX', 2, 9, '2026-06-21 07:36:04', '2026-06-21 08:06:04', NULL, NULL, 5000, 'cancelled', '2026-06-21 00:36:04', '2026-06-21 02:32:54'),
(19, 'BK-44FGLQTI07OIW', 2, 9, '2026-06-21 07:36:42', '2026-06-21 08:06:42', NULL, NULL, 5000, 'cancelled', '2026-06-21 00:36:42', '2026-06-21 02:32:53'),
(20, 'BK-UE0P3HFZUSXHM', 2, 9, '2026-06-21 07:47:41', '2026-06-21 08:17:41', NULL, NULL, 5000, 'cancelled', '2026-06-21 00:47:41', '2026-06-21 02:32:53'),
(21, 'BK-Y3SJUEL5S6UUP', 2, 1, '2026-06-21 07:49:28', '2026-06-21 08:19:28', NULL, NULL, 5000, 'cancelled', '2026-06-21 00:49:28', '2026-06-21 02:32:53'),
(22, 'BK-PQ2WHALDGMYGE', 1, 1, '2026-06-21 08:05:11', '2026-06-21 08:35:11', NULL, NULL, 5000, 'pending_dp', '2026-06-21 01:05:11', '2026-06-21 01:05:11'),
(23, 'BK-XPHDZJSE9NDLU', 2, 1, '2026-06-21 08:43:17', '2026-06-21 09:13:17', NULL, NULL, 5000, 'cancelled', '2026-06-21 01:43:17', '2026-06-21 02:32:52'),
(24, 'BK-OEJ7VL5JUEXOO', 2, 1, '2026-06-21 09:01:09', '2026-06-21 09:31:09', NULL, NULL, 5000, 'cancelled', '2026-06-21 02:01:09', '2026-06-21 02:32:52'),
(25, 'BK-UAPTZPCVNPIE2', 2, 9, '2026-06-21 09:13:47', '2026-06-21 09:43:47', NULL, NULL, 5000, 'cancelled', '2026-06-21 02:13:47', '2026-06-21 02:32:51'),
(26, 'BK-4FZCJBCBUMLSV', 2, 9, '2026-06-21 09:33:54', '2026-06-21 10:03:54', NULL, NULL, 5000, 'cancelled', '2026-06-21 02:33:54', '2026-06-21 02:39:43'),
(27, 'BK-C0JA9ALEJ1AV4', 2, 9, '2026-06-21 09:39:58', '2026-06-21 10:09:58', NULL, NULL, 5000, 'cancelled', '2026-06-21 02:39:58', '2026-06-21 02:43:35'),
(28, 'BK-IMOT0KAAAM4X3', 2, 1, '2026-06-21 09:43:53', '2026-06-21 10:13:53', NULL, NULL, 5000, 'cancelled', '2026-06-21 02:43:53', '2026-06-21 02:46:47'),
(29, 'BK-VXTGQF9XYX5GL', 2, 3, '2026-06-21 09:47:38', '2026-06-21 10:17:38', '2026-06-21 09:47:48', NULL, 5000, 'checked_in', '2026-06-21 02:47:38', '2026-06-21 02:47:48');

-- --------------------------------------------------------

--
-- Table structure for table `cache`
--

CREATE TABLE `cache` (
  `key` varchar(255) NOT NULL,
  `value` mediumtext NOT NULL,
  `expiration` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `cache_locks`
--

CREATE TABLE `cache_locks` (
  `key` varchar(255) NOT NULL,
  `owner` varchar(255) NOT NULL,
  `expiration` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `failed_jobs`
--

CREATE TABLE `failed_jobs` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `uuid` varchar(255) NOT NULL,
  `connection` text NOT NULL,
  `queue` text NOT NULL,
  `payload` longtext NOT NULL,
  `exception` longtext NOT NULL,
  `failed_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `floor`
--

CREATE TABLE `floor` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `name` varchar(100) NOT NULL,
  `capacity` int(11) NOT NULL DEFAULT 8,
  `occupied` int(11) NOT NULL DEFAULT 0,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `floor`
--

INSERT INTO `floor` (`id`, `name`, `capacity`, `occupied`, `created_at`, `updated_at`) VALUES
(1, 'Lantai 1 (Zona A)', 8, 0, '2026-06-12 07:45:42', '2026-06-12 07:45:42'),
(2, 'Lantai 2 (Zona B)', 8, 0, '2026-06-12 07:45:42', '2026-06-12 07:45:42'),
(3, 'Lantai 3 (Zona C)', 8, 0, '2026-06-12 07:45:42', '2026-06-12 07:45:42'),
(4, 'Lantai 4 (Zona D)', 8, 0, '2026-06-12 07:45:42', '2026-06-12 07:45:42'),
(5, 'Lantai 5 (Zona E)', 8, 0, '2026-06-12 07:45:42', '2026-06-12 07:45:42');

-- --------------------------------------------------------

--
-- Table structure for table `jobs`
--

CREATE TABLE `jobs` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `queue` varchar(255) NOT NULL,
  `payload` longtext NOT NULL,
  `attempts` tinyint(3) UNSIGNED NOT NULL,
  `reserved_at` int(10) UNSIGNED DEFAULT NULL,
  `available_at` int(10) UNSIGNED NOT NULL,
  `created_at` int(10) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `job_batches`
--

CREATE TABLE `job_batches` (
  `id` varchar(255) NOT NULL,
  `name` varchar(255) NOT NULL,
  `total_jobs` int(11) NOT NULL,
  `pending_jobs` int(11) NOT NULL,
  `failed_jobs` int(11) NOT NULL,
  `failed_job_ids` longtext NOT NULL,
  `options` mediumtext DEFAULT NULL,
  `cancelled_at` int(11) DEFAULT NULL,
  `created_at` int(11) NOT NULL,
  `finished_at` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `migrations`
--

CREATE TABLE `migrations` (
  `id` int(10) UNSIGNED NOT NULL,
  `migration` varchar(255) NOT NULL,
  `batch` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `migrations`
--

INSERT INTO `migrations` (`id`, `migration`, `batch`) VALUES
(1, '0001_01_01_000001_create_cache_table', 1),
(2, '0001_01_01_000002_create_jobs_table', 1);

-- --------------------------------------------------------

--
-- Table structure for table `parking_slot`
--

CREATE TABLE `parking_slot` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `floor_id` bigint(20) UNSIGNED NOT NULL,
  `kode_slot` varchar(20) NOT NULL,
  `status` enum('available','booked','occupied') NOT NULL DEFAULT 'available',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `parking_slot`
--

INSERT INTO `parking_slot` (`id`, `floor_id`, `kode_slot`, `status`, `created_at`, `updated_at`) VALUES
(1, 1, 'A1', 'available', '2026-06-12 07:45:42', '2026-06-21 02:46:47'),
(2, 1, 'A2', 'booked', '2026-06-12 07:45:42', '2026-06-13 04:54:17'),
(3, 1, 'A3', 'occupied', '2026-06-12 07:45:42', '2026-06-21 02:47:48'),
(4, 1, 'A4', 'booked', '2026-06-12 07:45:42', '2026-06-17 04:37:47'),
(5, 1, 'A5', 'available', '2026-06-12 07:45:42', '2026-06-12 07:45:42'),
(6, 1, 'A6', 'available', '2026-06-12 07:45:42', '2026-06-12 07:45:42'),
(7, 1, 'A7', 'available', '2026-06-12 07:45:42', '2026-06-12 07:45:42'),
(8, 1, 'A8', 'available', '2026-06-12 07:45:42', '2026-06-12 07:45:42'),
(9, 2, 'B1', 'available', '2026-06-12 07:45:42', '2026-06-21 02:43:35'),
(10, 2, 'B2', 'available', '2026-06-12 07:45:42', '2026-06-21 02:48:52'),
(11, 2, 'B3', 'available', '2026-06-12 07:45:42', '2026-06-21 00:47:16'),
(12, 2, 'B4', 'available', '2026-06-12 07:45:42', '2026-06-21 00:33:52'),
(13, 2, 'B5', 'available', '2026-06-12 07:45:42', '2026-06-21 00:20:17'),
(14, 2, 'B6', 'available', '2026-06-12 07:45:42', '2026-06-21 00:20:07'),
(15, 2, 'B7', 'available', '2026-06-12 07:45:42', '2026-06-12 07:45:42'),
(16, 2, 'B8', 'available', '2026-06-12 07:45:42', '2026-06-12 07:45:42'),
(17, 3, 'C1', 'available', '2026-06-12 07:45:42', '2026-06-12 07:45:42'),
(18, 3, 'C2', 'available', '2026-06-12 07:45:42', '2026-06-12 07:45:42'),
(19, 3, 'C3', 'available', '2026-06-12 07:45:42', '2026-06-12 07:45:42'),
(20, 3, 'C4', 'available', '2026-06-12 07:45:42', '2026-06-12 07:45:42'),
(21, 3, 'C5', 'available', '2026-06-12 07:45:42', '2026-06-12 07:45:42'),
(22, 3, 'C6', 'available', '2026-06-12 07:45:42', '2026-06-12 07:45:42'),
(23, 3, 'C7', 'available', '2026-06-12 07:45:42', '2026-06-12 07:45:42'),
(24, 3, 'C8', 'available', '2026-06-12 07:45:42', '2026-06-12 07:45:42'),
(25, 4, 'D1', 'available', '2026-06-12 07:45:42', '2026-06-12 07:45:42'),
(26, 4, 'D2', 'available', '2026-06-12 07:45:42', '2026-06-12 07:45:42'),
(27, 4, 'D3', 'available', '2026-06-12 07:45:42', '2026-06-12 07:45:42'),
(28, 4, 'D4', 'available', '2026-06-12 07:45:42', '2026-06-12 07:45:42'),
(29, 4, 'D5', 'available', '2026-06-12 07:45:42', '2026-06-12 07:45:42'),
(30, 4, 'D6', 'available', '2026-06-12 07:45:42', '2026-06-12 07:45:42'),
(31, 4, 'D7', 'available', '2026-06-12 07:45:42', '2026-06-12 07:45:42'),
(32, 4, 'D8', 'booked', '2026-06-12 07:45:42', '2026-06-12 00:59:07'),
(33, 5, 'E1', 'available', '2026-06-12 07:45:42', '2026-06-12 07:45:42'),
(34, 5, 'E2', 'available', '2026-06-12 07:45:42', '2026-06-12 07:45:42'),
(35, 5, 'E3', 'available', '2026-06-12 07:45:42', '2026-06-12 07:45:42'),
(36, 5, 'E4', 'available', '2026-06-12 07:45:42', '2026-06-12 07:45:42'),
(37, 5, 'E5', 'available', '2026-06-12 07:45:42', '2026-06-12 07:45:42'),
(38, 5, 'E6', 'available', '2026-06-12 07:45:42', '2026-06-12 07:45:42'),
(39, 5, 'E7', 'available', '2026-06-12 07:45:42', '2026-06-12 07:45:42'),
(40, 5, 'E8', 'available', '2026-06-12 07:45:42', '2026-06-12 07:45:42');

-- --------------------------------------------------------

--
-- Table structure for table `payment`
--

CREATE TABLE `payment` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `booking_id` bigint(20) UNSIGNED NOT NULL,
  `amount` int(11) NOT NULL,
  `proof` varchar(255) NOT NULL,
  `status` enum('pending','approved','rejected') NOT NULL DEFAULT 'pending',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `payment`
--

INSERT INTO `payment` (`id`, `booking_id`, `amount`, `proof`, `status`, `created_at`, `updated_at`) VALUES
(1, 1, 5000, 'payments/jAMS1EwYxuELao1reLaozD6C4ZZtBXZhuCnkS8tQ.png', 'approved', '2026-06-12 00:59:19', '2026-06-12 00:59:19'),
(2, 2, 5000, 'payments/mhISmkyrKNgWErVMr1oUsKMhXtDzWLzYaKQzTPMF.png', 'approved', '2026-06-12 02:15:05', '2026-06-12 02:15:05'),
(3, 3, 5000, 'payments/s1JO2u0natlabIV2tuDhgnjQt6CYY8eTsfYUITN2.png', 'approved', '2026-06-13 04:55:59', '2026-06-13 04:55:59'),
(4, 4, 5000, 'payments/QW8zw0YGPjMsiHoLELa3XkzTPqB5GUaNS58Ik2tQ.png', 'approved', '2026-06-16 00:16:21', '2026-06-16 00:16:21'),
(5, 5, 5000, 'payments/WLtSg8eI55GmbX6H0MryKtPcxWRUaiPZRI96u2aS.png', 'approved', '2026-06-16 00:16:57', '2026-06-16 00:16:57'),
(6, 2, 3000, 'pending_online', 'approved', '2026-06-16 02:18:49', '2026-06-16 02:19:03'),
(7, 6, 5000, 'payments/9Zr2N2lgmoZMRyzSGDRQcQcTb6u4ZXFJpUBWLDD5.png', 'approved', '2026-06-16 02:22:21', '2026-06-16 02:22:21'),
(8, 6, 0, 'pending_online', 'approved', '2026-06-16 02:23:05', '2026-06-16 02:23:09'),
(9, 7, 5000, 'payments/pB48mLdj1uohrRrr5V8fjr8lP4IpBZoUnh7QAqb2.png', 'approved', '2026-06-16 02:47:44', '2026-06-16 02:47:44'),
(10, 7, 0, 'pending_online', 'approved', '2026-06-16 02:48:54', '2026-06-16 02:49:27'),
(11, 9, 5000, 'payments/jvpaMgZbuH1bEgYC40xnipgGJnlVZrQyLVjuMRcv.png', 'approved', '2026-06-17 04:41:42', '2026-06-17 04:41:42'),
(12, 9, 0, 'pending_online', 'approved', '2026-06-17 04:42:37', '2026-06-17 04:42:40'),
(13, 11, 5000, 'payments/rc5a6YO0tM1BDg6BjHql0y8mQg2wu5SI6E7WC9jy.png', 'approved', '2026-06-17 05:06:37', '2026-06-17 05:06:37'),
(14, 11, 0, 'pending_online', 'approved', '2026-06-17 05:08:04', '2026-06-17 05:08:25'),
(15, 12, 5000, 'payments/K0p99gZmWSEDzj8IAn3bY0Ns0fZDmklzNOk1Sif3.png', 'approved', '2026-06-17 05:10:53', '2026-06-17 05:10:53'),
(16, 13, 5000, 'payments/XRCqKlcuugZsAKKTdWWlE5n7FiTxqqrsyzAP2rwX.png', 'approved', '2026-06-17 05:11:35', '2026-06-17 05:11:35'),
(17, 4, 84000, 'pending_online', 'approved', '2026-06-17 05:17:29', '2026-06-17 05:18:04'),
(18, 15, 5000, 'payments/EOTufNkRUBt89Oo0hE4wb93io7Mwmhv10l1jJs7b.png', 'approved', '2026-06-21 00:22:30', '2026-06-21 00:22:30'),
(19, 16, 5000, 'payments/Oef6qdhVdZQKXPE65gTLxZOnKbqEqfHMf4U70AMh.png', 'approved', '2026-06-21 00:26:56', '2026-06-21 00:26:56'),
(20, 17, 5000, 'payments/3qUAkuYtIdSwmqR3HMweOSqNvI1jZckLFyjPuDRz.png', 'approved', '2026-06-21 00:34:28', '2026-06-21 00:34:28'),
(21, 18, 5000, 'payments/eFiZptBy4zZTGQypmmqCYA8OLcDUAutH6qkM6rA6.png', 'approved', '2026-06-21 00:36:06', '2026-06-21 00:36:06'),
(22, 19, 5000, 'payments/7WH8TuiG78BeHZ963jGVL0Qb5GERmAsyLzrTKOHV.png', 'approved', '2026-06-21 00:36:44', '2026-06-21 00:36:44'),
(23, 20, 5000, 'payments/6uWptD73KZK79TkAJoJ6RfWXaakZqlQ3NE91OiJx.png', 'approved', '2026-06-21 00:47:45', '2026-06-21 00:47:45'),
(24, 21, 5000, 'payments/cA1yOZJ3e9DejxudxYdPlmSfLglfJKd3W94NpjKX.png', 'approved', '2026-06-21 00:49:32', '2026-06-21 00:49:32'),
(25, 23, 5000, 'payments/vQSAGpMxmAsmpptQrrzeDzdPv0lYRHxnBrajXySp.png', 'approved', '2026-06-21 01:43:20', '2026-06-21 01:43:20'),
(26, 24, 5000, 'payments/6rkgHfhFNnPQqUmSvePTsw6ZUVmDtlmC4zUebjVs.png', 'approved', '2026-06-21 02:01:14', '2026-06-21 02:01:14'),
(27, 25, 5000, 'payments/b7IM81Xv6Hd09KOSBSLXdXhYA1xUiB4KeMjwbe7o.png', 'approved', '2026-06-21 02:13:50', '2026-06-21 02:13:50'),
(28, 26, 5000, 'payments/A9VA8MwQzDE3qqjsFi5ZX6l0vMXrvEhG0buIINlh.png', 'approved', '2026-06-21 02:33:57', '2026-06-21 02:33:57'),
(29, 27, 5000, 'payments/RwNfgzL7RjGZLGG0Xv0OK8Rf6tDy3vWwSwPDFxSk.png', 'approved', '2026-06-21 02:40:02', '2026-06-21 02:40:02'),
(30, 28, 5000, 'payments/xyaxCGtOqnyUg0lOcaIF2wETCUJNZOUhUVs04Ah0.png', 'approved', '2026-06-21 02:43:56', '2026-06-21 02:43:56'),
(31, 29, 5000, 'payments/kIhgDKejMqq4JIvy7Rqdog7wRjw9adJEqX0PnB3u.png', 'approved', '2026-06-21 02:47:41', '2026-06-21 02:47:41'),
(32, 5, 279000, 'pending_online', 'approved', '2026-06-21 02:48:41', '2026-06-21 02:48:51');

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `name` varchar(100) NOT NULL,
  `email` varchar(100) NOT NULL,
  `phone` varchar(20) DEFAULT NULL,
  `plate_number` varchar(20) DEFAULT NULL,
  `password` varchar(255) NOT NULL,
  `remember_token` varchar(100) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`id`, `name`, `email`, `phone`, `plate_number`, `password`, `remember_token`, `created_at`, `updated_at`) VALUES
(1, 'nendi', 'nendi@gmail.com', '082343445656', 'B 1554 FFI', '$2y$12$qleSRyf4rcHo5vDLMKypp.YYRS1ED7PH6jv/WJcyik9C2wFPUE0si', NULL, '2026-06-12 00:57:36', '2026-06-12 00:57:36'),
(2, 'ujang', 'jang@gmail.com', '089987865453', 'F 5545 FTK', '$2y$12$NHmbGEN9GV4oMNru.HDgqe8hoabP5DdmKEKnvFhW/fZrSm6GKq.Da', NULL, '2026-06-12 02:14:01', '2026-06-12 02:14:01'),
(3, 'mufti', 'ti@gmail.com', '087634223231', 'B 4545 FFL', '$2y$12$VwVhyI4DtCyACzg/sI/OC.0AA8QObuRc6Bo.Tgld5h0fEQL1xpQum', NULL, '2026-06-13 04:52:36', '2026-06-13 04:52:36'),
(4, 'Budi Santoso', 'budi@test.com', '081234567890', 'B 1234 ABC', '$2y$12$1OTmiJRDmNzO.90Na89MUO2zxu9.LeWxpsgGRq3ET6pTCigeTHlYO', NULL, '2026-06-17 04:37:18', '2026-06-17 04:37:18');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `booking`
--
ALTER TABLE `booking`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `booking_code` (`booking_code`),
  ADD KEY `booking_user_id_foreign` (`user_id`),
  ADD KEY `booking_slot_id_foreign` (`slot_id`);

--
-- Indexes for table `cache`
--
ALTER TABLE `cache`
  ADD PRIMARY KEY (`key`),
  ADD KEY `cache_expiration_index` (`expiration`);

--
-- Indexes for table `cache_locks`
--
ALTER TABLE `cache_locks`
  ADD PRIMARY KEY (`key`),
  ADD KEY `cache_locks_expiration_index` (`expiration`);

--
-- Indexes for table `failed_jobs`
--
ALTER TABLE `failed_jobs`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `failed_jobs_uuid_unique` (`uuid`);

--
-- Indexes for table `floor`
--
ALTER TABLE `floor`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `jobs`
--
ALTER TABLE `jobs`
  ADD PRIMARY KEY (`id`),
  ADD KEY `jobs_queue_index` (`queue`);

--
-- Indexes for table `job_batches`
--
ALTER TABLE `job_batches`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `migrations`
--
ALTER TABLE `migrations`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `parking_slot`
--
ALTER TABLE `parking_slot`
  ADD PRIMARY KEY (`id`),
  ADD KEY `parking_slot_floor_id_foreign` (`floor_id`);

--
-- Indexes for table `payment`
--
ALTER TABLE `payment`
  ADD PRIMARY KEY (`id`),
  ADD KEY `payment_booking_id_foreign` (`booking_id`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `email` (`email`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `booking`
--
ALTER TABLE `booking`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=30;

--
-- AUTO_INCREMENT for table `failed_jobs`
--
ALTER TABLE `failed_jobs`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `floor`
--
ALTER TABLE `floor`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `jobs`
--
ALTER TABLE `jobs`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `migrations`
--
ALTER TABLE `migrations`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `parking_slot`
--
ALTER TABLE `parking_slot`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=41;

--
-- AUTO_INCREMENT for table `payment`
--
ALTER TABLE `payment`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=33;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `booking`
--
ALTER TABLE `booking`
  ADD CONSTRAINT `booking_slot_id_foreign` FOREIGN KEY (`slot_id`) REFERENCES `parking_slot` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `booking_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `parking_slot`
--
ALTER TABLE `parking_slot`
  ADD CONSTRAINT `parking_slot_floor_id_foreign` FOREIGN KEY (`floor_id`) REFERENCES `floor` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `payment`
--
ALTER TABLE `payment`
  ADD CONSTRAINT `payment_booking_id_foreign` FOREIGN KEY (`booking_id`) REFERENCES `booking` (`id`) ON DELETE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
