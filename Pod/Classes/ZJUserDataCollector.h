//
//  ZJUserDataCollector.h
//  Pods
//
//  Created by Apple on 15/12/21.
//
//

#import <Foundation/Foundation.h>
#import "FMDB.h"
#import "ZJUserCommonData.h"

@interface ZJUserDataCollector : NSObject

@property (nonatomic,copy) NSString *dbPath; // 业务数据库路径
@property (nonatomic,strong) FMDatabaseQueue *queue;
@property (nonatomic,strong) ZJUserCommonData *commonData;
@property (nonatomic,copy) NSString *dataTableName; // 注册业务数据表名

+ (instancetype)sharedInstance;
// 调用此方法开启定时任务
- (void)writeTime;

@end
