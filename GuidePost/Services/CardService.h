//
//  CardService.h
//  GuidePost
//
//  Created by Vitaly Chupryk on 23.10.14.
//  Copyright (c) 2014 SoftMax SG. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Card;

@interface CardService : NSObject

+ (NSOperation *)retrieveCardDetails:(Card *)card
                        successBlock:(void (^)(Card *cardModel))successBlock
                        failureBlock:(void (^)(NSError *error))failureBlock;
@end
