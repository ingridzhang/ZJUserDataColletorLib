//
//  RkyDefaultSkinBundleName.m
//  EasyIeltsIOS
//
//  Created by Mao on 16/2/25.
//  Copyright © 2016年 ezjie. All rights reserved.
//

#import "RkyDefaultSkinBundleName.h"

@implementation RkyDefaultSkinBundleName

-(NSString *)bundleNameForSkinStyle:(RkySkinStyle)skinStyle {

    switch (skinStyle) {
        case RkySkinStyleDefault:
        return kSkinDefaultsBundleName;
        break;
        case RkySkinStyleNight:
        return kSkinNightBundleName;
        break;
        default:
        break;
    }
    return kSkinDefaultsBundleName;
}
@end
