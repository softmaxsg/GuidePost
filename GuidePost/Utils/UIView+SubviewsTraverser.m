//
//  UIView+SubviewsTraverser.m
//
//  Copyright 2013 Vitaly Chupryk. All rights reserved.
//

#import "UIView+SubviewsTraverser.h"

@implementation UIView (SubviewsTraverser)

- (UIView *)superviewOfClass:(Class)class
{
    UIView *view = self;
    while (![view.superview isKindOfClass:class])
    {
        view = view.superview;
        if (view == nil) return nil;
    }

    return view.superview;
}

- (UIView *)topSuperview
{
    UIView *view = self;
    while (![view.superview isKindOfClass:[UIWindow class]])
    {
        view = view.superview;
        if (view == nil) return nil;
    }

    return view != self ? view : nil;
}

- (NSArray *)subviewsOfClass:(Class)class
{
    return [self subviewsOfClass:class inspectChildren:NO];
}

- (NSArray *)subviewsOfClass:(Class)class inspectChildren:(BOOL)inspectChildren
{
    NSMutableArray *result = [NSMutableArray array];

    for (UIView *view in self.subviews)
    {
        if ([view isKindOfClass:class])
        {
            [result addObject:view];
        }

        if (inspectChildren)
        {
            [result addObjectsFromArray:[view subviewsOfClass:class inspectChildren:YES]];
        }
    }

    return result;
}

- (UIView *)firstResponderSubView
{
    for (UIView *view in self.subviews)
    {
        if (view.isFirstResponder) return view;

        UIView *firstResponderView = view.firstResponderSubView;
        if (firstResponderView != nil) return firstResponderView;
    }

    return nil;
}

@end
