//
//  BHttpRequestManager.m
//  BCommon
//
//  Created by baboy on 4/1/15.
//  Copyright (c) 2015 baboy. All rights reserved.
//

#import "BHttpRequestManager.h"
#import "BCommonLibCategories.h"

@implementation BHttpRequestManager
+ (id)defaultManager {
    static id _defaultHttpRequestManager = nil;
    static dispatch_once_t initOnceHttpRequestManager;
    dispatch_once(&initOnceHttpRequestManager, ^{
        _defaultHttpRequestManager = [[BHttpRequestManager alloc] init];
    });
    
    return _defaultHttpRequestManager;
}

- (BHttpRequestOperation *)createHttpRequestOperationWithRequest:(NSURLRequest *)request
                                              responseSerializer:(AFHTTPResponseSerializer *)responseSerializer
                                                        callback:(void (^)(BHttpRequestOperation *operation, id data,bool isReadFromCache,NSError *error)) callback
{
    BHttpRequestOperation *operation = [[BHttpRequestOperation alloc] initWithRequest:request];
    operation.responseSerializer = responseSerializer;
    operation.shouldUseCredentialStorage = self.shouldUseCredentialStorage;
    operation.credential = self.credential;
    operation.securityPolicy = self.securityPolicy;
    [operation setCompletionBlockWithSuccess:^(id operation, id responseObject) {
        bool readFromCache = [operation isReadFromCache];
        callback(operation,responseObject,readFromCache,nil);
    } failure:^(id operation, NSError *error) {
        callback(operation,nil, false,error);
    }];
    operation.completionQueue = self.completionQueue;
    operation.completionGroup = self.completionGroup;
    
    return operation;
}

- (BHttpRequestOperation *)createDefaultHttpRequestOperationWithRequest:(NSURLRequest *)request
                                                               callback:(void (^)(BHttpRequestOperation *operation, id data,bool isReadFromCache,NSError *error)) callback{
    return [self createHttpRequestOperationWithRequest:request
                                    responseSerializer:[AFHTTPResponseSerializer serializer]
                                               callback:callback];
}
- (BHttpRequestOperation *)createJsonHttpRequestOperationWithRequest:(NSURLRequest *)request
                                                            callback:(void (^)(BHttpRequestOperation *operation, id data,bool isReadFromCache,NSError *error)) callback{
    [self.responseSerializer setAcceptableContentTypes:nil];
    return [self createHttpRequestOperationWithRequest:request
                                    responseSerializer:self.responseSerializer
                                               callback:callback];
}


- (NSMutableURLRequest *)requestWithPOSTURL:(NSString *)url parameters:(NSDictionary *)parameters{
    NSString *u = [url replaceholders:parameters];
    NSMutableURLRequest *request = [self.requestSerializer requestWithMethod:@"POST" URLString:u parameters:parameters error:nil];
    return request;
}
- (NSMutableURLRequest *)requestWithGETURL:(NSString *)url parameters:(NSDictionary *)parameters{
    NSString *u = [url replaceholders:parameters];
    NSMutableURLRequest *request = [self.requestSerializer requestWithMethod:@"GET" URLString:u parameters:parameters error:nil];
    return request;
}


- (BHttpRequestOperation *)jsonRequestOperationWithGetRequest:(NSString *)URLString
                                                   parameters:(id)parameters
                                                     userInfo:(id)userInfo
                                                  cachePolicy:(BHttpRequestCachePolicy)cachePolicy
                                                      callback:(void (^)(BHttpRequestOperation *operation, id data,bool isReadFromCache,NSError *error)) callback
{
    NSMutableURLRequest *request = [self requestWithGETURL:URLString parameters:parameters];
    BHttpRequestOperation *operation = [self createJsonHttpRequestOperationWithRequest:request callback:callback];
    [operation setUserInfo:userInfo];
    [operation setCacheHandler:[BHttpRequestCacheHandler handlerWithCachePolicy:cachePolicy]];
    [self.operationQueue addOperation:operation];
    
    return operation;
}

- (BHttpRequestOperation *)jsonRequestOperationWithGetRequest:(NSString *)URLString
                                                   parameters:(id)parameters
                                                  cachePolicy:(BHttpRequestCachePolicy)cachePolicy
                                                     callback:(void (^)(BHttpRequestOperation *operation, id data,bool isReadFromCache,NSError *error)) callback{
    return [self jsonRequestOperationWithGetRequest:URLString parameters:parameters userInfo:nil cachePolicy:cachePolicy callback:callback];
}

