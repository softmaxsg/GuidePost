//
//  UIView+ActivityIndicator.m
//
//  Copyright 2014 Vitaly Chupryk. All rights reserved.
//

#import <objc/runtime.h>
#import "UIView+ActivityIndicator.h"

@implementation UIView (ActivityIndicator)

// TODO: Handle layoutSubviews

- (NSNumber *)activityIndicatorStyleNumber
{
    return objc_getAssociatedObject(self, @selector(activityIndicatorStyleNumber));
}

- (void)setActivityIndicatorStyleNumber:(NSNumber *)activityIndicatorStyleNumber
{
    objc_setAssociatedObject(self, @selector(activityIndicatorStyleNumber), activityIndicatorStyleNumber, OBJC_ASSOCIATION_RETAIN_NONATOMIC);

    [self updateActivityIndicator];
}

- (UIActivityIndicatorViewStyle)activityIndicatorStyle
{
    return (UIActivityIndicatorViewStyle)[(self.activityIndicatorStyleNumber ?: @(UIActivityIndicatorViewStyleGray)) integerValue];
}

- (void)setActivityIndicatorStyle:(UIActivityIndicatorViewStyle)activityIndicatorStyle
{
    self.activityIndicatorStyleNumber = @(activityIndicatorStyle);
}

- (void)showActivityIndicator
{
    UIActivityIndicatorView *activityIndicator = self.activityIndicator;
    if (activityIndicator == nil)
    {
        activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:self.activityIndicatorStyle];
        self.activityIndicator = activityIndicator;
    }

    activityIndicator.backgroundColor = self.backgroundColor;
    activityIndicator.layer.cornerRadius = self.layer.cornerRadius;
    activityIndicator.frame = CGRectInset(self.bounds, self.layer.borderWidth, self.layer.borderWidth);

    if (activityIndicator.superview == nil)
    {
        [self addSubview:activityIndicator];
    }

    if (!activityIndicator.isAnimating)
    {
        [activityIndicator startAnimating];
    }
}

- (void)hideActivityIndicator
{
    UIActivityIndicatorView *activityIndicator = self.activityIndicator;

    [activityIndicator stopAnimating];
    [activityIndicator removeFromSuperview];
}

- (UIActivityIndicatorView *)activityIndicator
{
    return objc_getAssociatedObject(self, @selector(activityIndicator));
}

- (void)setActivityIndicator:(UIActivityIndicatorView *)activityIndicator
{
    objc_setAssociatedObject(self, @selector(activityIndicator), activityIndicator, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)updateActivityIndicator
{
    self.activityIndicator.activityIndicatorViewStyle = self.activityIndicatorStyle;
}

@end