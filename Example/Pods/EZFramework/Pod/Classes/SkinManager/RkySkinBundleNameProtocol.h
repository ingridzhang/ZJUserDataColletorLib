//
//  RkySkinBundleNameProtocol.h
//  EasyIeltsIOS
//
//  Created by Mao on 16/2/25.
//  Copyright © 2016年 ezjie. All rights reserved.
//

#ifndef RkySkinBundleNameProtocol_h
#define RkySkinBundleNameProtocol_h
#import "RkySkinDefine.h"
@protocol RkySkinBundleNameProtocol <NSObject>

- (NSString *) bundleNameForSkinStyle: (RkySkinStyle) skinStyle;

@end

#endif /* RkySkinBundleNameProtocol_h */
