//
//  EZJUserDataCollector.m
//  Pods
//
//  Created by Apple on 15/12/21.
//
//

#import "EZJUserDataCollector.h"
#import "EZJUserBehavior.h"
#import "NSString+Hash.h"
#import "NSString+Path.h"
#import "MFZLibUtils.h"
#import "UncaughtExceptionHandler.h"
#import "Reachability.h"
#import "EZRequestAndDataMapping.h"
#import "EZCollectionDefault.h"

#define IS_NOT_EMPTY(string) (string !=nil && ![string isKindOfClass:[NSNull class]] && ![string isEqualToString:@""] && ![string isEqualToString:@"(null)"])
NSString * const kCrashCollectNotication = @"crashCollectNotication";

@interface EZJUserDataCollector()

@property (nonatomic,copy) NSString *serverHost;
@property (nonatomic,assign) uint16_t serverPort;
@property (nonatomic,weak) NSTimer *writeTimer;
@property (nonatomic,strong) NSArray<NSString *> *tableNames;
@property (nonatomic,strong) NSMutableDictionary *sendDict;
@property (nonatomic,strong) NSMutableDictionary *dictM; // 记录每张表的最后一条数据的id
@property (nonatomic,copy) NSString *behaviorTableName;

@property (nonatomic,strong) EZJUserBehavior *behavior;
@property (nonatomic,assign) NSInteger dataTableId; // 业务表最后一条id
@property(strong) Reachability * internetConnectionReach;

@end

@implementation EZJUserDataCollector

+ (instancetype)sharedInstance {
    
    static EZJUserDataCollector * instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
        instance.internetConnectionReach = [Reachability reachabilityForInternetConnection];
    });
    return instance;
}

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

// 注销定时器
- (void)cancelTimer {
    self.writeTimer = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

// 写数据
- (void)write {
    
    if ([self.internetConnectionReach isReachable]) {

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
            NSData *dataZip = [self zipData:[strM dataUsingEncoding:NSUTF8StringEncoding]];
            NSData *dataObfus = [self obfuscate:dataZip withKey:@"easyjie"];
            [data appendData:dataObfus];
            
            [self writeData:data completion:^(NSString *success) {
                if (self.completion != nil) {
                    self.completion(success);
                }
            }];
        }
    }
}

- (void)writeData:(NSData *)data completion:(void(^)(NSString *success))completion {
    
    
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:@"http://data.ezjie.cn:81/collect"] cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:20.0];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:data];
    
    NSURLSessionConfiguration *configure = [NSURLSessionConfiguration defaultSessionConfiguration];
    [configure setHTTPAdditionalHeaders:[EZCollectionDefault shareInstance].header];
    [configure setTimeoutIntervalForRequest:20.0];
    [configure setTimeoutIntervalForResource:20.0];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configure];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    NSURLSessionDataTask *sessionDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
            NSError *jsonError = nil;
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data
                                                                options:NSJSONReadingAllowFragments
                                                                  error:&jsonError];
            
            NSString *callback = dic[@"is_success"];
            completion(callback);
            // 开启定时器
            [self writeTime];
            
            if ([callback isEqualToString:@"1"]) {
                //将业务表和行为表的数据删除
                if ([self.dictM count] >0) {
                    int i = [[self.dictM objectForKey:@"behavior_record"] intValue];
                    int j = [[self.dictM objectForKey:@"learning_record"] intValue];
                    if (i != 0) {
                        NSString *deleteBehavior = [NSString stringWithFormat:@"DELETE FROM behavior_record WHERE id <= %d",[[self.dictM objectForKey:@"behavior_record"] intValue]];
                        [self.behavior.queue inTransaction:^(FMDatabase *db, BOOL *rollback) {
                            BOOL flag = [db executeUpdate:deleteBehavior];
                            NSLog(@"删除行为数据：%d",flag);
                        }];
                    }
                    if (j != 0) {
                        NSString *deleteData = [NSString stringWithFormat:@"DELETE FROM learning_record WHERE record_id <= %d",[[self.dictM objectForKey:@"learning_record"] intValue]];
                        [self.queue inTransaction:^(FMDatabase *db, BOOL *rollback) {
                            BOOL flag = [db executeUpdate:deleteData];
                            NSLog(@"删除业务数据：%d",flag);
                        }];
                    }
                    self.dictM = nil;
                    self.sendFlag = NO;
                }
            }
         
        });
    }];
    [sessionDataTask resume];
}

