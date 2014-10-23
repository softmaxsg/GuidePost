//
//  UITextViewEx.m
//  GuidePost
//
//  Created by Vitaly Chupryk on 23.10.14.
//  Copyright (c) 2014 SoftMax SG. All rights reserved.
//

#import "UITextViewEx.h"

@interface UITextViewEx ()

@property (nonatomic) BOOL observingTextChangeNotification;
@property (nonatomic) BOOL observingTextBeginEditingNotification;
@property (nonatomic) BOOL observingTextEndEditingNotification;

- (void)startObservingTextChangeNotification;
- (void)startObservingTextBeginEditingNotification;
- (void)startObservingTextEndEditingNotification;

- (void)configurePlaceholder;

- (void)textDidChange:(NSNotification *)notification;
- (void)textBeginEditing:(NSNotification *)notification;
- (void)textEndEditing:(NSNotification *)notification;

- (CGRect)placeholderRectForBounds:(CGRect)bounds;

@end

@implementation UITextViewEx

- (void)setText:(NSString *)text
{
    [super setText:text];

    [self setNeedsDisplay];
}

- (void)setAttributedText:(NSAttributedString *)attributedText
{
    [super setAttributedText:attributedText];

    [self setNeedsDisplay];
}

- (void)setPlaceholderColor:(UIColor *)placeholderColor
{
    _placeholderColor = placeholderColor;

    [self configurePlaceholder];
}

- (void)setPlaceholder:(NSString *)placeholder
{
    _placeholder = placeholder;

    [self configurePlaceholder];
}

- (void)setHidePlaceholderOnEditing:(BOOL)hidePlaceholderOnEditing
{
    _hidePlaceholderOnEditing = hidePlaceholderOnEditing;

    [self configurePlaceholder];
}

- (void)startObservingTextChangeNotification
{
    if (self.observingTextChangeNotification) return;

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(textDidChange:)
                                                 name:UITextViewTextDidChangeNotification
                                               object:self];

    self.observingTextChangeNotification = YES;
}

- (void)startObservingTextBeginEditingNotification
{
    if (self.observingTextBeginEditingNotification) return;

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(textBeginEditing:)
                                                 name:UITextViewTextDidBeginEditingNotification
                                               object:self];

    self.observingTextBeginEditingNotification = YES;
}

- (void)startObservingTextEndEditingNotification
{
    if (self.observingTextEndEditingNotification) return;

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(textEndEditing:)
                                                 name:UITextViewTextDidEndEditingNotification
                                               object:self];

    self.observingTextEndEditingNotification = YES;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)configurePlaceholder
{
    [self startObservingTextChangeNotification];
    [self startObservingTextBeginEditingNotification];
    [self startObservingTextEndEditingNotification];

    [self setNeedsDisplay];
}

- (void)textDidChange:(NSNotification *)notification
{
    [self setNeedsDisplay];
}

- (void)textBeginEditing:(NSNotification *)notification
{
    [self setNeedsDisplay];
}

- (void)textEndEditing:(NSNotification *)notification
{
    [self setNeedsDisplay];
}

- (CGRect)placeholderRectForBounds:(CGRect)bounds
{
    CGRect placeholderRect = UIEdgeInsetsInsetRect(bounds, self.contentInset);
    placeholderRect = UIEdgeInsetsInsetRect(placeholderRect, self.textContainerInset);
    placeholderRect = CGRectInset(placeholderRect, self.textContainer.lineFragmentPadding, 0);
    return placeholderRect;
}

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];

    if ((!self.isFirstResponder || !self.hidePlaceholderOnEditing) && !self.hasText && self.placeholder.length > 0)
    {
        NSMutableParagraphStyle *paragraphStyle = [NSParagraphStyle defaultParagraphStyle].mutableCopy;
        paragraphStyle.lineBreakMode = self.textContainer.lineBreakMode;
        paragraphStyle.alignment = self.textAlignment;

        [self.placeholder drawInRect:[self placeholderRectForBounds:self.bounds]
                      withAttributes:@
                      {
                          NSForegroundColorAttributeName: self.placeholderColor,
                          NSFontAttributeName: self.font,
                          NSParagraphStyleAttributeName: paragraphStyle
                      }];
    }
}

@end
