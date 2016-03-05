-- 用户信息集合数据表 --
CREATE TABLE IF NOT EXISTS "T_collectorData" (
"dataId" integer NOT NULL,
"userDataString" TEXT,
"userBehaviorString" TEXT,
"createTime" TEXT DEFAULT (datetime('now','localtime')),
PRIMARY KEY("dataId")
);


CREATE TABLE IF NOT EXISTS `e_word` (
`word_id` INTEGER,
`word` varchar(100) NOT NULL,
`phonetic` varchar(50) DEFAULT NULL,
`en_phonetic` varchar(50) DEFAULT NULL,
`level` tinyint(3) DEFAULT NULL,
`create_time` datetime DEFAULT NULL,
`update_time` timestamp DEFAULT NULL
)




CREATE TABLE `learning_record` (
`id` int UNSIGNED NOT NULL AUTO_INCREMENT,
`uid` int NOT NULL,
`type` varchar(20) NOT NULL COMMENT '学习类型:reading、listening、voice、word...。应用间共享一张类型定义表，服务器端根据类型决定数据如何被处理。',
`data` varchar(1000) NULL COMMENT '提交的记录数据，json格式。json对象的内容由type决定。',
`start_time` datetime NULL COMMENT '本条学习记录的开始学习时间。如果是一组学习（例如TPO模拟练习），这里记录的是整体的开始时间，每道题目开始时间在data中记录。end_time也是如此。',
`end_time` datetime NULL COMMENT '本条学习记录结束学习的时间',
`create_time` timestamp NOT NULL COMMENT '记录插入数据库的时间',
PRIMARY KEY (`id`)
);

CREATE TABLE `behavior_record` (
`id` int UNSIGNED NOT NULL AUTO_INCREMENT,
`uid` int UNSIGNED NOT NULL,
`event_id` varchar(40) NOT NULL COMMENT '事件的编码，类似友盟的字符串定义。',
`params` varchar(40) NULL COMMENT '行为数据相关的参数，json格式，key-value。由事件自己根据需要定义。例如，浏览帖子传递item_id，阅读文章传tpo_id。参数值只能是离散值，即在分析时会被当做groupby的条件处理。',
`happen_time` datetime NOT NULL COMMENT '行为产生的时间',
`create_time` timestamp NOT NULL,
PRIMARY KEY (`id`)
);