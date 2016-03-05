//
//  EZJUserBehavior.m
//  Pods
//
//  Created by apple on 15/12/12.
//
//

#import "EZJUserBehavior.h"
#import "EZJBehavior.h"
#import "FMDB.h"
#import "NSString+Path.h"

@interface EZJUserBehavior ()

@property (nonatomic,strong) EZJBehavior *behavior;
@property (nonatomic,strong) NSMutableDictionary *dictM;

@end

@implementation EZJUserBehavior

+ (instancetype)sharedInstance {
    static EZJUserBehavior * instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

- (instancetype)init {
    if (self = [super init]) {
        NSString *databaseName = @"easy_behavior.db";
        NSString *path = [databaseName appendDocumentDir];
        NSLog(@"[EZJUserBehavior]---path: %@",path);
        _queue = [FMDatabaseQueue databaseQueueWithPath:path];
        [self createTable];
    }
    return self;
}

- (void)createTable {    
    [self.queue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        BOOL result = NO;
        result = [db executeUpdate:@"CREATE TABLE IF NOT EXISTS behavior_record ("
                  "id integer PRIMARY KEY AUTOINCREMENT NOT NULL,"
                  "uid text NOT NULL,"
                  "event_code text NOT NULL,"
                  "parameters text DEFAULT NULL,"
                  "happen_time text DEFAULT (datetime('now','localtime'))"
                  ");"];
        
        if (result) {
                NSLog(@"创建数据表成功");
        }else {
                NSLog(@"创建数据表失败");
        }
    }];
}

- (EZJBehavior *)behavior {
    if (!_behavior) {
        _behavior = [[EZJBehavior alloc] init];
    }
    return _behavior;
}

- (void)event:(NSString *)eventId {
    SEL eventSelector = @selector(event:);
    if(self.mobClick && [self.mobClick respondsToSelector:eventSelector]){
        [self.mobClick performSelector:eventSelector withObject:eventId];
    }
    self.behavior.event_code = eventId;
    [self saveEvent:self.behavior];
}

- (void)event:(NSString *)eventId attributes:(NSDictionary *)attributes {
    SEL eventSelector = @selector(event:attributes:);
    if(self.mobClick && [self.mobClick respondsToSelector:eventSelector]){
        [self.mobClick performSelector:eventSelector withObject:eventId withObject:attributes];
    }
    self.behavior.event_code = eventId;
    NSData *data = [NSJSONSerialization dataWithJSONObject:attributes options:NSJSONWritingPrettyPrinted error:nil];
    NSString *string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    self.behavior.parameters = string;
    [self saveEvent:self.behavior];
}

+ (void)event:(NSString *)eventId {
    EZJUserBehavior *obj = [EZJUserBehavior sharedInstance];
    [obj event:eventId];
}

+ (void)event:(NSString *)eventId attributes:(NSDictionary *)attributes {
    EZJUserBehavior *obj = [EZJUserBehavior sharedInstance];
    [obj event:eventId attributes:attributes];
}

- (void)beginLogPageView:(NSString *)pageName {
    SEL eventSelector = @selector(beginLogPageView:);
    if(self.mobClick && [self.mobClick respondsToSelector:eventSelector]){
        [self.mobClick performSelector:eventSelector withObject:pageName];
    }
    self.behavior.pageName = pageName;
    [self saveEvent:self.behavior];
}

- (void)endLogPageView:(NSString *)pageName {
    SEL eventSelector = @selector(endLogPageView:);
    if(self.mobClick && [self.mobClick respondsToSelector:eventSelector]){
        [self.mobClick performSelector:eventSelector withObject:pageName];
    }
    self.behavior.pageName = pageName;
    [self saveEvent:self.behavior];
}

+ (void)beginLogPageView:(NSString *)pageName {
    EZJUserBehavior *obj = [EZJUserBehavior sharedInstance];
    [obj beginLogPageView:pageName];
}

+ (void)endLogPageView:(NSString *)pageName {
    EZJUserBehavior *obj = [EZJUserBehavior sharedInstance];
    [obj endLogPageView:pageName];
}

- (BOOL)saveEvent:(EZJBehavior *)ezjBehavior {

    NSString *sql = @"INSERT OR REPLACE INTO behavior_record (uid,event_code, parameters) VALUES (?,?,?);";
    __block BOOL result;
    NSMutableArray *arguments = [[NSMutableArray alloc] init];
    
    ezjBehavior.uid = @"";
    [arguments addObject:ezjBehavior.uid];
    
    if (ezjBehavior.uid != NULL) {
        [arguments addObject:ezjBehavior.uid];
    }
    if (ezjBehavior.event_code != NULL) {
        [arguments addObject:ezjBehavior.event_code];
    }
    if (ezjBehavior.parameters != NULL) {
        [arguments addObject:ezjBehavior.parameters];
    }else {
        [arguments addObject:@""];
    }
    
    [self.queue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        NSLog(@"%@",sql);
        result = [db executeUpdate:sql withArgumentsInArray:arguments];
    }];
    return result;
}

- (NSArray *)selectBehavior {
    NSString *tableName = @"behavior_record";
    self.behaviorTable = tableName;
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM %@;",tableName];
    NSMutableArray *arrayM = [NSMutableArray array];
    [self.queue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        FMResultSet *frs = [db executeQuery:sql];
        while ([frs next]) {
            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
//            [dict setObject:@([frs intForColumn:@"id"]) forKey:@"id"];
            if ([frs stringForColumn:@"uid"] != 0) {
                [dict setObject:[frs stringForColumn:@"uid"] forKey:@"uid"];
            }
            [dict setObject:[frs stringForColumn:@"event_code"] forKey:@"event_code"];
            if ([frs stringForColumn:@"parameters"] != NULL) {
                [dict setObject:[frs stringForColumn:@"parameters"] forKey:@"parameters"];
            }
            [dict setObject:[frs stringForColumn:@"happen_time"] forKey:@"happen_time"];
            [arrayM addObject:dict];
            self.behaviorId = [frs intForColumn:@"id"];
        }
        [frs close];
    }];
    return arrayM.copy;
}

- (FMDatabaseQueue *)queue {
    if (!_queue) {
        NSString *databaseName = @"easy_behavior.db";
        NSString *dbPath = [databaseName appendDocumentDir];
        NSLog(@"%@",dbPath);
        _queue = [FMDatabaseQueue databaseQueueWithPath:dbPath];
    }
    return _queue;
}

- (NSMutableDictionary *)dictM {
    if (!_dictM) {
        _dictM = [NSMutableDictionary dictionary];
    }
    return _dictM;
}

@end
