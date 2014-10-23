//
//  UIView+CaptureImage.m
//
//  Copyright 2013 InfoTech Experts Ltd. All rights reserved.
//

#import "UIView+CaptureImage.h"

@implementation UIView (CaptureImage)

- (UIImage *)captureImage
{
    BOOL hiddenState = self.hidden;

    self.hidden = NO;

    UIGraphicsBeginImageContext(self.bounds.size);
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *result = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    self.hidden = hiddenState;

    return result;
}

@end