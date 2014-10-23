//
//  Card.m
//  GuidePost
//
//  Created by Vitaly Chupryk on 23.10.14.
//  Copyright (c) 2014 SoftMax SG. All rights reserved.
//

#import "Card.h"
#import "NSString+Validators.h"
#import "NSString+StringUtils.h"

@implementation Card

- (BOOL)isValid
{
    return self.isValidUrl && self.isValidTitle && self.isValidDesc && self.isValidImage;
}

- (BOOL)isValidUrl
{
    return self.urlString.isValidURL;
}

- (BOOL)isValidTitle
{
    return ![NSString isNullOrWhitespace:self.title];
}

- (BOOL)isValidDesc
{
    return ![NSString isNullOrWhitespace:self.desc];
}

- (BOOL)isValidImage
{
    return !CGSizeEqualToSize(self.image.size, CGSizeZero);
}

@end
