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
                                                         success:(void (^)(BHttpRequestOperation *operation, id data,bool isReadFromCache)) success
                                                         failure:(void (^)(BHttpRequestOperation *operation, NSError *error)) failure;


// json request with get
- (BHttpRequestOperation *)jsonRequestOperationWithGetRequest:(NSString *)URLString
                                                   parameters:(id)parameters
                                                     userInfo:(id)userInfo
                                                  cachePolicy:(BHttpRequestCachePolicy)cachePolicy
                                                      success:(void (^)(BHttpRequestOperation *operation, id data,bool isReadFromCache)) success
                                                      failure:(void (^)(BHttpRequestOperation *operation, NSError *error)) failure;

- (BHttpRequestOperation *)jsonRequestOperationWithGetRequest:(NSString *)URLString
                                                   parameters:(id)parameters
                                                  cachePolicy:(BHttpRequestCachePolicy)cachePolicy
                                                      success:(void (^)(BHttpRequestOperation *operation, id data,bool isReadFromCache)) success
                                                      failure:(void (^)(BHttpRequestOperation *operation, NSError *error)) failure;

- (BHttpRequestOperation *)jsonRequestOperationWithGetRequest:(NSString *)URLString
                                                   parameters:(id)parameters
                                                      success:(void (^)(BHttpRequestOperation *operation, id data,bool isReadFromCache)) success
                                                      failure:(void (^)(BHttpRequestOperation *operation, NSError *error)) failure;


// json request with post
- (BHttpRequestOperation *)jsonRequestOperationWithPostRequest:(NSString *)URLString
                                                    parameters:(id)parameters
                                                      userInfo:(id)userInfo
                                                   cachePolicy:(BHttpRequestCachePolicy)cachePolicy
                                                       success:(void (^)(BHttpRequestOperation *operation, id data,bool isReadFromCache)) success
                                                       failure:(void (^)(BHttpRequestOperation *operation, NSError *error)) failure;;

- (AFHTTPRequestOperation *)jsonRequestOperationWithPostRequest:(NSString *)URLString
                                                     parameters:(id)parameters
                                                    cachePolicy:(BHttpRequestCachePolicy)cachePolicy
                                                        success:(void (^)(BHttpRequestOperation *operation, id data,bool isReadFromCache)) success
                                                        failure:(void (^)(BHttpRequestOperation *operation, NSError *error)) failure;

- (BHttpRequestOperation *)jsonRequestOperationWithPostRequest:(NSString *)URLString
                                                    parameters:(id)parameters
                                                       success:(void (^)(BHttpRequestOperation *operation, id data,bool isReadFromCache)) success
                                                       failure:(void (^)(BHttpRequestOperation *operation, NSError *error)) failure;

// data request with get

- (BHttpRequestOperation *)dataRequestWithURLRequest:(NSString *)URLString
                                          parameters:(id)parameters
                                            userInfo:(id)userInfo
                                         cachePolicy:(BHttpRequestCachePolicy)cachePolicy
                                             success:(void (^)(BHttpRequestOperation *operation, id data,bool isReadFromCache)) success
                                             failure:(void (^)(BHttpRequestOperation *operation, NSError *error)) failure;
- (BHttpRequestOperation *)dataRequestWithURLRequest:(NSString *)URLString
                                          parameters:(id)parameters
                                             success:(void (^)(BHttpRequestOperation *operation, id data,bool isReadFromCache)) success
                                             failure:(void (^)(BHttpRequestOperation *operation, NSError *error)) failure;


// file request with get
- (BHttpRequestOperation *)fileRequestWithURLRequest:(NSString *)URLString
                                          parameters:(id)parameters
                                            userInfo:(id)userInfo
                                         cachePolicy:(BHttpRequestCachePolicy)cachePolicy
                                             success:(void (^)(BHttpRequestOperation *operation, id data,bool isReadFromCache)) success
                                             failure:(void (^)(BHttpRequestOperation *operation, NSError *error)) failure;

- (BHttpRequestOperation *)cacheFileRequestWithURLRequest:(NSString *)URLString
                                               parameters:(id)parameters
                                                  success:(void (^)(BHttpRequestOperation *operation, id data,bool isReadFromCache)) success
                                                  failure:(void (^)(BHttpRequestOperation *operation, NSError *error)) failure;
- (BHttpRequestOperation *)cacheFileRequestWithURLRequest:(NSString *)URLString
                                               parameters:(id)parameters
                                                 userInfo:(id)userInfo
                                                  success:(void (^)(BHttpRequestOperation *operation, id data,bool isReadFromCache)) success
                                                  failure:(void (^)(BHttpRequestOperation *operation, NSError *error)) failure;



- (BHttpRequestOperation *)downloadFileWithURLRequest:(NSString *)URLString
                                           parameters:(id)parameters
                                             userInfo:(id)userInfo
                                          cachePolicy:(BHttpRequestCachePolicy)cachePolicy
                                              success:(void (^)(BHttpRequestOperation *operation, id data,bool isReadFromCache)) success
                                              failure:(void (^)(BHttpRequestOperation *operation, NSError *error)) failure
                                             progress:(void (^)(id operation,long long totalBytesRead, long long totalBytesExpectedToRead))progressBlock;
@end
