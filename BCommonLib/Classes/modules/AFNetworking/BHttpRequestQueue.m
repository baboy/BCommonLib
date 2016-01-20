//
//  BHttpRequestQueue.m
//  Pods
//
//  Created by baboy on 1/18/16.
//
//

#import "BHttpRequestQueue.h"
@interface BHttpRequestQueue()
@end
@implementation BHttpRequestQueue
- (id)init{
    if (self = [super init]) {
        self.tasks = [NSMutableArray array];
    }
    return self;
}
//当前正在执行的程序数量
- (int)currentRunningTaskCount{
    int n = 0;
    for (int i=0; i<self.tasks.count; i++) {
        BHttpRequestTask *task = [self.tasks objectAtIndex:i];
        if (task.task.state == NSURLSessionTaskStateRunning) {
            ++n;
        }
    }
    return n;
}
- (void)enqueue:(BHttpRequestTask *)task{
    @synchronized(self.tasks) {
        [self.tasks addObject:task];
    }
    [self startNext];
}
- (BOOL)cancelTask:(BHttpRequestTask *)task{
    [task.task cancel];
    [self startNext];
    return YES;
}
- (void)removeTask:(BHttpRequestTask *)task{
    @synchronized(self.tasks) {
        [self.tasks removeObject:task];
    }
    [self startNext];
}
- (void)clearQueue{
    @synchronized(self.tasks) {
        for (int i=0; i<self.tasks.count; i++) {
            BHttpRequestTask *task = [self.tasks objectAtIndex:i];
            if (task.task.state == NSURLSessionTaskStateSuspended) {
                [task.task resume];
                break;
            }
        }
    }
}
- (void)startNext{
    @synchronized(self.tasks) {
        if([self currentRunningTaskCount] < self.maxConcurrentTaskCount){
            for (int i=0; i<self.tasks.count; i++) {
                BHttpRequestTask *task = [self.tasks objectAtIndex:i];
                if (task.task.state == NSURLSessionTaskStateSuspended) {
                    [task.task resume];
                    break;
                }
            }
            
        }
    }
}
@end


@implementation  BHttpRequestTask:NSObject
@end

@implementation  BHttpResponseHandler : NSObject
- (id)initWithUUID:(NSUUID *)uuid
           success:(nullable void (^)(id task, id data))success
           failure:(nullable void (^)(id task, id data, NSError* error))failure{
    if (self = [super init]) {
        self.uuid = uuid;
        self.successBlock = success;
        self.failureBlock = failure;
    }
    return self;
}
@end

@implementation  BHttpRequestRelativeTask:NSObject
- (id)initWithIdentifier:(NSString *)identifier task:(NSURLSessionTask *)task{
    if (self = [super init]) {
        self.identifier = identifier;
        self.task = task;
        self.handlers = [NSMutableArray array];
    }
    return self;
}
- (void)addHandler:(BHttpResponseHandler*)handler{
    [self.handlers addObject:handler];
}
- (void)removeHandler:(BHttpResponseHandler*)handler{
    [self.handlers removeObject:handler];
}
@end