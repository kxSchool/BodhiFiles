/*
SQLyog Enterprise - MySQL GUI v6.06
Host - 5.0.51a-3ubuntu5.1 : Database - jackydata
*********************************************************************
Server version : 5.0.51a-3ubuntu5.1
*/

/*!40101 SET NAMES utf8 */;

/*!40101 SET SQL_MODE=''*/;

create database if not exists `jackydata`;

USE `jackydata`;

/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;

/*Table structure for table `department` */

DROP TABLE IF EXISTS `department`;

CREATE TABLE `department` (
  `id` int(11) NOT NULL auto_increment,
  `deptname` varchar(50) collate utf8_unicode_ci default NULL,
  `createtime` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=6 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

/*Table structure for table `popedom` */

DROP TABLE IF EXISTS `popedom`;

CREATE TABLE `popedom` (
  `id` int(11) NOT NULL auto_increment,
  `userno` varchar(50) collate utf8_unicode_ci default NULL,
  `variable` varchar(100) collate utf8_unicode_ci default NULL,
  `popedom` int(11) default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=608 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

/*Table structure for table `popedomgroup` */

DROP TABLE IF EXISTS `popedomgroup`;

CREATE TABLE `popedomgroup` (
  `id` int(11) NOT NULL auto_increment,
  `groupname` varchar(100) collate utf8_unicode_ci default NULL,
  `variable` varchar(100) collate utf8_unicode_ci default NULL,
  `popedom` int(11) default NULL,
  `createdate` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=508 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

/*Table structure for table `tbdata` */

DROP TABLE IF EXISTS `tbdata`;

CREATE TABLE `tbdata` (
  `id` int(11) NOT NULL auto_increment,
  `filetitle` varchar(100) collate utf8_unicode_ci default NULL,
  `fileurl` varchar(200) collate utf8_unicode_ci default NULL,
  `description` mediumtext collate utf8_unicode_ci,
  `filesizes` decimal(19,0) default NULL,
  `uptime` datetime default NULL,
  `userno` varchar(50) collate utf8_unicode_ci default NULL,
  `popedom` int(11) default NULL,
  `type_id` int(11) default NULL,
  `sharetime` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=245 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

/*Table structure for table `tbdataoperatelog` */

DROP TABLE IF EXISTS `tbdataoperatelog`;

CREATE TABLE `tbdataoperatelog` (
  `id` int(11) NOT NULL auto_increment,
  `opt_username` varchar(50) collate utf8_unicode_ci default NULL,
  `opt_userdept` varchar(50) collate utf8_unicode_ci default NULL,
  `opt_time` datetime default NULL,
  `data_title` varchar(100) collate utf8_unicode_ci default NULL,
  `data_url` varchar(100) collate utf8_unicode_ci default NULL,
  `data_ownername` varchar(30) collate utf8_unicode_ci default NULL,
  `data_ownerdept` varchar(50) collate utf8_unicode_ci default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=131 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

/*Table structure for table `tbdatarecycle` */

DROP TABLE IF EXISTS `tbdatarecycle`;

CREATE TABLE `tbdatarecycle` (
  `id` int(11) NOT NULL auto_increment,
  `filetitle` varchar(100) collate utf8_unicode_ci default NULL,
  `fileurl` varchar(200) collate utf8_unicode_ci default NULL,
  `description` mediumtext collate utf8_unicode_ci,
  `filesizes` decimal(19,0) default NULL,
  `uptime` datetime default NULL,
  `userno` varchar(50) collate utf8_unicode_ci default NULL,
  `popedom` int(11) default NULL,
  `type_id` int(11) default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=6 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

/*Table structure for table `tbdatatype` */

DROP TABLE IF EXISTS `tbdatatype`;

CREATE TABLE `tbdatatype` (
  `id` int(11) NOT NULL auto_increment,
  `userno` varchar(50) collate utf8_unicode_ci default NULL,
  `name` varchar(50) collate utf8_unicode_ci default NULL,
  `createdate` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=16 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

/*Table structure for table `tbdeldata` */

DROP TABLE IF EXISTS `tbdeldata`;

CREATE TABLE `tbdeldata` (
  `id` int(11) NOT NULL auto_increment,
  `filetitle` varchar(100) collate utf8_unicode_ci default NULL,
  `fileurl` varchar(200) collate utf8_unicode_ci default NULL,
  `description` mediumtext collate utf8_unicode_ci,
  `filesizes` decimal(19,0) default NULL,
  `uptime` datetime default NULL,
  `userno` varchar(50) collate utf8_unicode_ci default NULL,
  `popedom` int(11) default NULL,
  `type_id` int(11) default NULL,
  `deletetime` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=22 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

/*Table structure for table `tbexcel` */

DROP TABLE IF EXISTS `tbexcel`;

CREATE TABLE `tbexcel` (
  `id` int(11) NOT NULL auto_increment,
  `filetitle` varchar(100) collate utf8_unicode_ci default NULL,
  `fileurl` varchar(200) collate utf8_unicode_ci default NULL,
  `description` mediumtext collate utf8_unicode_ci,
  `uptime` datetime default NULL,
  `userno` varchar(50) collate utf8_unicode_ci default NULL,
  `isdelete` varchar(1) collate utf8_unicode_ci default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=16 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

/*Table structure for table `tbloginlog` */

DROP TABLE IF EXISTS `tbloginlog`;

CREATE TABLE `tbloginlog` (
  `id` int(11) NOT NULL auto_increment,
  `loginurl` varchar(100) collate utf8_unicode_ci default NULL,
  `loginname` varchar(50) collate utf8_unicode_ci default NULL,
  `loginuserid` varchar(50) collate utf8_unicode_ci default NULL,
  `logintime` datetime default NULL,
  `ip` varchar(50) collate utf8_unicode_ci default NULL,
  `browser` varchar(50) collate utf8_unicode_ci default NULL,
  `os` varchar(50) collate utf8_unicode_ci default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=1068 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

/*Table structure for table `tbnews` */

DROP TABLE IF EXISTS `tbnews`;

CREATE TABLE `tbnews` (
  `id` int(11) NOT NULL auto_increment,
  `news_title` varchar(100) collate utf8_unicode_ci default NULL,
  `content` mediumtext collate utf8_unicode_ci,
  `type_id` int(11) default NULL,
  `createtime` datetime default NULL,
  `userno` varchar(50) collate utf8_unicode_ci default NULL,
  `isdelete` int(11) default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=48 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

/*Table structure for table `tbnewstype` */

DROP TABLE IF EXISTS `tbnewstype`;

CREATE TABLE `tbnewstype` (
  `id` int(11) NOT NULL auto_increment,
  `typename` varchar(50) collate utf8_unicode_ci default NULL,
  `createtime` datetime default NULL,
  `ispublic` varchar(1) collate utf8_unicode_ci default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=15 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

/*Table structure for table `tbsystem` */

DROP TABLE IF EXISTS `tbsystem`;

CREATE TABLE `tbsystem` (
  `id` int(11) NOT NULL auto_increment,
  `variable` varchar(150) collate utf8_unicode_ci default NULL,
  `sencondvalue` varchar(200) collate utf8_unicode_ci default NULL,
  `orderbysencond` datetime default NULL,
  `parentvalue` varchar(200) collate utf8_unicode_ci default NULL,
  `orderbyparent` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=70 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

/*Table structure for table `tbuser` */

DROP TABLE IF EXISTS `tbuser`;

CREATE TABLE `tbuser` (
  `id` int(11) NOT NULL auto_increment,
  `UserNo` varchar(50) collate utf8_unicode_ci default NULL,
  `UserID` varchar(20) collate utf8_unicode_ci default NULL,
  `PassWord` varchar(20) collate utf8_unicode_ci default NULL,
  `usergrade` varchar(50) collate utf8_unicode_ci default NULL,
  `popedomgroup` varchar(50) collate utf8_unicode_ci default NULL,
  `UserName` varchar(30) collate utf8_unicode_ci default NULL,
  `dept_id` int(11) default NULL,
  `CreateDate` datetime default NULL,
  `isdelete` int(11) default NULL,
  `online` datetime default NULL,
  `sex` varchar(1) collate utf8_unicode_ci default NULL,
  `email` varchar(200) collate utf8_unicode_ci default NULL,
  `phone` varchar(100) collate utf8_unicode_ci default NULL,
  `faxnum` varchar(100) collate utf8_unicode_ci default NULL,
  `mobilephone` varchar(100) collate utf8_unicode_ci default NULL,
  `msn` varchar(50) collate utf8_unicode_ci default NULL,
  `qq` varchar(50) collate utf8_unicode_ci default NULL,
  `postalcode` varchar(20) collate utf8_unicode_ci default NULL,
  `address` mediumtext collate utf8_unicode_ci,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=29 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
