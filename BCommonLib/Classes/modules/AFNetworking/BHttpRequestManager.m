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
                                                        success:(void (^)(BHttpRequestOperation *operation, id data,bool isReadFromCache)) success
                                                         failure:(void (^)(BHttpRequestOperation *operation, NSError *error)) failure
                                                        progress:(void (^)(id operation,long long totalBytesRead, long long totalBytesExpectedToRead))progressBlock
{
    BHttpRequestOperation *operation = [[BHttpRequestOperation alloc] initWithRequest:request];
    operation.responseSerializer = responseSerializer?:operation.responseSerializer;
    operation.shouldUseCredentialStorage = self.shouldUseCredentialStorage;
    operation.credential = self.credential;
    operation.securityPolicy = self.securityPolicy;
    [operation setCompletionBlockWithSuccess:^(id operation, id responseObject) {
        bool readFromCache = [operation isReadFromCache];
        success(operation,responseObject,readFromCache);
    } failure:^(id operation, NSError *error) {
        failure(operation,error);
    }];
    operation.completionQueue = self.completionQueue;
    operation.completionGroup = self.completionGroup;
    __weak id ope = operation;
    [operation setDownloadProgressBlock:^(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead) {
        if(progressBlock){
            progressBlock(ope, totalBytesRead, totalBytesExpectedToRead);
        }
    }];
    return operation;
}
- (BHttpRequestOperation *)createHttpRequestOperationWithRequest:(NSURLRequest *)request
                                              responseSerializer:(AFHTTPResponseSerializer *)responseSerializer
                                                         success:(void (^)(BHttpRequestOperation *operation, id data,bool isReadFromCache)) success
                                                         failure:(void (^)(BHttpRequestOperation *operation, NSError *error)) failure
{
    return [self createHttpRequestOperationWithRequest:request
                                    responseSerializer:responseSerializer
                                               success:success
                                               failure:failure
                                              progress:nil
            ];
    
}

