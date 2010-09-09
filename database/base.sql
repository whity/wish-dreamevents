-- phpMyAdmin SQL Dump
-- version 2.11.8.1deb5+lenny4
-- http://www.phpmyadmin.net
--
-- Host: localhost
-- Generation Time: Sep 05, 2010 at 04:40 PM
-- Server version: 5.0.51
-- PHP Version: 5.2.6-1+lenny8

SET SQL_MODE="NO_AUTO_VALUE_ON_ZERO";

SET AUTOCOMMIT=0;
START TRANSACTION;

--
-- Database: `wishdreamevents`
--
CREATE DATABASE `wishdreamevents` DEFAULT CHARACTER SET utf8 COLLATE utf8_unicode_ci;
USE `wishdreamevents`;

-- --------------------------------------------------------

--
-- Table structure for table `rack_session_data_mapper_sessions`
--

CREATE TABLE IF NOT EXISTS `rack_session_data_mapper_sessions` (
  `id` int(11) NOT NULL auto_increment,
  `sid` varchar(72) collate utf8_unicode_ci NOT NULL,
  `data_object` blob,
  PRIMARY KEY  (`id`),
  UNIQUE KEY `sid` (`sid`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci AUTO_INCREMENT=20 ;

-- --------------------------------------------------------

--
-- Table structure for table `tb_categories`
--

CREATE TABLE IF NOT EXISTS `tb_categories` (
  `id` int(11) NOT NULL auto_increment,
  `parent_id` int(11) default NULL,
  `title` varchar(255) collate utf8_unicode_ci NOT NULL,
  `name` varchar(255) collate utf8_unicode_ci NOT NULL,
  `path` varchar(5000) collate utf8_unicode_ci NOT NULL,
  PRIMARY KEY  (`id`),
  KEY `parent_id` (`parent_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci AUTO_INCREMENT=2 ;

-- --------------------------------------------------------

--
-- Table structure for table `tb_categories_contents`
--

CREATE TABLE IF NOT EXISTS `tb_categories_contents` (
  `category_id` int(11) NOT NULL,
  `content_id` int(11) NOT NULL,
  `weight` int(11) NOT NULL,
  PRIMARY KEY  (`category_id`,`content_id`),
  KEY `content_id` (`content_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `tb_comments_path`
--

CREATE TABLE IF NOT EXISTS `tb_comments_path` (
  `comment_id` int(11) NOT NULL,
  `value` varchar(5000) collate utf8_unicode_ci NOT NULL,
  PRIMARY KEY  (`comment_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `tb_content_comments`
--

CREATE TABLE IF NOT EXISTS `tb_content_comments` (
  `id` int(11) NOT NULL auto_increment,
  `parent_id` int(11) default NULL,
  `content_id` int(11) NOT NULL,
  `name` varchar(255) collate utf8_unicode_ci NOT NULL,
  `text` text collate utf8_unicode_ci NOT NULL,
  PRIMARY KEY  (`id`),
  KEY `parent_id` (`parent_id`,`content_id`),
  KEY `content_id` (`content_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Table structure for table `tb_content_status_history`
--

CREATE TABLE IF NOT EXISTS `tb_content_status_history` (
  `id` int(11) NOT NULL auto_increment,
  `content_id` int(11) NOT NULL,
  `by` varchar(255) collate utf8_unicode_ci NOT NULL,
  `status` int(11) NOT NULL,
  `date_time` datetime NOT NULL,
  PRIMARY KEY  (`id`),
  KEY `content_id` (`content_id`,`by`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci AUTO_INCREMENT=21 ;

-- --------------------------------------------------------

--
-- Table structure for table `tb_content_types`
--

CREATE TABLE IF NOT EXISTS `tb_content_types` (
  `name` varchar(30) collate utf8_unicode_ci NOT NULL,
  PRIMARY KEY  (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `tb_content_values`
--

CREATE TABLE IF NOT EXISTS `tb_content_values` (
  `id` int(11) NOT NULL auto_increment,
  `content_id` int(11) NOT NULL,
  `name` varchar(30) collate utf8_unicode_ci NOT NULL,
  `value` text collate utf8_unicode_ci,
  PRIMARY KEY  (`id`),
  KEY `content_id` (`content_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci AUTO_INCREMENT=115 ;

-- --------------------------------------------------------

--
-- Table structure for table `tb_contents`
--

CREATE TABLE IF NOT EXISTS `tb_contents` (
  `id` int(11) NOT NULL auto_increment,
  `type_name` varchar(30) collate utf8_unicode_ci NOT NULL,
  `title` varchar(255) collate utf8_unicode_ci NOT NULL,
  `updated_by` varchar(255) collate utf8_unicode_ci NOT NULL,
  `status_by` varchar(255) collate utf8_unicode_ci NOT NULL,
  `status` int(11) NOT NULL,
  `updated` datetime NOT NULL,
  `status_dt` datetime NOT NULL,
  PRIMARY KEY  (`id`),
  KEY `type_name` (`type_name`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci AUTO_INCREMENT=13 ;

-- --------------------------------------------------------

--
-- Table structure for table `tb_users`
--

CREATE TABLE IF NOT EXISTS `tb_users` (
  `id` int(11) NOT NULL auto_increment,
  `name` varchar(255) collate utf8_unicode_ci NOT NULL,
  `login` varchar(10) collate utf8_unicode_ci NOT NULL,
  `password` varchar(10) collate utf8_unicode_ci NOT NULL,
  `email` varchar(255) collate utf8_unicode_ci NOT NULL,
  PRIMARY KEY  (`id`),
  UNIQUE KEY `login` (`login`),
  UNIQUE KEY `email` (`email`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci AUTO_INCREMENT=2 ;

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

--
-- Constraints for table `tb_contents`
--
ALTER TABLE `tb_contents`
  ADD CONSTRAINT `tb_contents_ibfk_1` FOREIGN KEY (`type_name`) REFERENCES `tb_content_types` (`name`);

COMMIT;