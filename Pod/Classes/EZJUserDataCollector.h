//
//  EZJUserDataCollector.h
//  Pods
//
//  Created by Apple on 15/12/21.
//
//

#import <Foundation/Foundation.h>
#import "FMDB.h"
#import "EZJUserCommonData.h"

@interface EZJUserDataCollector : NSObject

@property (nonatomic,copy) NSString *dbPath; // 业务数据库路径
@property (nonatomic,strong) FMDatabaseQueue *queue;
@property (nonatomic,strong) EZJUserCommonData *commonData;
@property (nonatomic,copy) NSString *dataTableName; // 注册业务数据表名
@property (nonatomic, copy) void(^completion)(NSString *success);
@property (nonatomic,assign) BOOL sendFlag;
+ (instancetype)sharedInstance;
// 调用此方法开启定时任务
- (void)writeTime;

- (void)write;
// 加密/解密
- (NSData *)obfuscate:(NSData *)data withKey:(NSString *)key;
@end
