//
//  EZJBehavior.h
//  Pods
//
//  Created by apple on 15/12/12.
//
//

#import <Foundation/Foundation.h>

@interface EZJBehavior : NSObject

//`id` int UNSIGNED NOT NULL AUTO_INCREMENT,
//`uid` int UNSIGNED NOT NULL,
//`event_id` varchar(40) NOT NULL COMMENT '事件的编码，类似友盟的字符串定义。',
//`params` varchar(40) NULL COMMENT '行为数据相关的参数，json格式，key-value。由事件自己根据需要定义。例如，浏览帖子传递item_id，阅读文章传tpo_id。参数值只能是离散值，即在分析时会被当做groupby的条件处理。',
//`happen_time` datetime NOT NULL COMMENT '行为产生的时间',

@property (nonatomic,copy) NSString *uid; // 用户未登录,字段为0
@property (nonatomic,copy) NSString *event_code;
@property (nonatomic,copy) NSString *parameters;
@property (nonatomic,copy) NSString *happen_time;
@property (nonatomic,copy) NSString *pageName;

@end
