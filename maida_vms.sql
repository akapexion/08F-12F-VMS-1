-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Oct 27, 2026 at 02:51 PM
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
-- Database: `maida_vms`
--

-- --------------------------------------------------------

--
-- Table structure for table `appointment`
--

CREATE TABLE `appointment` (
  `appointment_id` int(10) UNSIGNED NOT NULL,
  `parent_id` int(10) UNSIGNED NOT NULL,
  `child_id` int(10) UNSIGNED NOT NULL,
  `hospital_id` int(10) UNSIGNED NOT NULL,
  `vaccine_id` int(10) UNSIGNED NOT NULL,
  `appointment_date` date NOT NULL,
  `appointment_time` time NOT NULL,
  `admin_status` enum('Pending','Approved','Rejected') NOT NULL DEFAULT 'Pending',
  `admin_remarks` varchar(255) DEFAULT NULL,
  `vaccination_status` enum('Pending','Vaccinated','Not Vaccinated') NOT NULL DEFAULT 'Pending',
  `hospital_remarks` varchar(255) DEFAULT NULL,
  `booked_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `appointment`
--

INSERT INTO `appointment` (`appointment_id`, `parent_id`, `child_id`, `hospital_id`, `vaccine_id`, `appointment_date`, `appointment_time`, `admin_status`, `admin_remarks`, `vaccination_status`, `hospital_remarks`, `booked_at`, `updated_at`) VALUES
(1, 1, 1, 1, 3, '2026-11-05', '10:30:00', 'Pending', NULL, 'Pending', NULL, '2026-10-27 13:19:31', '2026-10-27 13:19:31');

--
-- Triggers `appointment`
--
DELIMITER $$
CREATE TRIGGER `trg_appointment_vaccinated` AFTER UPDATE ON `appointment` FOR EACH ROW BEGIN
    IF NEW.vaccination_status = 'Vaccinated' AND OLD.vaccination_status <> 'Vaccinated' THEN
        UPDATE vaccination_schedule
           SET status = 'Vaccinated'
         WHERE child_id = NEW.child_id AND vaccine_id = NEW.vaccine_id;
    END IF;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `childs1`
--

CREATE TABLE `childs1` (
  `child_id` int(11) NOT NULL,
  `child_name` varchar(50) NOT NULL,
  `child_parent_name` varchar(50) NOT NULL,
  `child_parent_contact` int(11) NOT NULL,
  `child_gender` varchar(50) NOT NULL,
  `child_dob` date NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `hospitals`
--

CREATE TABLE `hospitals` (
  `hospital_id` int(10) UNSIGNED NOT NULL,
  `hospital_name` varchar(150) NOT NULL,
  `email` varchar(100) NOT NULL,
  `password` varchar(255) NOT NULL,
  `phone` varchar(20) DEFAULT NULL,
  `address` varchar(255) NOT NULL,
  `location` varchar(100) NOT NULL,
  `latitude` decimal(10,7) DEFAULT NULL,
  `longitude` decimal(10,7) DEFAULT NULL,
  `created_by` enum('Admin','Self') NOT NULL DEFAULT 'Self',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `hospitals`
--

INSERT INTO `hospitals` (`hospital_id`, `hospital_name`, `email`, `password`, `phone`, `address`, `location`, `latitude`, `longitude`, `created_by`, `created_at`) VALUES
(1, 'City Care Hospital', 'citycare@example.com', 'CHANGE_ME_USE_password_hash', '021-1111111', '12 Main Road', 'Karachi', NULL, NULL, 'Admin', '2026-10-27 13:19:30'),
(2, 'Green Valley Clinic', 'greenvalley@example.com', 'CHANGE_ME_USE_password_hash', '021-2222222', '45 Park Lane', 'Karachi', NULL, NULL, 'Admin', '2026-10-27 13:19:30');

-- --------------------------------------------------------

--
-- Table structure for table `notification`
--

CREATE TABLE `notification` (
  `notification_id` int(10) UNSIGNED NOT NULL,
  `parent_id` int(10) UNSIGNED NOT NULL,
  `child_id` int(10) UNSIGNED DEFAULT NULL,
  `message` varchar(255) NOT NULL,
  `is_read` tinyint(1) NOT NULL DEFAULT 0,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `notification`
--

INSERT INTO `notification` (`notification_id`, `parent_id`, `child_id`, `message`, `is_read`, `created_at`) VALUES
(1, 1, 1, 'Ayaan is due for OPV and DPT vaccines soon. Please book a hospital.', 0, '2026-10-27 13:19:31');

-- --------------------------------------------------------

--
-- Table structure for table `vaccination_schedule`
--

CREATE TABLE `vaccination_schedule` (
  `schedule_id` int(10) UNSIGNED NOT NULL,
  `child_id` int(10) UNSIGNED NOT NULL,
  `vaccine_id` int(10) UNSIGNED NOT NULL,
  `due_date` date NOT NULL,
  `status` enum('Upcoming','Vaccinated','Missed') NOT NULL DEFAULT 'Upcoming'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `vaccination_schedule`
--

INSERT INTO `vaccination_schedule` (`schedule_id`, `child_id`, `vaccine_id`, `due_date`, `status`) VALUES
(1, 1, 1, '2026-09-24', 'Vaccinated'),
(2, 1, 2, '2026-09-24', 'Vaccinated'),
(3, 1, 3, '2026-11-05', 'Upcoming'),
(4, 1, 4, '2026-11-05', 'Upcoming');

-- --------------------------------------------------------

--
-- Table structure for table `vaccines`
--

CREATE TABLE `vaccines` (
  `vaccine_id` int(10) UNSIGNED NOT NULL,
  `vaccine_name` varchar(100) NOT NULL,
  `description` varchar(255) DEFAULT NULL,
  `recommended_age_days` int(10) UNSIGNED NOT NULL DEFAULT 0,
  `availability` enum('Available','Unavailable') NOT NULL DEFAULT 'Available',
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `vaccines`
--

INSERT INTO `vaccines` (`vaccine_id`, `vaccine_name`, `description`, `recommended_age_days`, `availability`, `updated_at`) VALUES
(1, 'BCG', 'Protects against tuberculosis', 0, 'Available', '2026-10-27 13:19:30'),
(2, 'Hepatitis B', 'Protects against hepatitis B', 0, 'Available', '2026-10-27 13:19:30'),
(3, 'OPV (Polio)', 'Oral polio vaccine', 42, 'Available', '2026-10-27 13:19:30'),
(4, 'DPT', 'Diphtheria, pertussis and tetanus', 42, 'Available', '2026-10-27 13:19:30'),
(5, 'Measles / MMR', 'Measles, mumps and rubella', 270, 'Unavailable', '2026-10-27 13:19:30');

-- --------------------------------------------------------

--
-- Stand-in structure for view `v_all_children`
-- (See below for the actual view)
--
CREATE TABLE `v_all_children` (
);

-- --------------------------------------------------------

--
-- Stand-in structure for view `v_hospital_appointments`
-- (See below for the actual view)
--
CREATE TABLE `v_hospital_appointments` (
);

-- --------------------------------------------------------

--
-- Stand-in structure for view `v_pending_requests`
-- (See below for the actual view)
--
CREATE TABLE `v_pending_requests` (
);

-- --------------------------------------------------------

--
-- Stand-in structure for view `v_upcoming_vaccinations`
-- (See below for the actual view)
--
CREATE TABLE `v_upcoming_vaccinations` (
);

-- --------------------------------------------------------

--
-- Stand-in structure for view `v_vaccination_report`
-- (See below for the actual view)
--
CREATE TABLE `v_vaccination_report` (
);

-- --------------------------------------------------------

--
-- Structure for view `v_all_children`
--
DROP TABLE IF EXISTS `v_all_children`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `v_all_children`  AS SELECT `c`.`child_id` AS `child_id`, `c`.`child_name` AS `child_name`, `c`.`date_of_birth` AS `date_of_birth`, `c`.`gender` AS `gender`, `c`.`blood_group` AS `blood_group`, `p`.`parent_id` AS `parent_id`, `p`.`full_name` AS `parent_name`, `p`.`phone` AS `parent_phone`, `p`.`email` AS `parent_email` FROM (`child` `c` join `parent` `p` on(`p`.`parent_id` = `c`.`parent_id`)) ;

-- --------------------------------------------------------

--
-- Structure for view `v_hospital_appointments`
--
DROP TABLE IF EXISTS `v_hospital_appointments`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `v_hospital_appointments`  AS SELECT `a`.`appointment_id` AS `appointment_id`, `a`.`hospital_id` AS `hospital_id`, `a`.`appointment_date` AS `appointment_date`, `a`.`appointment_time` AS `appointment_time`, `c`.`child_name` AS `child_name`, `c`.`date_of_birth` AS `date_of_birth`, `p`.`full_name` AS `parent_name`, `p`.`phone` AS `parent_phone`, `v`.`vaccine_name` AS `vaccine_name`, `a`.`vaccination_status` AS `vaccination_status` FROM (((`appointment` `a` join `child` `c` on(`c`.`child_id` = `a`.`child_id`)) join `parent` `p` on(`p`.`parent_id` = `a`.`parent_id`)) join `vaccine` `v` on(`v`.`vaccine_id` = `a`.`vaccine_id`)) WHERE `a`.`admin_status` = 'Approved' ;

-- --------------------------------------------------------

--
-- Structure for view `v_pending_requests`
--
DROP TABLE IF EXISTS `v_pending_requests`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `v_pending_requests`  AS SELECT `v_vaccination_report`.`appointment_id` AS `appointment_id`, `v_vaccination_report`.`appointment_date` AS `appointment_date`, `v_vaccination_report`.`appointment_time` AS `appointment_time`, `v_vaccination_report`.`child_id` AS `child_id`, `v_vaccination_report`.`child_name` AS `child_name`, `v_vaccination_report`.`parent_id` AS `parent_id`, `v_vaccination_report`.`parent_name` AS `parent_name`, `v_vaccination_report`.`vaccine_name` AS `vaccine_name`, `v_vaccination_report`.`hospital_name` AS `hospital_name`, `v_vaccination_report`.`admin_status` AS `admin_status`, `v_vaccination_report`.`vaccination_status` AS `vaccination_status` FROM `v_vaccination_report` WHERE `v_vaccination_report`.`admin_status` = 'Pending' ;

-- --------------------------------------------------------

--
-- Structure for view `v_upcoming_vaccinations`
--
DROP TABLE IF EXISTS `v_upcoming_vaccinations`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `v_upcoming_vaccinations`  AS SELECT `s`.`schedule_id` AS `schedule_id`, `c`.`child_id` AS `child_id`, `c`.`child_name` AS `child_name`, `v`.`vaccine_name` AS `vaccine_name`, `s`.`due_date` AS `due_date`, `p`.`full_name` AS `parent_name`, `p`.`phone` AS `parent_phone` FROM (((`vaccination_schedule` `s` join `child` `c` on(`c`.`child_id` = `s`.`child_id`)) join `parent` `p` on(`p`.`parent_id` = `c`.`parent_id`)) join `vaccine` `v` on(`v`.`vaccine_id` = `s`.`vaccine_id`)) WHERE `s`.`status` = 'Upcoming' AND `s`.`due_date` >= curdate() ORDER BY `s`.`due_date` ASC ;

-- --------------------------------------------------------

--
-- Structure for view `v_vaccination_report`
--
DROP TABLE IF EXISTS `v_vaccination_report`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `v_vaccination_report`  AS SELECT `a`.`appointment_id` AS `appointment_id`, `a`.`appointment_date` AS `appointment_date`, `a`.`appointment_time` AS `appointment_time`, `c`.`child_id` AS `child_id`, `c`.`child_name` AS `child_name`, `p`.`parent_id` AS `parent_id`, `p`.`full_name` AS `parent_name`, `v`.`vaccine_name` AS `vaccine_name`, `h`.`hospital_name` AS `hospital_name`, `a`.`admin_status` AS `admin_status`, `a`.`vaccination_status` AS `vaccination_status` FROM ((((`appointment` `a` join `child` `c` on(`c`.`child_id` = `a`.`child_id`)) join `parent` `p` on(`p`.`parent_id` = `a`.`parent_id`)) join `vaccine` `v` on(`v`.`vaccine_id` = `a`.`vaccine_id`)) join `hospital` `h` on(`h`.`hospital_id` = `a`.`hospital_id`)) ORDER BY `a`.`appointment_date` DESC ;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `appointment`
--
ALTER TABLE `appointment`
  ADD PRIMARY KEY (`appointment_id`),
  ADD KEY `idx_appt_date` (`appointment_date`),
  ADD KEY `idx_appt_status` (`admin_status`,`vaccination_status`),
  ADD KEY `fk_appt_parent` (`parent_id`),
  ADD KEY `fk_appt_child` (`child_id`),
  ADD KEY `fk_appt_hospital` (`hospital_id`),
  ADD KEY `fk_appt_vaccine` (`vaccine_id`);

--
-- Indexes for table `childs1`
--
ALTER TABLE `childs1`
  ADD PRIMARY KEY (`child_id`);

--
-- Indexes for table `hospitals`
--
ALTER TABLE `hospitals`
  ADD PRIMARY KEY (`hospital_id`),
  ADD UNIQUE KEY `email` (`email`),
  ADD KEY `idx_hospital_location` (`location`);

--
-- Indexes for table `notification`
--
ALTER TABLE `notification`
  ADD PRIMARY KEY (`notification_id`),
  ADD KEY `fk_notif_parent` (`parent_id`),
  ADD KEY `fk_notif_child` (`child_id`);

--
-- Indexes for table `vaccination_schedule`
--
ALTER TABLE `vaccination_schedule`
  ADD PRIMARY KEY (`schedule_id`),
  ADD UNIQUE KEY `uq_child_vaccine` (`child_id`,`vaccine_id`),
  ADD KEY `idx_schedule_due` (`due_date`),
  ADD KEY `fk_sched_vaccine` (`vaccine_id`);

--
-- Indexes for table `vaccines`
--
ALTER TABLE `vaccines`
  ADD PRIMARY KEY (`vaccine_id`),
  ADD UNIQUE KEY `vaccine_name` (`vaccine_name`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `appointment`
--
ALTER TABLE `appointment`
  MODIFY `appointment_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `childs1`
--
ALTER TABLE `childs1`
  MODIFY `child_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `hospitals`
--
ALTER TABLE `hospitals`
  MODIFY `hospital_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `notification`
--
ALTER TABLE `notification`
  MODIFY `notification_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `vaccination_schedule`
--
ALTER TABLE `vaccination_schedule`
  MODIFY `schedule_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `vaccines`
--
ALTER TABLE `vaccines`
  MODIFY `vaccine_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `appointment`
--
ALTER TABLE `appointment`
  ADD CONSTRAINT `fk_appt_child` FOREIGN KEY (`child_id`) REFERENCES `childs` (`child_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_appt_hospital` FOREIGN KEY (`hospital_id`) REFERENCES `hospitals` (`hospital_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_appt_parent` FOREIGN KEY (`parent_id`) REFERENCES `parents` (`parent_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_appt_vaccine` FOREIGN KEY (`vaccine_id`) REFERENCES `vaccines` (`vaccine_id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `notification`
--
ALTER TABLE `notification`
  ADD CONSTRAINT `fk_notif_child` FOREIGN KEY (`child_id`) REFERENCES `childs` (`child_id`) ON DELETE SET NULL ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_notif_parent` FOREIGN KEY (`parent_id`) REFERENCES `parents` (`parent_id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `vaccination_schedule`
--
ALTER TABLE `vaccination_schedule`
  ADD CONSTRAINT `fk_sched_child` FOREIGN KEY (`child_id`) REFERENCES `childs` (`child_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_sched_vaccine` FOREIGN KEY (`vaccine_id`) REFERENCES `vaccines` (`vaccine_id`) ON DELETE CASCADE ON UPDATE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
