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

+ (BOOL) ns:(NSString *)ns{
    return [DBCache setValue:ns forKey:@"app_namespace"];
}
+ (NSString *)ns{
    return [DBCache valueForKey:@"app_namespace"];
}
@end
