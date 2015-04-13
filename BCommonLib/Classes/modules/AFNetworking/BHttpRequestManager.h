//
//  BHttpRequestManager.h
//  BCommon
//
//  Created by baboy on 4/1/15.
//  Copyright (c) 2015 baboy. All rights reserved.
//
#import <Foundation/Foundation.h>
#import "AFNetworking.h"
#import "BHttpRequestOperation.h"


@interface BHttpRequestManager : AFHTTPRequestOperationManager

+ (id)defaultManager;
- (NSMutableURLRequest *)requestWithPOSTURL:(NSString *)url parameters:(NSDictionary *)parameters;
- (NSMutableURLRequest *)requestWithGETURL:(NSString *)url parameters:(NSDictionary *)parameters;
- (BHttpRequestOperation *)createHttpRequestOperationWithRequest:(NSURLRequest *)request
                                              responseSerializer:(AFHTTPResponseSerializer *)responseSerializer
                                                        callback:(void (^)(BHttpRequestOperation *operation, id data,bool isReadFromCache,NSError *error)) callback;


// json request with get
- (BHttpRequestOperation *)jsonRequestOperationWithGetRequest:(NSString *)URLString
                                                   parameters:(id)parameters
                                                     userInfo:(id)userInfo
                                                     cachePolicy:(BHttpRequestCachePolicy)cachePolicy
                                                     callback:(void (^)(BHttpRequestOperation *operation, id data,bool isReadFromCache,NSError *error)) callback;

- (BHttpRequestOperation *)jsonRequestOperationWithGetRequest:(NSString *)URLString
                                                   parameters:(id)parameters
                                                  cachePolicy:(BHttpRequestCachePolicy)cachePolicy
                                                     callback:(void (^)(BHttpRequestOperation *operation, id data,bool isReadFromCache,NSError *error)) callback;

- (BHttpRequestOperation *)jsonRequestOperationWithGetRequest:(NSString *)URLString
                                                   parameters:(id)parameters
                                                     callback:(void (^)(BHttpRequestOperation *operation, id data,bool isReadFromCache,NSError *error)) callback;


// json request with post
- (BHttpRequestOperation *)jsonRequestOperationWithPostRequest:(NSString *)URLString
                                                    parameters:(id)parameters
                                                      userInfo:(id)userInfo
                                                   cachePolicy:(BHttpRequestCachePolicy)cachePolicy
                                                       callback:(void (^)(BHttpRequestOperation *operation, id data,bool isReadFromCache,NSError *error)) callback;

- (AFHTTPRequestOperation *)jsonRequestOperationWithPostRequest:(NSString *)URLString
                                                     parameters:(id)parameters
                                                    cachePolicy:(BHttpRequestCachePolicy)cachePolicy
                                                       callback:(void (^)(BHttpRequestOperation *operation, id data,bool isReadFromCache,NSError *error)) callback;
- (BHttpRequestOperation *)jsonRequestOperationWithPostRequest:(NSString *)URLString
                                                    parameters:(id)parameters
                                                       callback:(void (^)(BHttpRequestOperation *operation, id data,bool isReadFromCache,NSError *error)) callback;

// data request with get

- (BHttpRequestOperation *)dataRequestWithURLRequest:(NSString *)URLString
                                          parameters:(id)parameters
                                            userInfo:(id)userInfo
                                         cachePolicy:(BHttpRequestCachePolicy)cachePolicy
                                             callback:(void (^)(BHttpRequestOperation *operation, id data,bool isReadFromCache,NSError *error)) callback;
- (BHttpRequestOperation *)dataRequestWithURLRequest:(NSString *)URLString
                                          parameters:(id)parameters
                                             callback:(void (^)(BHttpRequestOperation *operation, id data,bool isReadFromCache,NSError *error)) callback;


// file request with get
- (BHttpRequestOperation *)fileRequestWithURLRequest:(NSString *)URLString
                                          parameters:(id)parameters
                                            userInfo:(id)userInfo
                                         cachePolicy:(BHttpRequestCachePolicy)cachePolicy
                                             callback:(void (^)(BHttpRequestOperation *operation, id data,bool isReadFromCache,NSError *error)) callback;
- (BHttpRequestOperation *)cacheFileRequestWithURLRequest:(NSString *)URLString
                                          parameters:(id)parameters
                                             callback:(void (^)(BHttpRequestOperation *operation, id data,bool isReadFromCache,NSError *error)) callback;
@end
