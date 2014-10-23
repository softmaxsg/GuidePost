//
//  CompoundOperation.m
//  GuidePost
//
//  Created by Vitaly Chupryk on 23.10.14.
//  Copyright (c) 2014 SoftMax SG. All rights reserved.
//

#import "CompoundOperation.h"
#import "NSArray+BlocksKit.h"

@implementation CompoundOperation

- (instancetype)initWithOperations:(NSArray *)operations
{
    NSCParameterAssert(operations.count > 0);

    if ((self = [self init]))
    {
        [operations bk_each:^(id operation)
        {
            [self addDependency:operation];
        }];
    }

    return self;
}

- (void)main
{
}

- (void)cancel
{
    [super cancel];

    [self.dependencies bk_each:^(id operation)
    {
        [operation cancel];
    }];
}

@end
