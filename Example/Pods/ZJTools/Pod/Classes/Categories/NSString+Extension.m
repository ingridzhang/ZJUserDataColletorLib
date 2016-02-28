//
//  NSString+Extension.m
//  Pods
//
//  Created by Apple on 16/1/20.
//
//

#import "NSString+Extension.h"

@implementation NSString (Extension)

- (NSString *)appendDocumentDir{
    
    NSString *dir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    
    return [dir stringByAppendingPathComponent:self.lastPathComponent];
}

- (NSString *)appendCacheDir{
    
    NSString *dir = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
    
    return [dir stringByAppendingPathComponent:self.lastPathComponent];
    
}

- (NSString *)appendTempDir{
    
    return [NSTemporaryDirectory() stringByAppendingPathComponent:self.lastPathComponent];
}

- (void)hrefLink:(void(^)(NSString *link,NSString *text))completion {
    NSString *pattern = @"<a href=\"(.*?)\".*?>(.*?)</a>";
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:pattern options:NSRegularExpressionDotMatchesLineSeparators error:nil];
    NSTextCheckingResult *result = [regex firstMatchInString:self options:0 range:NSMakeRange(0, self.length)];
    if (result != nil) {
        NSRange r1 = [result rangeAtIndex:1];
        NSRange r2 = [result rangeAtIndex:2];
        NSString *link = [self substringWithRange:r1];
        NSString *text = [self substringWithRange:r2];
        completion(link,text);
    }else {
        completion(nil,nil);
    }
    
}

- (NSString *)toCamelCase
{
    return [[[self capitalizedString] componentsSeparatedByCharactersInSet:[[NSCharacterSet characterSetWithCharactersInString:@"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"] invertedSet]] componentsJoinedByString:@""];
}

- (NSString *)splitOnCapital {
    NSRange upcaseRange = NSMakeRange('A', 26);
    NSRange numberRange = NSMakeRange('0', 10);
    NSIndexSet *upcaseSet = [NSIndexSet indexSetWithIndexesInRange:upcaseRange];
    NSIndexSet *numberSet = [NSIndexSet indexSetWithIndexesInRange:numberRange];
    NSMutableString *result = [NSMutableString string];
    NSMutableString *oneWord = [NSMutableString string];
    BOOL prevLetterIsUc = NO;
    for (int i = 0; i < self.length; i++) {
        char oneChar = [self characterAtIndex:i];
        if ([upcaseSet containsIndex:oneChar]||[numberSet containsIndex:oneChar]) {
            if ( prevLetterIsUc ) {
            } else {
                if (result.length == 0) {
                    [result appendFormat:@"%@", [oneWord lowercaseString]];
                }else {
                    [result appendFormat:@"_%@", [oneWord lowercaseString]];
                }
                oneWord = [NSMutableString string];
            }
            prevLetterIsUc = YES;
        } else {
            prevLetterIsUc = NO;
        }
        [oneWord appendFormat:@"%c", oneChar];
    }
    if (oneWord.length > 0) {
        [result appendFormat:@"_%@", [oneWord lowercaseString]];
    }
    return result;
}

