//
//  Card.h
//  GuidePost
//
//  Created by Vitaly Chupryk on 23.10.14.
//  Copyright (c) 2014 SoftMax SG. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Card : NSObject

@property (nonatomic) NSString *urlString;
@property (nonatomic) NSString *title;
@property (nonatomic) NSString *desc;
@property (nonatomic) UIImage *image;

- (BOOL)isValid;
- (BOOL)isValidUrl;
- (BOOL)isValidTitle;
- (BOOL)isValidDesc;
- (BOOL)isValidImage;

@end
