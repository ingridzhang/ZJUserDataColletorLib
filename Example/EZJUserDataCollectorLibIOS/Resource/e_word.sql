/*
Navicat MySQL Data Transfer

Source Server         : 180test
Source Server Version : 50542
Source Host           : 123.57.78.180:3306
Source Database       : easy_word

Target Server Type    : MYSQL
Target Server Version : 50542
File Encoding         : 65001

Date: 2015-06-03 15:03:56
*/

-- ----------------------------
-- Table structure for e_word
DROP TABLE IF EXISTS `e_word`;
-- ----------------------------

CREATE TABLE IF NOT EXISTS `e_word` (
  `word_id` INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
  `word` char(100) NOT NULL,
  `phonetic` char(50) DEFAULT NULL,
  `en_phonetic` char(50) DEFAULT NULL,
  `level` tinyint(3) DEFAULT NULL,
  `create_time` datetime DEFAULT NULL,
  `update_time` timestamp DEFAULT NULL,
);


