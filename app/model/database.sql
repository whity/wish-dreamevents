-- phpMyAdmin SQL Dump
-- version 3.2.2.1deb1
-- http://www.phpmyadmin.net
--
-- Host: localhost
-- Generation Time: Jul 01, 2010 at 11:12 AM
-- Server version: 5.1.37
-- PHP Version: 5.2.10-2ubuntu6.4

SET SQL_MODE="NO_AUTO_VALUE_ON_ZERO";

--
-- Database: `wishdreamevents`
--

-- --------------------------------------------------------

--
-- Table structure for table `tb_categories`
--

CREATE TABLE IF NOT EXISTS `tb_categories` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `parent_id` int(11) DEFAULT NULL,
  `title` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `name` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `path` varchar(5000) COLLATE utf8_unicode_ci NOT NULL,
  PRIMARY KEY (`id`),
  KEY `parent_id` (`parent_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci AUTO_INCREMENT=2 ;

--
-- Dumping data for table `tb_categories`
--

INSERT INTO `tb_categories` (`id`, `parent_id`, `title`, `name`, `path`) VALUES
(1, NULL, 'Blog', 'blog', '/blog/');

-- --------------------------------------------------------

--
-- Table structure for table `tb_categories_contents`
--

CREATE TABLE IF NOT EXISTS `tb_categories_contents` (
  `category_id` int(11) NOT NULL,
  `content_id` int(11) NOT NULL,
  `weight` int(11) NOT NULL,
  PRIMARY KEY (`category_id`,`content_id`),
  KEY `content_id` (`content_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Dumping data for table `tb_categories_contents`
--

INSERT INTO `tb_categories_contents` (`category_id`, `content_id`, `weight`) VALUES
(1, 2, 10),
(1, 3, 10);

-- --------------------------------------------------------

--
-- Table structure for table `tb_comments_path`
--

CREATE TABLE IF NOT EXISTS `tb_comments_path` (
  `comment_id` int(11) NOT NULL,
  `value` varchar(5000) COLLATE utf8_unicode_ci NOT NULL,
  PRIMARY KEY (`comment_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Dumping data for table `tb_comments_path`
--


-- --------------------------------------------------------

--
-- Table structure for table `tb_contents`
--

CREATE TABLE IF NOT EXISTS `tb_contents` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `type_name` varchar(30) COLLATE utf8_unicode_ci NOT NULL,
  `title` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `updated_by` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `updated_date` varchar(10) COLLATE utf8_unicode_ci NOT NULL,
  `updated_time` varchar(8) COLLATE utf8_unicode_ci NOT NULL,
  `status_by` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `status_date` varchar(10) COLLATE utf8_unicode_ci NOT NULL,
  `status_time` varchar(8) COLLATE utf8_unicode_ci NOT NULL,
  `status` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `type_name` (`type_name`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci AUTO_INCREMENT=4 ;

--
-- Dumping data for table `tb_contents`
--

INSERT INTO `tb_contents` (`id`, `type_name`, `title`, `updated_by`, `updated_date`, `updated_time`, `status_by`, `status_date`, `status_time`, `status`) VALUES
(2, 'WDE::Model::Post', 'test content adasd', 'teste', '2010-06-28', '10:19:26', 'teste', '2010-06-28', '10:19:26', 3),
(3, 'WDE::Model::Post', 'sada adad', 'eu', '2010-07-01', '14:00', 'eu', '2010-07-01', '14:00', 3);

-- --------------------------------------------------------

--
-- Table structure for table `tb_content_comments`
--

CREATE TABLE IF NOT EXISTS `tb_content_comments` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `parent_id` int(11) DEFAULT NULL,
  `content_id` int(11) NOT NULL,
  `name` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `text` text COLLATE utf8_unicode_ci NOT NULL,
  PRIMARY KEY (`id`),
  KEY `parent_id` (`parent_id`,`content_id`),
  KEY `content_id` (`content_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci AUTO_INCREMENT=1 ;

--
-- Dumping data for table `tb_content_comments`
--


-- --------------------------------------------------------

--
-- Table structure for table `tb_content_status_history`
--

CREATE TABLE IF NOT EXISTS `tb_content_status_history` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `content_id` int(11) NOT NULL,
  `by` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `date` varchar(10) COLLATE utf8_unicode_ci NOT NULL,
  `time` varchar(8) COLLATE utf8_unicode_ci NOT NULL,
  `status` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `content_id` (`content_id`,`by`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci AUTO_INCREMENT=6 ;

--
-- Dumping data for table `tb_content_status_history`
--

INSERT INTO `tb_content_status_history` (`id`, `content_id`, `by`, `date`, `time`, `status`) VALUES
(1, 2, 'ola', '2010-06-21', '09:59:04', 1),
(2, 2, 'ola', '2010-06-21', '09:59:04', 2),
(3, 2, 'ola', '2010-06-21', '09:59:47', 3),
(4, 2, 'ola', '2010-06-21', '10:00:26', 4),
(5, 2, 'teste', '2010-06-21', '10:00:46', 2);

-- --------------------------------------------------------

--
-- Table structure for table `tb_content_types`
--

CREATE TABLE IF NOT EXISTS `tb_content_types` (
  `name` varchar(30) COLLATE utf8_unicode_ci NOT NULL,
  PRIMARY KEY (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Dumping data for table `tb_content_types`
--

INSERT INTO `tb_content_types` (`name`) VALUES
('post'),
('WDE::Model::Comment'),
('WDE::Model::Post');

-- --------------------------------------------------------

--
-- Table structure for table `tb_content_values`
--

CREATE TABLE IF NOT EXISTS `tb_content_values` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `content_id` int(11) NOT NULL,
  `name` varchar(30) COLLATE utf8_unicode_ci NOT NULL,
  `value` text COLLATE utf8_unicode_ci,
  PRIMARY KEY (`id`),
  KEY `content_id` (`content_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci AUTO_INCREMENT=95 ;

--
-- Dumping data for table `tb_content_values`
--

INSERT INTO `tb_content_values` (`id`, `content_id`, `name`, `value`) VALUES
(93, 2, 'text', 'ada adad ad adads adasd adadad asdasd s fdfg dfgdg dfgdg sfsf wewr weewr sdfsdf sdfsdf wrwre sdfsdf sdfsfwrwer sdfsfsfds sfwrwrsdfsfsd sdfsdf sdfwew'),
(94, 2, 'summary', 'ada adad ad adads adasd adadad asdasd s fdfg  ...');

--
-- Constraints for dumped tables
--

--
-- Constraints for table `tb_categories`
--
ALTER TABLE `tb_categories`
  ADD CONSTRAINT `tb_categories_ibfk_1` FOREIGN KEY (`parent_id`) REFERENCES `tb_categories` (`id`);

--
-- Constraints for table `tb_categories_contents`
--
ALTER TABLE `tb_categories_contents`
  ADD CONSTRAINT `tb_categories_contents_ibfk_1` FOREIGN KEY (`category_id`) REFERENCES `tb_categories` (`id`),
  ADD CONSTRAINT `tb_categories_contents_ibfk_2` FOREIGN KEY (`content_id`) REFERENCES `tb_contents` (`id`);

--
-- Constraints for table `tb_contents`
--
ALTER TABLE `tb_contents`
  ADD CONSTRAINT `tb_contents_ibfk_1` FOREIGN KEY (`type_name`) REFERENCES `tb_content_types` (`name`);

--
-- Constraints for table `tb_content_comments`
--
ALTER TABLE `tb_content_comments`
  ADD CONSTRAINT `tb_content_comments_ibfk_1` FOREIGN KEY (`parent_id`) REFERENCES `tb_content_comments` (`id`),
  ADD CONSTRAINT `tb_content_comments_ibfk_2` FOREIGN KEY (`content_id`) REFERENCES `tb_contents` (`id`);

--
-- Constraints for table `tb_content_status_history`
--
ALTER TABLE `tb_content_status_history`
  ADD CONSTRAINT `tb_content_status_history_ibfk_1` FOREIGN KEY (`content_id`) REFERENCES `tb_contents` (`id`);

--
-- Constraints for table `tb_content_values`
--
ALTER TABLE `tb_content_values`
  ADD CONSTRAINT `tb_content_values_ibfk_1` FOREIGN KEY (`content_id`) REFERENCES `tb_contents` (`id`);
