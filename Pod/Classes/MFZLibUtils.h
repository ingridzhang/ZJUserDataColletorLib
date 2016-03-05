//
//  MFZLibUtils.h
//  MaoKebing
//
//  Created by Mao on 8/30/15.
//  Copyright (c) 2015 Maokebing. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MFZLibUtils : NSObject


//compress data to zip data
+ (NSData *)dataUseZLibCompressWithData:(NSData *)data;

//decompress zip-data to data
+ (NSData *)dataUseZLibDecompressWithData:(NSData *)data;


@end