- (NSString *)kv_decodeHTMLCharacterEntities:(NSString *)originString {
    if ([originString rangeOfString:@"&"].location == NSNotFound) {
        return originString;
    } else {
        NSMutableString *escaped = [NSMutableString stringWithString:originString];
        NSArray *codes = [NSArray arrayWithObjects:
                          @"&nbsp;", @"&iexcl;", @"&cent;", @"&pound;", @"&curren;", @"&yen;", @"&brvbar;",
                          @"&sect;", @"&uml;", @"&copy;", @"&ordf;", @"&laquo;", @"&not;", @"&shy;", @"&reg;",
                          @"&macr;", @"&deg;", @"&plusmn;", @"&sup2;", @"&sup3;", @"&acute;", @"&micro;",
                          @"&para;", @"&middot;", @"&cedil;", @"&sup1;", @"&ordm;", @"&raquo;", @"&frac14;",
                          @"&frac12;", @"&frac34;", @"&iquest;", @"&Agrave;", @"&Aacute;", @"&Acirc;",
                          @"&Atilde;", @"&Auml;", @"&Aring;", @"&AElig;", @"&Ccedil;", @"&Egrave;",
                          @"&Eacute;", @"&Ecirc;", @"&Euml;", @"&Igrave;", @"&Iacute;", @"&Icirc;", @"&Iuml;",
                          @"&ETH;", @"&Ntilde;", @"&Ograve;", @"&Oacute;", @"&Ocirc;", @"&Otilde;", @"&Ouml;",
                          @"&times;", @"&Oslash;", @"&Ugrave;", @"&Uacute;", @"&Ucirc;", @"&Uuml;", @"&Yacute;",
                          @"&THORN;", @"&szlig;", @"&agrave;", @"&aacute;", @"&acirc;", @"&atilde;", @"&auml;",
                          @"&aring;", @"&aelig;", @"&ccedil;", @"&egrave;", @"&eacute;", @"&ecirc;", @"&euml;",
                          @"&igrave;", @"&iacute;", @"&icirc;", @"&iuml;", @"&eth;", @"&ntilde;", @"&ograve;",
                          @"&oacute;", @"&ocirc;", @"&otilde;", @"&ouml;", @"&divide;", @"&oslash;", @"&ugrave;",
                          @"&uacute;", @"&ucirc;", @"&uuml;", @"&yacute;", @"&thorn;", @"&yuml;", nil];
        
        NSUInteger i, count = [codes count];
        
        // Html
        for (i = 0; i < count; i++) {
            NSRange range = [originString rangeOfString:[codes objectAtIndex:i]];
            if (range.location != NSNotFound) {
                [escaped replaceOccurrencesOfString:[codes objectAtIndex:i]
                                         withString:[NSString stringWithFormat:@"%C", (unsigned short) (160 + i)]
                                            options:NSLiteralSearch
                                              range:NSMakeRange(0, [escaped length])];
            }
        }
        
        // The following five are not in the 160+ range
        // @"&amp;"
        NSRange range = [originString rangeOfString:@"&amp;"];
        if (range.location != NSNotFound) {
            [escaped replaceOccurrencesOfString:@"&amp;"
                                     withString:[NSString stringWithFormat:@"%C", (unsigned short) 38]
                                        options:NSLiteralSearch
                                          range:NSMakeRange(0, [escaped length])];
        }
        
        // @"&lt;"
        range = [originString rangeOfString:@"&lt;"];
        if (range.location != NSNotFound) {
            [escaped replaceOccurrencesOfString:@"&lt;"
                                     withString:[NSString stringWithFormat:@"%C", (unsigned short) 60]
                                        options:NSLiteralSearch
                                          range:NSMakeRange(0, [escaped length])];
        }
        
        // @"&gt;"
        range = [originString rangeOfString:@"&gt;"];
        if (range.location != NSNotFound) {
            [escaped replaceOccurrencesOfString:@"&gt;"
                                     withString:[NSString stringWithFormat:@"%C", (unsigned short) 62]
                                        options:NSLiteralSearch
                                          range:NSMakeRange(0, [escaped length])];
        }
        // @"&apos;"
        range = [originString rangeOfString:@"&apos;"];
        if (range.location != NSNotFound) {
            [escaped replaceOccurrencesOfString:@"&apos;"
                                     withString:[NSString stringWithFormat:@"%C", (unsigned short) 39]
                                        options:NSLiteralSearch
                                          range:NSMakeRange(0, [escaped length])];
        }
        // @"&quot;"
        range = [originString rangeOfString:@"&quot;"];
        if (range.location != NSNotFound) {
            [escaped replaceOccurrencesOfString:@"&quot;"
                                     withString:[NSString stringWithFormat:@"%C", (unsigned short) 34]
                                        options:NSLiteralSearch
                                          range:NSMakeRange(0, [escaped length])];
        }
        // Decimal & Hex
        NSRange start, finish, searchRange = NSMakeRange(0, [escaped length]);
        i = 0;
        while (i < [escaped length]) {
            start = [escaped rangeOfString:@"&#"
                                   options:NSCaseInsensitiveSearch
                                     range:searchRange];
            
            finish = [escaped rangeOfString:@";"
                                    options:NSCaseInsensitiveSearch
                                      range:searchRange];
            
            if (start.location != NSNotFound && finish.location != NSNotFound &&
                finish.location > start.location) {
                NSRange entityRange = NSMakeRange(start.location, (finish.location - start.location) + 1);
                NSString *entity = [escaped substringWithRange:entityRange];
                NSString *value = [entity substringWithRange:NSMakeRange(2, [entity length] - 2)];
                
                [escaped deleteCharactersInRange:entityRange];
                
                if ([value hasPrefix:@"x"]) {
                    unsigned tempInt = 0;
                    NSScanner *scanner = [NSScanner scannerWithString:[value substringFromIndex:1]];
                    [scanner scanHexInt:&tempInt];
                    [escaped insertString:[NSString stringWithFormat:@"%C", (unsigned short) tempInt] atIndex:entityRange.location];
                } else {
                    [escaped insertString:[NSString stringWithFormat:@"%C", (unsigned short) [value intValue]] atIndex:entityRange.location];
                } i = start.location;
            } else { i++; }
            searchRange = NSMakeRange(i, [escaped length] - i);
        }
        return escaped;    // Note this is autoreleased
    }
}

- (NSString *)kv_encodeHTMLCharacterEntities:(NSString *)originString {
    NSMutableString *encoded = [NSMutableString stringWithString:originString];
    
    // @"&amp;"
    NSRange range = [originString rangeOfString:@"&"];
    if (range.location != NSNotFound) {
        [encoded replaceOccurrencesOfString:@"&"
                                 withString:@"&amp;"
                                    options:NSLiteralSearch
                                      range:NSMakeRange(0, [encoded length])];
    }
    
    range = [originString rangeOfString:@"<h4>"];
    if (range.location != NSNotFound) {
        [encoded replaceOccurrencesOfString:@"<h4>"
                                 withString:@""
                                    options:NSLiteralSearch
                                      range:NSMakeRange(0, [encoded length])];
    }
    
    range = [originString rangeOfString:@"</h4>"];
    if (range.location != NSNotFound) {
        [encoded replaceOccurrencesOfString:@"</h4>"
                                 withString:@""
                                    options:NSLiteralSearch
                                      range:NSMakeRange(0, [encoded length])];
    }
    
    // @"&lt;"
    range = [originString rangeOfString:@"<"];
    if (range.location != NSNotFound) {
        [encoded replaceOccurrencesOfString:@"<"
                                 withString:@"&lt;"
                                    options:NSLiteralSearch
                                      range:NSMakeRange(0, [encoded length])];
    }
    
    // @"&gt;"
    range = [originString rangeOfString:@">"];
    if (range.location != NSNotFound) {
        [encoded replaceOccurrencesOfString:@">"
                                 withString:@"&gt;"
                                    options:NSLiteralSearch
                                      range:NSMakeRange(0, [encoded length])];
    }
    return encoded;
}

@end
