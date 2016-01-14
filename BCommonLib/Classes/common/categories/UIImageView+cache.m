//
//  UIImageView+cache.m
//  iLookForiPhone
//
//  Created by Yinghui Zhang on 6/6/12.
//  Copyright (c) 2012 LavaTech. All rights reserved.
//


#import "UIImageView+cache.h"
#import <objc/runtime.h>
#import "BCommonLibHttp.h"
#import "BCommonLibCategories.h"

static char UIImageViewCacheOperationObjectKey;

@interface UIImageView()
@property (readwrite, nonatomic, strong) NSOperation *requestOperation;
@end
@implementation UIImageView(cache)
- (NSOperation *)requestOperation {
    return (NSOperation *)objc_getAssociatedObject(self, &UIImageViewCacheOperationObjectKey);
}

- (void)setRequestOperation:(NSOperation *)requestOperation{
    objc_setAssociatedObject(self, &UIImageViewCacheOperationObjectKey, requestOperation, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

+ (NSOperationQueue *)sharedImageRequestOperationQueue {
    static NSOperationQueue *_imageRequestOperationQueue = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _imageRequestOperationQueue = [[NSOperationQueue alloc] init];
        [_imageRequestOperationQueue setMaxConcurrentOperationCount:NSOperationQueueDefaultMaxConcurrentOperationCount];
    });
    
    return _imageRequestOperationQueue;
}

- (void)cancelImageRequestOperation {
    [self.requestOperation cancel];
    self.requestOperation = nil;
}
- (id)setImageURLString:(NSString *)url placeholderImage:(UIImage *)placeholderImage withImageLoadedCallback:(void (^)(NSString *url, NSString *filePath, NSError *error))callback{
    [self cancelImageRequestOperation];
    
    NSString *fp = nil;
    if ([url isURL]) {
        fp = [UIImageView cachePathForURLString:url];;
    }else{
        fp = url;
    }
    if ([fp fileExists]) {
        UIImage *img = [UIImage imageWithContentsOfFile:fp];
        if (img) {
            self.image = img;
            if (callback) {
                callback(url,fp,nil);
            }
            return nil;
        }
    }
    self.image = placeholderImage;
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    /*
    BHttpRequestOperation *operation = [[BHttpRequestOperation alloc] initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(id operation, id responseObject) {
        NSDictionary *userInfo = [operation userInfo];
        id object = userInfo?[userInfo valueForKey:@"object"]:nil;
        NSString *fp = [operation cacheFilePath];
        if (self == object ) {
            if ([fp fileExists]) {
                [self setImage:[UIImage imageWithContentsOfFile:fp]];
            }
            if (callback) {
                callback(url, fp, nil);
            }
        }
        
    }
                                     failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                         if (callback) {
                                             callback(url, nil, error);
                                         }
                                         
                                     }];
    [operation setUserInfo:[NSDictionary dictionaryWithObject:self forKey:@"object"]];
    [operation setCacheHandler:[BHttpRequestCacheHandler fileCacheHandler]];
    self.requestOperation = operation;
    [[[self class] sharedImageRequestOperationQueue] addOperation:self.requestOperation];
    return operation;
     */
    return nil;
}
- (void)setImageURLString:(NSString *)url{
    [self setImageURLString:url placeholderImage:nil withImageLoadedCallback:nil];
}
- (void)setImageURLString:(NSString *)url placeholderImage:(UIImage *)placeholderImage{
    [self setImageURLString:url placeholderImage:placeholderImage withImageLoadedCallback:nil];
}

- (id)setImageURLString:(NSString *)url withImageLoadedCallback:(void (^)(NSString *url, NSString *filePath, NSError *error))callback{
    return [self setImageURLString:url placeholderImage:nil withImageLoadedCallback:callback];
}

+ (NSString *)cachePathForURLString:(NSString *)url{
    return [BHttpRequestCacheHandler cachePathForURL:[NSURL URLWithString:url]];
}
+ (NSData *)cacheDataForURLString:(NSString *)url{
    return [BHttpRequestCacheHandler cacheDataForURL:[NSURL URLWithString:url]];
}
@end
