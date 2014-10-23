//
//  CardService.m
//  GuidePost
//
//  Created by Vitaly Chupryk on 23.10.14.
//  Copyright (c) 2014 SoftMax SG. All rights reserved.
//

#import <libextobjc/EXTScope.h>
#import <AFNetworking/AFNetworking.h>
#import <hpple/TFHpple.h>
#import "CardService.h"
#import "CompoundOperation.h"
#import "NSString+Validators.h"
#import "Card.h"

@interface CardService ()

+ (NSOperationQueue *)operationQueue;

@end

@implementation CardService

+ (NSOperationQueue *)operationQueue
{
    static NSOperationQueue *operationQueue;

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^
    {
        operationQueue = [[NSOperationQueue alloc] init];
    });

    return operationQueue;
}

+ (NSOperation *)retrieveCardDetails:(Card *)card successBlock:(void (^)(Card *cardModel))successBlock failureBlock:(void (^)(NSError *error))failureBlock
{
    NSParameterAssert(card.isValidUrl);

    CompoundOperation *operation;

    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];

    NSMutableURLRequest *request = [manager.requestSerializer requestWithMethod:@"GET" URLString:card.urlString parameters:nil error:nil];
    [request setValue:@"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_9_5) AppleWebKit/600.1.17 (KHTML, like Gecko) Version/7.1 Safari/537.85.10" forHTTPHeaderField:@"User-Agent"];
    AFHTTPRequestOperation *htmlGetOperation = [manager HTTPRequestOperationWithRequest:request success:nil failure:nil];

    NSOperation *parsingOperation = [NSBlockOperation blockOperationWithBlock:^
    {
        if (htmlGetOperation.cancelled) return;

        if (htmlGetOperation.responseData.length > 0)
        {
            TFHpple *htmlParser = [TFHpple hppleWithHTMLData:htmlGetOperation.responseData];
            TFHppleElement *titleNode = [htmlParser peekAtSearchWithXPathQuery:@"//head/meta[@property='og:title']/@content"] ?: [htmlParser peekAtSearchWithXPathQuery:@"//head/title"];
            TFHppleElement *descriptionNode = [htmlParser peekAtSearchWithXPathQuery:@"//head/meta[@property='og:description']/@content"] ?: [htmlParser peekAtSearchWithXPathQuery:@"//head/meta[@name='description']/@content"];
            TFHppleElement *imageNode = [htmlParser peekAtSearchWithXPathQuery:@"//head/meta[@property='og:image']/@content"];

            card.title = titleNode.text;
            card.desc = descriptionNode.text;

            NSString *imageUrlString = imageNode.text;
            if (imageUrlString.isValidURL)
            {
                AFHTTPRequestOperation *imageGetOperation = [manager GET:imageUrlString parameters:nil success:nil failure:nil];

                NSOperation *imageHandlerOperation = [NSBlockOperation blockOperationWithBlock:^
                {
                    if (imageGetOperation.cancelled) return;

                    if (imageGetOperation.responseData.length > 0)
                    {
                        @try
                        {
                            card.image = [UIImage imageWithData:imageGetOperation.responseData];
                        }
                        @catch (NSException *e)
                        {
                            NSLog(@"EXCEPTION has been occured when downloading image %@: %@", imageUrlString, e);
                        }
                    }
                    else
                    {
                        card.image = nil;

                        NSLog(@"Cannot download image %@: %@", imageGetOperation.request.URL.absoluteString, imageGetOperation.error);
                    }
                }];

                // Following dependencies are required only for cancelling ability
                [operation addDependency:imageGetOperation];
                [operation addDependency:imageHandlerOperation];
                //

                [imageHandlerOperation addDependency:imageGetOperation];
                [[self operationQueue] addOperation:imageHandlerOperation];

                [imageHandlerOperation waitUntilFinished];
            }
        }
        else
        {
            NSLog(@"Cannot download card %@: %@", htmlGetOperation.request.URL.absoluteString, htmlGetOperation.error);
        }
    }];

    [parsingOperation addDependency:htmlGetOperation];

    operation = [[CompoundOperation alloc] initWithOperations:@[parsingOperation]];

    @weakify(operation);
    operation.completionBlock = ^
    {
        @strongify(operation);

        if (!operation.cancelled)
        {
            if (htmlGetOperation.responseData.length > 0 && htmlGetOperation.response.statusCode < 300)
            {
                if (successBlock != nil) successBlock(card);
            }
            else
            {
                if (failureBlock != nil) failureBlock(htmlGetOperation.error);
            }
        }
    };

    NSOperationQueue *queue = [self operationQueue];
    [queue addOperation:parsingOperation];
    [queue addOperation:operation];

    [manager.operationQueue addOperation:htmlGetOperation];

    return operation;
}

@end
