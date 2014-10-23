//
//  CompoundOperation.h
//  GuidePost
//
//  Created by Vitaly Chupryk on 23.10.14.
//  Copyright (c) 2014 SoftMax SG. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CompoundOperation : NSOperation

- (instancetype)initWithOperations:(NSArray *)operations;

@end
