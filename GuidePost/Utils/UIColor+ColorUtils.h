//
//  UIColor+ColorUtils.h
//
//  Copyright 2013 Vitaly Chupryk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (ColorUtils)

+ (UIColor *)colorWithRGB:(long)rgb;
+ (UIColor *)colorWithRGB:(long)rgb alpha:(CGFloat)alpha;

- (long)rgb;

- (CGFloat)darknessScore;

@end