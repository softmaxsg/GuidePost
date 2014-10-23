//
//  UIView+ActivityIndicator.h
//
//  Copyright 2014 Vitaly Chupryk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (ActivityIndicator)

- (NSNumber *)activityIndicatorStyleNumber;
- (void)setActivityIndicatorStyleNumber:(NSNumber *)activityIndicatorStyleNumber;

- (UIActivityIndicatorViewStyle)activityIndicatorStyle;
- (void)setActivityIndicatorStyle:(UIActivityIndicatorViewStyle)activityIndicatorStyle;

- (void)showActivityIndicator;
- (void)hideActivityIndicator;

@end