- (BHttpRequestOperation *)jsonRequestOperationWithGetRequest:(NSString *)URLString
                                                   parameters:(id)parameters
                                                      callback:(void (^)(BHttpRequestOperation *operation, id data,bool isReadFromCache,NSError *error)) callback{
    return [self jsonRequestOperationWithGetRequest:URLString parameters:parameters userInfo:nil cachePolicy:BHttpRequestCachePolicyNone callback:callback];
}
//post json
- (AFHTTPRequestOperation *)jsonRequestOperationWithPostRequest:(NSString *)URLString
                                                     parameters:(id)parameters
                                                       userInfo:(id)userInfo
                                                    cachePolicy:(BHttpRequestCachePolicy)cachePolicy
                                                        callback:(void (^)(BHttpRequestOperation *operation, id data,bool isReadFromCache,NSError *error)) callback
{
    NSMutableURLRequest *request = [self requestWithPOSTURL:URLString parameters:parameters];
    BHttpRequestOperation *operation = [self createJsonHttpRequestOperationWithRequest:request callback:callback];
    [operation setUserInfo:userInfo];
    [operation setCacheHandler:[BHttpRequestCacheHandler handlerWithCachePolicy:cachePolicy]];
    [self.operationQueue addOperation:operation];
    
    return operation;
}
- (AFHTTPRequestOperation *)jsonRequestOperationWithPostRequest:(NSString *)URLString
                                                     parameters:(id)parameters
                                                    cachePolicy:(BHttpRequestCachePolicy)cachePolicy
                                                        callback:(void (^)(BHttpRequestOperation *operation, id data,bool isReadFromCache,NSError *error)) callback{
    return [self jsonRequestOperationWithPostRequest:URLString parameters:parameters userInfo:nil cachePolicy:cachePolicy callback:callback];
}

- (AFHTTPRequestOperation *)jsonRequestOperationWithPostRequest:(NSString *)URLString
                                                     parameters:(id)parameters
                                                       callback:(void (^)(BHttpRequestOperation *operation, id data,bool isReadFromCache,NSError *error)) callback{
    return [self jsonRequestOperationWithPostRequest:URLString parameters:parameters userInfo:nil cachePolicy:BHttpRequestCachePolicyNone callback:callback];
}
// data json
- (BHttpRequestOperation *)dataRequestWithURLRequest:(NSString *)URLString
                                          parameters:(id)parameters
                                            userInfo:(id)userInfo
                                         cachePolicy:(BHttpRequestCachePolicy)cachePolicy
                                             callback:(void (^)(BHttpRequestOperation *operation, id data,bool isReadFromCache,NSError *error)) callback{
    NSMutableURLRequest *request = [self requestWithPOSTURL:URLString parameters:parameters];
    BHttpRequestOperation *operation = [self createJsonHttpRequestOperationWithRequest:request callback:callback];
    [operation setUserInfo:userInfo];
    [operation setCacheHandler:[BHttpRequestCacheHandler handlerWithCachePolicy:cachePolicy]];
    [self.operationQueue addOperation:operation];
    
    return operation;
}
- (BHttpRequestOperation *)dataRequestWithURLRequest:(NSString *)URLString
                                          parameters:(id)parameters
                                             callback:(void (^)(BHttpRequestOperation *operation, id data,bool isReadFromCache,NSError *error)) callback{
    return [self dataRequestWithURLRequest:URLString parameters:parameters userInfo:nil cachePolicy:BHttpRequestCachePolicyNone callback:callback];
}

// file request
- (BHttpRequestOperation *)fileRequestWithURLRequest:(NSString *)URLString
                                          parameters:(id)parameters
                                            userInfo:(id)userInfo
                                         cachePolicy:(BHttpRequestCachePolicy)cachePolicy
                                             callback:(void (^)(BHttpRequestOperation *operation, id data,bool isReadFromCache,NSError *error)) callback{
    NSMutableURLRequest *request = [self requestWithPOSTURL:URLString parameters:parameters];
    BHttpRequestOperation *operation = [self createDefaultHttpRequestOperationWithRequest:request callback:callback];
    [operation setCacheHandler:[BHttpRequestCacheHandler handlerWithCachePolicy:cachePolicy]];
    [self.operationQueue addOperation:operation];
    
    return operation;
}
- (BHttpRequestOperation *)cacheFileRequestWithURLRequest:(NSString *)URLString
                                          parameters:(id)parameters
                                             callback:(void (^)(BHttpRequestOperation *operation, id data,bool isReadFromCache,NSError *error)) callback{
    return [self fileRequestWithURLRequest:URLString parameters:parameters userInfo:nil cachePolicy:BHttpRequestCachePolicyLoadIfNotCached callback:callback];
}


@end
