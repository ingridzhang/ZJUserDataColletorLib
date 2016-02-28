//
//  ZJUserBehavior.h
//  Pods
//
//  Created by apple on 15/12/12.
//
//

#import <Foundation/Foundation.h>

@class ZJBehavior,FMDatabaseQueue,ZJUserPage;

@interface ZJUserBehavior : NSObject

@property (nonatomic,copy) NSString *behaviorTable;
@property (nonatomic,strong) Class mobClick; // 友盟MobClick类
@property (nonatomic,strong) FMDatabaseQueue *queue;
@property (nonatomic,assign) NSInteger behaviorId;

+ (instancetype)sharedInstance;

// click事件行为
- (void)event:(NSString *)eventId;
- (void)event:(NSString *)eventId attributes:(NSDictionary *)attributes;

// 页面跳转行为 需要在每个View中配对调用如下两个方法
//- (void)beginLogPageView:(NSString *)pageName;
//- (void)endLogPageView:(NSString *)pageName;
- (NSArray *)selectBehavior;

@end
