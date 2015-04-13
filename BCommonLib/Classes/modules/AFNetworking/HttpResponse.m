//
//  RequestStatus.m
//  iLookForiPhone
//
//  Created by Zhang Yinghui on 12-9-12.
//  Copyright (c) 2012年 LavaTech. All rights reserved.
//

#import "HttpResponse.h"
NSString *HttpRequestDomain = @"X-Channel request error";
@implementation HttpResponse
+ (id)responseWithDictionary:(NSDictionary *)dict{
    HttpResponse *response = [[HttpResponse alloc] initWithDictionary:dict];
    return response;
}
- (id)initWithDictionary:(NSDictionary *)dict{
    if (self = [super init]) {
        if ([dict isKindOfClass:[NSDictionary class]]) {
            self.dict = [NSMutableDictionary dictionaryWithDictionary:dict];
        }
    }
    return self;
}
- (BOOL)isSuccess{
    return self.status == ResponseStatusCodeSuccess;
}
- (void)setDict:(NSMutableDictionary *)dict{
    ////
    _dict = [[NSMutableDictionary alloc] initWithDictionary:dict];
}
- (void)setMsg:(NSString *)msg{
    [self.dict setValue:msg forKey:@"msg"];
}
- (NSString *)msg{
    return [self.dict valueForKey:@"msg"];
}
- (void)setStatus:(ResponseStatusCode)status{
    [self.dict setValue:[NSNumber numberWithInt:status] forKey:@"status"];
}
- (ResponseStatusCode)status{
    return [[self.dict valueForKey:@"status"] intValue];
}
- (NSError *)error{
    if (self.isSuccess) {
        return nil;
    }
    NSDictionary *userInfo = @{NSLocalizedDescriptionKey:self.msg?self.msg:@""};
    NSError *error = [NSError errorWithDomain:HttpRequestDomain code:self.status userInfo:userInfo];
    return error;
}
- (id)data{
    return [self.dict valueForKey:@"data"] ;
}
@end
