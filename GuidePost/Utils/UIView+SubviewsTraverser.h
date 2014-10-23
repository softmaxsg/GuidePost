//
//  UIView+SubviewsTraverser.h
//
//  Copyright 2013 Vitaly Chupryk. All rights reserved.
//

#import <UIKit/UIKit.h>

#pragma clang diagnostic push
#pragma ide diagnostic ignored "OCUnusedMethodInspection"
@interface UIView (SubviewsTraverser)

- (UIView *)superviewOfClass:(Class)class;
- (UIView *)topSuperview; // Returns superview at the most top which is not a UIWindow

- (NSArray *)subviewsOfClass:(Class)class;
- (NSArray *)subviewsOfClass:(Class)class inspectChildren:(BOOL)inspectChildren;

- (UIView *)firstResponderSubView;

@end
#pragma clang diagnostic pop
