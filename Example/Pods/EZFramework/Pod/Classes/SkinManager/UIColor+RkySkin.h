//
//  UIColor+RkySkin.h
//  EasyJie
//
//  Created by ricky on 14-8-23.
//  Copyright (c) 2014年 rickycui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RkySkinKit.h"
@interface UIColor (RkySkin)

+ (instancetype)colorForModule:(NSString *)module target:(NSString *)target;
+ (instancetype)colorForModule:(NSString *)module target:(NSString *)target colorType:(RkyColorType) colorType;
+ (instancetype)colorForModule:(NSString *)module target:(NSString *)target skinStyle:(RkySkinStyle) skinStyle;
+ (instancetype)colorForModule:(NSString *)module target:(NSString *)target skinStyle:(RkySkinStyle) skinStyle  colorType:(RkyColorType) colorType;

+ (UIColor *)colorWithValue:(NSInteger)colorValue;

+ (UIColor *)colorWithValue:(NSInteger)colorValue alpha:(float)alpha;

@end