- (BHttpRequestOperation *)createDefaultHttpRequestOperationWithRequest:(NSURLRequest *)request
                                                                success:(void (^)(BHttpRequestOperation *operation, id data,bool isReadFromCache)) success
                                                                failure:(void (^)(BHttpRequestOperation *operation, NSError *error)) failure{
    return [self createHttpRequestOperationWithRequest:request
                                    responseSerializer:[AFHTTPResponseSerializer serializer]
                                               success:success
                                               failure:failure];
}
- (BHttpRequestOperation *)createJsonHttpRequestOperationWithRequest:(NSURLRequest *)request
                                                             success:(void (^)(BHttpRequestOperation *operation, id data,bool isReadFromCache)) success
                                                             failure:(void (^)(BHttpRequestOperation *operation, NSError *error)) failure{
    [self.responseSerializer setAcceptableContentTypes:nil];
    return [self createHttpRequestOperationWithRequest:request
                                    responseSerializer:self.responseSerializer
                                               success:success
                                                      failure:failure];
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
                                                      success:(void (^)(BHttpRequestOperation *operation, id data,bool isReadFromCache)) success
                                                      failure:(void (^)(BHttpRequestOperation *operation, NSError *error)) failure
{
    NSMutableURLRequest *request = [self requestWithGETURL:URLString parameters:parameters];
    BHttpRequestOperation *operation = [self createJsonHttpRequestOperationWithRequest:request success:success failure:failure];
    [operation setUserInfo:userInfo];
    [operation setCacheHandler:[BHttpRequestCacheHandler handlerWithCachePolicy:cachePolicy]];
    [self.operationQueue addOperation:operation];
    
    return operation;
}

- (BHttpRequestOperation *)jsonRequestOperationWithGetRequest:(NSString *)URLString
                                                   parameters:(id)parameters
                                                  cachePolicy:(BHttpRequestCachePolicy)cachePolicy
                                                      success:(void (^)(BHttpRequestOperation *operation, id data,bool isReadFromCache)) success
                                                      failure:(void (^)(BHttpRequestOperation *operation, NSError *error)) failure{
    return [self jsonRequestOperationWithGetRequest:URLString parameters:parameters userInfo:nil cachePolicy:cachePolicy success:success failure:failure];
}

- (BHttpRequestOperation *)jsonRequestOperationWithGetRequest:(NSString *)URLString
                                                   parameters:(id)parameters
                                                      success:(void (^)(BHttpRequestOperation *operation, id data,bool isReadFromCache)) success
                                                      failure:(void (^)(BHttpRequestOperation *operation, NSError *error)) failure{
    return [self jsonRequestOperationWithGetRequest:URLString parameters:parameters userInfo:nil cachePolicy:BHttpRequestCachePolicyNone  success:success failure:failure];
}
//post json
- (AFHTTPRequestOperation *)jsonRequestOperationWithPostRequest:(NSString *)URLString
                                                     parameters:(id)parameters
                                                       userInfo:(id)userInfo
                                                    cachePolicy:(BHttpRequestCachePolicy)cachePolicy
                                                        success:(void (^)(BHttpRequestOperation *operation, id data,bool isReadFromCache)) success
                                                        failure:(void (^)(BHttpRequestOperation *operation, NSError *error)) failure
{
    NSMutableURLRequest *request = [self requestWithPOSTURL:URLString parameters:([parameters isKindOfClass:[NSDictionary class]] ? parameters : nil)];
    if (![parameters isKindOfClass:[NSDictionary class]]) {
        [request setHTTPBody:[parameters dataUsingEncoding:NSUTF8StringEncoding]];
    }
    BHttpRequestOperation *operation = [self createJsonHttpRequestOperationWithRequest:request  success:success failure:failure];
    [operation setUserInfo:userInfo];
    [operation setCacheHandler:[BHttpRequestCacheHandler handlerWithCachePolicy:cachePolicy]];
    [self.operationQueue addOperation:operation];
    
    return operation;
}
- (AFHTTPRequestOperation *)jsonRequestOperationWithPostRequest:(NSString *)URLString
                                                     parameters:(id)parameters
                                                    cachePolicy:(BHttpRequestCachePolicy)cachePolicy
                                                        success:(void (^)(BHttpRequestOperation *operation, id data,bool isReadFromCache)) success
                                                        failure:(void (^)(BHttpRequestOperation *operation, NSError *error)) failure{
    return [self jsonRequestOperationWithPostRequest:URLString parameters:parameters userInfo:nil cachePolicy:cachePolicy  success:success failure:failure];
}

- (AFHTTPRequestOperation *)jsonRequestOperationWithPostRequest:(NSString *)URLString
                                                     parameters:(id)parameters
                                                        success:(void (^)(BHttpRequestOperation *operation, id data,bool isReadFromCache)) success
                                                        failure:(void (^)(BHttpRequestOperation *operation, NSError *error)) failure{
    return [self jsonRequestOperationWithPostRequest:URLString parameters:parameters userInfo:nil cachePolicy:BHttpRequestCachePolicyNone  success:success failure:failure];
}
// data json
- (BHttpRequestOperation *)dataRequestWithURLRequest:(NSString *)URLString
                                          parameters:(id)parameters
                                            userInfo:(id)userInfo
                                         cachePolicy:(BHttpRequestCachePolicy)cachePolicy
                                             success:(void (^)(BHttpRequestOperation *operation, id data,bool isReadFromCache)) success
                                             failure:(void (^)(BHttpRequestOperation *operation, NSError *error)) failure{
    NSMutableURLRequest *request = [self requestWithPOSTURL:URLString parameters:parameters];
    BHttpRequestOperation *operation = [self createJsonHttpRequestOperationWithRequest:request  success:success failure:failure];
    [operation setUserInfo:userInfo];
    [operation setCacheHandler:[BHttpRequestCacheHandler handlerWithCachePolicy:cachePolicy]];
    [self.operationQueue addOperation:operation];
    
    return operation;
}
- (BHttpRequestOperation *)dataRequestWithURLRequest:(NSString *)URLString
                                          parameters:(id)parameters
                                             success:(void (^)(BHttpRequestOperation *operation, id data,bool isReadFromCache)) success
                                             failure:(void (^)(BHttpRequestOperation *operation, NSError *error)) failure{
    return [self dataRequestWithURLRequest:URLString parameters:parameters userInfo:nil cachePolicy:BHttpRequestCachePolicyNone success:success failure:failure];
}

// file request
- (BHttpRequestOperation *)fileRequestWithURLRequest:(NSString *)URLString
                                          parameters:(id)parameters
                                            userInfo:(id)userInfo
                                         cachePolicy:(BHttpRequestCachePolicy)cachePolicy
                                             success:(void (^)(BHttpRequestOperation *operation, id data,bool isReadFromCache)) success
                                             failure:(void (^)(BHttpRequestOperation *operation, NSError *error)) failure{
    NSMutableURLRequest *request = [self requestWithPOSTURL:URLString parameters:parameters];
    BHttpRequestOperation *operation = [self createDefaultHttpRequestOperationWithRequest:request success:success failure:failure];
    [operation setCacheHandler:[BHttpRequestCacheHandler handlerWithCachePolicy:cachePolicy]];
    [self.operationQueue addOperation:operation];
    
    return operation;
}
- (BHttpRequestOperation *)cacheFileRequestWithURLRequest:(NSString *)URLString
                                               parameters:(id)parameters
                                                  success:(void (^)(BHttpRequestOperation *operation, id data,bool isReadFromCache)) success
                                                  failure:(void (^)(BHttpRequestOperation *operation, NSError *error)) failure{
    return [self fileRequestWithURLRequest:URLString parameters:parameters userInfo:nil cachePolicy:BHttpRequestCachePolicyLoadIfNotCached success:success failure:failure];
}

- (BHttpRequestOperation *)cacheFileRequestWithURLRequest:(NSString *)URLString
                                               parameters:(id)parameters
                                                 userInfo:(id)userInfo
                                                  success:(void (^)(BHttpRequestOperation *operation, id data,bool isReadFromCache)) success
                                                  failure:(void (^)(BHttpRequestOperation *operation, NSError *error)) failure{
    return [self fileRequestWithURLRequest:URLString parameters:parameters userInfo:userInfo cachePolicy:BHttpRequestCachePolicyLoadIfNotCached success:success failure:failure];
}

- (BHttpRequestOperation *)downloadFileWithURLRequest:(NSString *)URLString
                                           parameters:(id)parameters
                                             userInfo:(id)userInfo
                                          cachePolicy:(BHttpRequestCachePolicy)cachePolicy
                                              success:(void (^)(BHttpRequestOperation *operation, id data,bool isReadFromCache)) success
                                              failure:(void (^)(BHttpRequestOperation *operation, NSError *error)) failure
                                             progress:(void (^)(id operation,long long totalBytesRead, long long totalBytesExpectedToRead))progressBlock{
    NSMutableURLRequest *request = [self requestWithGETURL:URLString parameters:parameters];
    BHttpRequestOperation *operation =
    [self createHttpRequestOperationWithRequest:request
                             responseSerializer:[AFHTTPResponseSerializer serializer]
                                        success:^(BHttpRequestOperation *operation, id data, bool isReadFromCache) {
                                            if(success){
                                                NSString *fp = [operation cacheFilePath];
                                                success(operation,fp, [operation isReadFromCache]);
                                            }
                                            
                                        }
                                        failure:^(BHttpRequestOperation *operation, NSError *error) {
                                            if (failure) {
                                                failure(operation, error);
                                            }
                                        }
                                       progress:progressBlock];
    [operation setCacheHandler:[BHttpRequestCacheHandler handlerWithCachePolicy:cachePolicy]];
    operation.userInfo = userInfo;
    [self.operationQueue addOperation:operation];
    return operation;
    
}

@end
