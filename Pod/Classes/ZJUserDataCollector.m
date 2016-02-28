//
//  EZJUserDataCollector.m
//  Pods
//
//  Created by Apple on 15/12/21.
//
//

#import "ZJUserDataCollector.h"
#import "ZJUserBehavior.h"
#import "NSString+Hash.h"
#import "NSString+Path.h"

NSString * const kCrashCollectNotication = @"crashCollectNotication";

@interface ZJUserDataCollector()

@property (nonatomic,copy) NSString *serverHost;
@property (nonatomic,assign) uint16_t serverPort;
@property (nonatomic,weak) NSTimer *writeTimer;
@property (nonatomic,strong) NSArray<NSString *> *tableNames;
@property (nonatomic,strong) NSMutableDictionary *sendDict;
@property (nonatomic,strong) NSMutableDictionary *dictM; // 记录每张表的最后一条数据的id
@property (nonatomic,copy) NSString *behaviorTableName;
@property (nonatomic,assign) BOOL sendFlag;
@property (nonatomic,strong) ZJUserBehavior *behavior;
@property (nonatomic,assign) NSInteger dataTableId; // 业务表最后一条id

@end

@implementation ZJUserDataCollector

+ (instancetype)sharedInstance {
    
    static ZJUserDataCollector * instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

//#pragma mark EZJSocketConnection method
//- (void)openConnection
//{
//    [self closeConnection];
//    self.socketConn.delegate = self;
//    [self.socketConn connectWithHost:self.serverHost port:self.serverPort];
//}
//
//- (void)closeConnection
//{
//    if (_socketConn) {
//        self.socketConn.delegate = nil;
//        [self.socketConn disconnect];
//        self.socketConn = nil;
//    }
//}

#pragma mark ZJSocketConnectionDelegate method

//- (void)didReceiveData:(NSData *)data tag:(long)tag
//{
//    NSString *callback = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//    if ([callback isEqualToString:@"success\n\n\n\n\n"]) {
//        //将业务表和行为表的数据删除
//        if ([self.dictM count] >0) {
//            int i = [[self.dictM objectForKey:@"behavior_record"] intValue];
//            int j = [[self.dictM objectForKey:@"learning_record"] intValue];
//            if (i != 0) {
//                NSString *deleteBehavior = [NSString stringWithFormat:@"DELETE FROM behavior_record WHERE id <= %d",[[self.dictM objectForKey:@"behavior_record"] intValue]];
//                [self.behavior.queue inTransaction:^(FMDatabase *db, BOOL *rollback) {
//                    BOOL flag = [db executeUpdate:deleteBehavior];
//                    NSLog(@"删除行为数据：%d",flag);
//                }];
//            }
//            if (j != 0) {
//                NSString *deleteData = [NSString stringWithFormat:@"DELETE FROM learning_record WHERE record_id <= %d",[[self.dictM objectForKey:@"learning_record"] intValue]];
//                [self.queue inTransaction:^(FMDatabase *db, BOOL *rollback) {
//                    BOOL flag = [db executeUpdate:deleteData];
//                    NSLog(@"删除业务数据：%d",flag);
//                }];
//            }
//            self.dictM = nil;
//            self.sendFlag = NO;
//        }
//    }
//}
//
//- (void)didConnectToHost:(NSString *)host port:(uint16_t)port {
//    NSLog(@"%s",__func__);
//}
//
//- (void)didDisconnectWithError:(NSError *)error {
//    NSLog(@"%s---%@",__func__,error.description);
//}

#pragma mark 定期查询数据表
- (void)userDataRegister{
    if (self.dataTableName != nil) {
        // 查询业务表
        NSString *sql = [NSString stringWithFormat:@"select * from %@ limit 10",self.dataTableName];
        NSArray *dataArray = (NSArray *)[self selectWithSql:sql];
        if (![dataArray count] == 0) {
           self.sendFlag = YES;
           [self.sendDict setObject:dataArray forKeyedSubscript:self.dataTableName];
        }
    }
}

// 定时器
- (void)writeTime {
    self.writeTimer = [NSTimer scheduledTimerWithTimeInterval:30.0f target:self selector:@selector(write) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.writeTimer forMode:NSRunLoopCommonModes];
    // 收集bug
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(crashCollect:) name:kCrashCollectNotication object:nil];
}
// bug收集
- (void)crashCollect:(NSNotification *)n {
    NSString *name = [n.userInfo objectForKey:@"name"];
    NSString *reason = [n.userInfo objectForKey:@"reson"];
    NSString *info = [n.userInfo objectForKey:@"info"];
    NSLog(@"[crashCollect]name--%@,reason--%@,info--%@",name,reason,info);
}

