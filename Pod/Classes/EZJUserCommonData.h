//
//  EZJUserCommonData.h
//  Pods
//
//  Created by Apple on 15/12/21.
//
//

#import <Foundation/Foundation.h>

@interface EZJUserCommonData : NSObject
// app类型 应用名称
// 1.android.toelfzj 2.ios.toelfzjnew 3. android.ieltsezj 4 ios.ieltsezj
@property (nonatomic,copy) NSString *app_name;
//@property (nonatomic,copy) NSString *app_version; // app版本
@property (nonatomic,copy) NSString *device_token; // iOS推送id
@property (nonatomic,copy) NSString *device; // 设备名称
@property (nonatomic,copy) NSString *client_ip; // ip地址
@property (nonatomic,copy) NSString *system; // 系统类型
@property (nonatomic,copy) NSString *system_version; // 系统版本
@property (nonatomic,copy) NSString *channel_name; // 渠道 app的发行渠道
@property (nonatomic,copy) NSString *uid; // 用户登录id,非登录状态为 0
@property (nonatomic,copy) NSString *uuid; // iOSuuid
@property (nonatomic,copy) NSString *umeng_open_id; // Android,IOS 友盟
@property (nonatomic,copy) NSString *build_number; // App版本

@property (nonatomic,copy) NSString *android_cid; // Android设备推送id
@property (nonatomic,copy) NSString *android_md5_sign; // Android md5
@property (nonatomic,copy) NSString *device_id; // Android IMEI
@property (nonatomic,copy) NSString *device_cid; // android用，iOS传空值
@property (nonatomic,copy) NSString *login_key;
@end
