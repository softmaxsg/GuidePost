//
//  NSString+StringUtils.h
//
//  Copyright 2011 Vitaly Chupryk. All rights reserved.
//
//

#import <Foundation/Foundation.h>

@interface NSString (StringUtils)

+ (BOOL)isNullOrEmpty:(NSString *)string;
+ (BOOL)isNullOrWhitespace:(NSString *)string;

- (BOOL)isCaseInsensitiveEqualToString:(NSString *)string;;

@end