// 写数据
- (void)write {
    [self appCommonData];
    [self userDataRegister];
    [self selectBehavior];
    
    if (self.sendFlag) {
        NSError *parseError = nil;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self.sendDict options:NSJSONWritingPrettyPrinted error:&parseError];
        if (parseError != nil) {
            NSLog(@"%@",parseError.description);
        }
        NSString *parameterStr =[[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        parameterStr = [parameterStr stringByReplacingOccurrencesOfString:@"\n " withString:@""];
        parameterStr = [parameterStr stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        NSMutableString *strM = [[NSMutableString alloc] init];
        [strM appendString:parameterStr];
        
        NSMutableData *data = [NSMutableData data];
        [data appendData:[self md5Str]];
        NSData *dataZip = [self zipData:[strM dataUsingEncoding:NSUTF8StringEncoding]];
        NSData *dataObfus = [self obfuscate:dataZip withKey:@"easyjie"];
        [data appendData:dataObfus];
        [data appendData:[@"\n\n\n\n\n" dataUsingEncoding:NSUTF8StringEncoding]];
        [self writeData:data];
    }
}

- (void)writeData:(NSData *)data {
//    [self.socketConn writeData:data timeout:-1 tag:0];
}

// 压缩数据
- (NSData *)zipData:(NSData *)strData {
//    NSData *data = [MFZLibUtils dataUseZLibCompressWithData:strData];
//    return data;
    return nil;
}

// 加密
- (NSData *)obfuscate:(NSData *)data withKey:(NSString *)key
{
    NSMutableData *result = [data mutableCopy];
    // Get pointer to data to obfuscate
    char *dataPtr = (char *) [result mutableBytes];
    // Get pointer to key data
    char *keyData = (char *) [[key dataUsingEncoding:NSUTF8StringEncoding] bytes];
    // Points to each char in sequence in the key
    char *keyPtr = keyData;
    int keyIndex = 0;
    // For each character in data, xor with current value in key
    for (int x = 0; x < [data length]; x++)
    {
        // Replace current character in data with
        // current character xor'd with current key value.
        // Bump each pointer to the next character
        *dataPtr = *dataPtr ^ *keyPtr;
        dataPtr++;
        keyPtr++;
        // If at end of key data, reset count and
        // set key pointer back to start of key value
        if (++keyIndex == [key length]){
            keyIndex = 0, keyPtr = keyData;
        }
    }
    return result;
}

- (NSData *)md5Str {
    NSString *str = @"";
    NSString *salt = @"e_gate";
    str = [[salt stringByAppendingString:@"sendLocalData"] stringByAppendingString:salt].md5String;
    NSRange range = NSMakeRange(8,16);
    NSString *subStr = [str substringWithRange:range];
    NSLog(@"%@",subStr);
    return [subStr dataUsingEncoding:NSUTF8StringEncoding];
}

- (NSString *)base64Encode:(NSString *)string {
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
    return [data base64EncodedStringWithOptions:0];
}

// 查询行为表
- (void)selectBehavior {
    NSArray *behaviorArray = (NSArray *)[self.behavior selectBehavior];
    if (![behaviorArray count] == 0) {
        self.sendFlag = YES;
        [self.sendDict setObject:behaviorArray forKeyedSubscript:self.behavior.behaviorTable];
        // 记录查出的最后一条数据的id
//        [self.dictM setObject:[[behaviorArray lastObject] objectForKey:@"id"] forKey:self.behavior.behaviorTable];
        [self.dictM setObject:@(self.behavior.behaviorId) forKey:self.behavior.behaviorTable];
    }
}

// 用户通用属性
- (void)appCommonData {
    NSMutableDictionary *commonDataDict = [NSMutableDictionary dictionary];
    if (self.commonData != nil) {
        if (![self.commonData.app_name isEqual:@""]) {
            [commonDataDict setObject:self.commonData.app_name forKey:@"app_name"];
        }else {
            [commonDataDict setObject:@"" forKey:@"app_name"];
        }
        if (![self.commonData.build_number isEqual:@""]) {
            [commonDataDict setObject:self.commonData.build_number forKey:@"build_number"];
        }else {
            [commonDataDict setObject:@"" forKey:@"build_number"];
        }
        if (![self.commonData.system isEqual:@""]) {
            [commonDataDict setObject:self.commonData.system forKey:@"system"];
        }else {
            [commonDataDict setObject:@"" forKey:@"system"];
        }
        if (![self.commonData.system_version isEqual:@""]) {
            [commonDataDict setObject:self.commonData.system_version forKey:@"system_version"];
        }else {
            [commonDataDict setObject:@"" forKey:@"system_version"];
        }
        if (![self.commonData.device isEqual:@""]) {
            [commonDataDict setObject:self.commonData.device forKey:@"device"];
        }else {
            [commonDataDict setObject:@"" forKey:@"device"];
        }
        if (![self.commonData.device_token isEqual:@""]) {
            [commonDataDict setObject:self.commonData.device_token forKey:@"device_token"];
        }else {
            [commonDataDict setObject:@"" forKey:@"device_token"];
        }
        if (![self.commonData.channel_name isEqual:@""]) {
            [commonDataDict setObject:self.commonData.channel_name forKey:@"channel_name"];
        }else {
            [commonDataDict setObject:@"" forKey:@"channel_name"];
        }
        if (![self.commonData.uid isEqual:@""]) {
            [commonDataDict setObject:self.commonData.uid forKey:@"uid"];
        }else {
            [commonDataDict setObject:@"" forKey:@"uid"];
        }
        if (![self.commonData.uuid isEqual:@""]) {
            [commonDataDict setObject:self.commonData.uuid forKey:@"uuid"];
        }else {
            [commonDataDict setObject:@"" forKey:@"uuid"];
        }
        if (![self.commonData.uuid isEqual:@""]) {
            [commonDataDict setObject:self.commonData.uuid forKey:@"umeng_open_id"];
        }else {
            [commonDataDict setObject:@"" forKey:@"umeng_open_id"];
        }
        
        // android 用
        [commonDataDict setObject:self.commonData.device_id forKey:@"device_id"];
        [commonDataDict setObject:self.commonData.device_cid forKey:@"device_cid"];
        [commonDataDict setObject:self.commonData.android_cid forKey:@"android_cid"];
        [commonDataDict setObject:self.commonData.android_md5_sign forKey:@"android_md5_sign"];
        
        [self.sendDict setObject:commonDataDict forKey:@"headers"];
    }else {
        [self.sendDict setObject:@"" forKey:@"headers"];
    }
}

- (NSArray *)selectWithSql:(NSString *)sql {
    __block NSMutableArray *array = [NSMutableArray array];
    [self.queue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        FMResultSet *frs = [db executeQuery:sql];
        while ([frs next]) {
            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
//            [dict setObject:@([frs intForColumn:@"word_id"]) forKey:@"word_id"];
            self.dataTableId = [frs intForColumn:@"record_id"];
            [dict setObject:[frs stringForColumn:@"uid"] forKey:@"uid"];
            [dict setObject:[frs stringForColumn:@"type"] forKey:@"type"];
            [dict setObject:[frs stringForColumn:@"parameters"] forKey:@"parameters"];
            [dict setObject:[frs stringForColumn:@"start_time"] forKey:@"start_time"];
            [dict setObject:[frs stringForColumn:@"finish_time"] forKey:@"finish_time"];
            [array addObject:dict];
        }
        [frs close];
    }];
    [self.dictM setObject:@(self.dataTableId) forKey:self.dataTableName];
    return array.copy;
}

#pragma mark 懒加载
//- (EZJSocketConnection *)socketConn {
//    if (!_socketConn) {
////        self.serverHost = @"127.0.0.1";
////        self.serverPort = 1234;
////        self.serverHost = @"192.168.1.74";
////        self.serverPort = 8282;
//        
//        self.serverHost = @"123.57.78.180";
//        self.serverPort = 8282;
//        _socketConn = [[EZJSocketConnection alloc] init];
//    }
//    return _socketConn;
//}

- (FMDatabaseQueue *)queue {
    if (!_queue) {
        _queue = [FMDatabaseQueue databaseQueueWithPath:self.dbPath];
    }
    return _queue;
}

- (NSMutableDictionary *)dictM {
    if (!_dictM) {
        _dictM = [NSMutableDictionary dictionary];
    }
    return _dictM;
}

- (NSMutableDictionary *)sendDict {
    if (!_sendDict) {
        _sendDict = [NSMutableDictionary dictionary];
    }
    return _sendDict;
}

- (ZJUserBehavior *)behavior {
    if (!_behavior) {
        _behavior = [ZJUserBehavior sharedInstance];
    }
    return _behavior;
}

@end