// 压缩数据
- (NSData *)zipData:(NSData *)strData {
    NSData *data = [MFZLibUtils dataUseZLibCompressWithData:strData];
    return data;
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
        if (IS_NOT_EMPTY(self.commonData.app_name)) {
            [commonDataDict setObject:self.commonData.app_name forKey:@"app_name"];
        }else {
            [commonDataDict setObject:@"" forKey:@"app_name"];
        }
        if (IS_NOT_EMPTY(self.commonData.build_number)) {
            [commonDataDict setObject:self.commonData.build_number forKey:@"build_number"];
        }else {
            [commonDataDict setObject:@"" forKey:@"build_number"];
        }
        if (IS_NOT_EMPTY(self.commonData.system)) {
            [commonDataDict setObject:self.commonData.system forKey:@"system"];
        }else {
            [commonDataDict setObject:@"" forKey:@"system"];
        }
        if (IS_NOT_EMPTY(self.commonData.system_version)) {
            [commonDataDict setObject:self.commonData.system_version forKey:@"system_version"];
        }else {
            [commonDataDict setObject:@"" forKey:@"system_version"];
        }
        if (IS_NOT_EMPTY(self.commonData.device)) {
            [commonDataDict setObject:self.commonData.device forKey:@"device"];
        }else {
            [commonDataDict setObject:@"" forKey:@"device"];
        }
        if (IS_NOT_EMPTY(self.commonData.device_token)) {
            [commonDataDict setObject:self.commonData.device_token forKey:@"device_token"];
        }else {
            [commonDataDict setObject:@"" forKey:@"device_token"];
        }
        if (IS_NOT_EMPTY(self.commonData.channel_name)) {
            [commonDataDict setObject:self.commonData.channel_name forKey:@"channel_name"];
        }else {
            [commonDataDict setObject:@"" forKey:@"channel_name"];
        }
        if (IS_NOT_EMPTY(self.commonData.uid)) {
            [commonDataDict setObject:self.commonData.uid forKey:@"uid"];
        }else {
            [commonDataDict setObject:@"" forKey:@"uid"];
        }
        if (IS_NOT_EMPTY(self.commonData.uuid)) {
            [commonDataDict setObject:self.commonData.uuid forKey:@"uuid"];
        }else {
            [commonDataDict setObject:@"" forKey:@"uuid"];
        }
        if (IS_NOT_EMPTY(self.commonData.uuid)) {
            [commonDataDict setObject:self.commonData.uuid forKey:@"umeng_open_id"];
        }else {
            [commonDataDict setObject:@"" forKey:@"umeng_open_id"];
        }
        if (IS_NOT_EMPTY(self.commonData.login_key)) {
            [commonDataDict setObject:self.commonData.login_key forKey:@"login_key"];
        }else {
            [commonDataDict setObject:@"" forKey:@"login_key"];
        }
        if (IS_NOT_EMPTY(self.commonData.device_id)) {
            [commonDataDict setObject:self.commonData.device_id forKey:@"device_id"];
        }else {
            [commonDataDict setObject:@"" forKey:@"device_id"];
        }
        
        // android 用
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
            
            NSString *str = [frs stringForColumn:@"parameters"];
            NSData *jsonDa = [str dataUsingEncoding: NSUTF8StringEncoding];
            
            NSDictionary *testDict = [NSJSONSerialization JSONObjectWithData:jsonDa options:NSJSONReadingMutableContainers error:nil];
            
            [dict setObject:testDict forKey:@"parameters"];
       
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

- (EZJUserBehavior *)behavior {
    if (!_behavior) {
        _behavior = [EZJUserBehavior sharedInstance];
    }
    return _behavior;
}

@end
