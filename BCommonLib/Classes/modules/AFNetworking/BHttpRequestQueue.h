//
//  BHttpRequestQueue.h
//  Pods
//
//  Created by baboy on 1/18/16.
//
//



@interface BHttpRequestTask:NSObject
@property (nonatomic, strong) NSURLSessionTask *_Nullable task;
@property (nonatomic, strong) NSUUID *_Nonnull leuuid;
@end

@interface BHttpResponseHandler : NSObject
@property (nonatomic, strong) NSUUID *_Nonnull uuid;
@property (nonatomic, copy) void (^_Nullable successBlock )(id _Nullable task, id _Nullable data);
@property (nonatomic, copy) void (^_Nullable failureBlock)(id _Nullable task, id _Nullable data, NSError* _Nullable error);
- (id _Nonnull)initWithUUID:(NSUUID *_Nullable)uuid
           success:(nullable void (^)(id _Nullable task, id _Nullable data))success
           failure:(nullable void (^)(id _Nullable task, id _Nullable data, NSError* _Nullable error))failure;
@end
@interface BHttpRequestRelativeTask:NSObject
@property (nonatomic, strong) NSString * _Nullable identifier;
@property (nonatomic, strong) NSURLSessionTask * _Nullable task;
@property (nonatomic, strong) NSMutableArray * _Nullable handlers;
- (id _Nonnull)initWithIdentifier:(NSString *_Nullable)identifier task:(NSURLSessionTask *_Nullable)task;
- (void)addHandler:(BHttpResponseHandler*_Nullable)handler;
- (void)removeHandler:(BHttpResponseHandler*_Nullable)handler;
@end


@interface BHttpRequestQueue : NSObject
@property (nonatomic, strong) NSMutableArray *tasks;
@property (nonatomic, assign) int maxConcurrentTaskCount;
- (void)enqueue:(BHttpRequestTask *)task;
- (BOOL)cancelTask:(BHttpRequestTask *)task;
@end
