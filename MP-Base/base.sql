SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";

CREATE DATABASE IF NOT EXISTS `mp-framework` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
USE `mp-framework`;

CREATE TABLE `players` (
    `id` int(50) NOT NULL,
    `identifier` varchar(50) DEFAULT NULL,
    `license` varchar(50) DEFAULT NULL,
    `name` varchar(50) DEFAULT NULL,
    `cid` int(11) DEFAULT NULL,
    `cash` int(11) DEFAULT NULL,
    `bank` int(11) DEFAULT NULL,
    `firstname` varchar(50) DEFAULT NULL,
    `lastname` varchar(50) DEFAULT NULL,
    `sex` varchar(50) DEFAULT NULL,
    `dob` varchar(50) DEFAULT NULL,
    `job` varchar(50) DEFAULT 'unemployed',
    `phone` text DEFAULT NULL,
    `citizenid` varchar(200) DEFAULT NULL,
    `new` boolean DEFAULT true
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `ranking` (
    `identifier` varchar(40) DEFAULT NULL,
    `usergroup` varchar(40) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;

ALTER TABLE `players`
    ADD PRIMARY KEY (`id`);

ALTER TABLE `ranking`
  ADD PRIMARY KEY (`identifier`);

ALTER TABLE `players`
    MODIFY `id` int(50) NOT NULL AUTO_INCREMENT;
COMMIT;