//
//  Conf.m
//  iLookForiPhone
//
//  Created by Yinghui Zhang on 6/6/12.
//  Copyright (c) 2012 LavaTech. All rights reserved.
//

#import "AppContext.h"
#import "BCommonLibDao.h"

@implementation AppContext

+ (BOOL) setNs:(NSString *)ns{
    return [DBCache setValue:ns forKey:@"app_namespace"];
}
+ (NSString *)ns{
    return [DBCache valueForKey:@"app_namespace"];
}
+ (void) setDeviceToken:(NSString *)deviceToken{
    [DBCache setValue:deviceToken forKey:@"device_token"];
}
+ (NSString *) deviceToken{
    return [DBCache valueForKey:@"device_token"];
}
@end
