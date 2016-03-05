//
//  EZJAppDelegate.m
//  EZJUserDataCollectorLibIOS
//
//  Created by zhangjing on 12/11/2015.
//  Copyright (c) 2015 zhangjing. All rights reserved.
//

#import "EZJAppDelegate.h"
#import "EZJViewController.h"
#import "EZJUserCommonData.h"
#import "NSString+path.h"
#import "EZJUserDataCollector.h"
#import "UncaughtExceptionHandler.h"
//#import "EZJAppData.h"

@implementation EZJAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    EZJViewController *vc = [[EZJViewController alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
    nav.navigationBar.backgroundColor = [UIColor whiteColor];
    nav.navigationBar.tintColor = [UIColor orangeColor];
    self.window.rootViewController = nav;
    [self.window makeKeyAndVisible];
    
    NSString *databaseName = @"easy_word.db";
    NSString *dbPath = [databaseName appendDocumentDir];
    NSLog(@"%@",dbPath);
    
    Class cls = NSClassFromString(@"UMANUtil");
    SEL deviceIDSelector = @selector(openUDIDString);
    NSString *deviceID = nil;
    if(cls && [cls respondsToSelector:deviceIDSelector]){
        deviceID = [cls performSelector:deviceIDSelector];
    }
    
    EZJUserCommonData *commonData = [[EZJUserCommonData alloc] init];
    commonData.app_name = @"ios.toelfzjnew";
    commonData.build_number = @"0.1";
    commonData.system = @"ios";
    commonData.system_version = @"ios 0.1";
    commonData.device = @"iPhone5";
    commonData.umeng_open_id = @"123"; // 友盟id
    commonData.device_token = @" ";
    commonData.channel_name = @"App Store";
    commonData.uid = @"0";
    commonData.uuid = @"123";
    commonData.login_key = @"123";
    
    EZJUserDataCollector *userDataCollector = [EZJUserDataCollector sharedInstance];
    userDataCollector.dbPath = dbPath;
    userDataCollector.commonData = commonData;
    
//    userDataCollector.dataTableName = @"e_word";
    [userDataCollector writeTime];
    return YES;
}

@end
