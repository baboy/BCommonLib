//
//  NSURLSessionTask+x.m
//  Pods
//
//  Created by baboy on 1/20/16.
//
//

#import "NSURLSessionTask+x.h"
#import <objc/runtime.h>

static char NSURLSessionTaskUserInfoKey;
@implementation NSURLSessionTask(x)

- (id)userInfo {
    return (id)objc_getAssociatedObject(self, &NSURLSessionTaskUserInfoKey);
}

- (void)setUserInfo:(id)userInfo{
    objc_setAssociatedObject(self, &NSURLSessionTaskUserInfoKey, userInfo, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
@end
