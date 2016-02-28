//
//  NSString+Extension.h
//  Pods
//
//  Created by Apple on 16/1/20.
//
//

#import <Foundation/Foundation.h>

@interface NSString (Extension)

- (NSString *)appendDocumentDir;
- (NSString *)appendCacheDir;
- (NSString *)appendTempDir;

- (void)hrefLink:(void(^)(NSString *link,NSString *text))completion;

- (NSString *)toCamelCase;
- (NSString *)splitOnCapital;

- (NSString *)kv_decodeHTMLCharacterEntities:(NSString *)originString;
- (NSString *)kv_encodeHTMLCharacterEntities:(NSString *)originString;

@end
