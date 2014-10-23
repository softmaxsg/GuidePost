//
//  UITextViewEx.h
//  GuidePost
//
//  Created by Vitaly Chupryk on 23.10.14.
//  Copyright (c) 2014 SoftMax SG. All rights reserved.
//

#import "MBAutoGrowingTextView.h"

@interface UITextViewEx : MBAutoGrowingTextView

@property (nonatomic) UIColor *placeholderColor;
@property (nonatomic) NSString *placeholder;
@property (nonatomic) BOOL hidePlaceholderOnEditing;

@end
