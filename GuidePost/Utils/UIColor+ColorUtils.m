//
//  UIColor+ColorUtils.m
//
//  Copyright 2013 Vitaly Chupryk. All rights reserved.
//

#import "UIColor+ColorUtils.h"

@implementation UIColor (ColorUtils)

+ (UIColor *)colorWithRGB:(long)rgb
{
    return [self colorWithRGB:rgb alpha:1];
}

+ (UIColor *)colorWithRGB:(long)rgb alpha:(CGFloat)alpha
{
    return [self colorWithRed:((rgb & 0xFF0000) >> 16) / 255.0f green:((rgb & 0x00FF00) >> 8) / 255.0f blue:(rgb & 0x0000FF) / 255.0f alpha:alpha];
}

- (long)rgb
{
    const CGFloat *components = CGColorGetComponents(self.CGColor);

    int r = (int)roundf(components[0] * 255.0f);
    int g = (int)roundf(components[1] * 255.0f);
    int b = (int)roundf(components[2] * 255.0f);

    return (r << 16) + (g << 8) + b;
}

- (CGFloat)darknessScore
{
    const CGFloat *components = CGColorGetComponents(self.CGColor);
    return ((components[0] * 255) * 299 + (components[1] * 255) * 587 + (components[2] * 255) * 114) / 1000;
}

@end