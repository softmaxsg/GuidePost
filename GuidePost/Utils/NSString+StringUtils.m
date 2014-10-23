//
//  NSString+StringUtils.m
//
//  Copyright 2011 Vitaly Chupryk. All rights reserved.
//

#import "NSString+StringUtils.h"

@implementation NSString (StringUtils)

+ (BOOL)isNullOrEmpty:(NSString *)string
{
	return string == nil || [string isEqual:[NSNull null]] || [string compare:@""] == NSOrderedSame;
}

+ (BOOL)isNullOrWhitespace:(NSString *)string
{
    return [NSString isNullOrEmpty:string] ||
           [[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] compare:@""] == NSOrderedSame;
}

- (BOOL)isCaseInsensitiveEqualToString:(NSString *)string
{
    return [self caseInsensitiveCompare:string] == NSOrderedSame;
}

@end
