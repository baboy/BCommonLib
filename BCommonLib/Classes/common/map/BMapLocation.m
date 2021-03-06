//
//  CourseLocation.m
//  course
//
//  Created by Yinghui Zhang on 8/23/12.
//  Copyright (c) 2012 LavaTech. All rights reserved.
//

#import "BMapLocation.h"
#import "Global.h"
#import "BCommonLibHttp.h"
#import "Utils.h"
#import "BApi.h"
#import "NSString+x.h"

@implementation BMapLocation
@synthesize address = _address;
@synthesize province = _province;
@synthesize country = _country;
@synthesize district = _district;
@synthesize city = _city;
@synthesize latitude;
@synthesize longitude;
- (void)dealloc{
    ////
    ////
    ////
    ////
    ////
    //[super dealloc];
}

- (id)initWithGeoData:(NSDictionary *)dict{
    if (self = [super init]) {
        [self setAddress:[dict valueForKey:@"formatted_address"]];
        NSDictionary *location = [dict valueForKeyPath:@"geometry.location"];
        if (location) {
            [self setLatitude:[[location valueForKey:@"lat"] doubleValue]];
            [self setLongitude:[[location valueForKey:@"lng"] doubleValue]];
        }
        NSArray *address_components = [dict valueForKey:@"address_components"];
        NSInteger n = [address_components count];
        NSString *city = nil;
        if ( n > 0) {
            for (int i=0; i<n; i++) {
                NSDictionary *component = [address_components objectAtIndex:i];
                NSArray *types = [component valueForKey:@"types"];
                NSString *locality = [types count] > 0 ? [types objectAtIndex:0] : nil;
                if ([locality isEqual:@"sublocality"]) {
                    city = [component valueForKey:@"long_name"];
                }
                if ([locality isEqual:@"locality"]) {
                    city = [component valueForKey:@"long_name"];
                    break;
                }
            }
        }
        [self setCity:city];
    }
    return self;
}
- (id)initWithDictionary:(NSDictionary *)dict{
    if (self = [super init]) {
        [self setAddress:[dict valueForKey:@"address"]];
        [self setCity:[dict valueForKey:@"city"]];
        [self setLatitude:[[dict valueForKey:@"latitude"] doubleValue]];
        [self setLongitude:[[dict valueForKey:@"longitude"] doubleValue]];
    }
    return self;
}
- (NSDictionary *)dict{
    NSMutableDictionary *d = [NSMutableDictionary dictionaryWithCapacity:3];
    if (self.address)
        [d setValue:self.address forKey:@"address"];
    [d setValue:self.country forKey:@"country"];
    [d setValue:self.city forKey:@"city"];
    [d setValue:self.district forKey:@"district"];
    [d setValue:self.province forKey:@"province"];
    [d setValue:[NSNumber numberWithDouble:self.latitude] forKey:@"latitude"];
    [d setValue:[NSNumber numberWithDouble:self.longitude] forKey:@"longitude"];
    return d;
}
+ (BMapLocation *)currentLocation{
    return [G valueForKey:@"location"];
}
+ (void)saveCurrentLocation:(BMapLocation *)location{
    [G setValue:location forKey:@"location"];
    NSString *currentAddress = [NSString stringWithFormat:@"%@%@%@", [location country]?[location country]:@"", [location province]?[location province]:@"",([location city] && ![[location city] isEqualToString:[location province]])?[location city]:@""];
    [G setValue:currentAddress forKey:@"CurrentAdress"];
}
+ (BHttpRequestOperation *)getLocationByIpSuccess:(void (^)(BMapLocation *loc))success failure:(void (^)(NSError *error))failure{
    return [[BHttpRequestManager defaultManager]
            getJson:@"http://int.dpool.sina.com.cn/iplookup/iplookup.php?format=json"
            parameters:nil
            success:^(id  _Nonnull task, id  _Nullable json) {
                BMapLocation *loc = nil;
                if (json) {
                    loc = [[BMapLocation alloc] init];
                    loc.country = [json valueForKey:@"country"];
                    loc.province = [json valueForKey:@"province"];
                    loc.city = [json valueForKey:@"city"];
                    loc.district = [json valueForKey:@"district"];
                }
            }
            failure:^(id  _Nullable task, id  _Nullable json, NSError * _Nonnull error) {
                if (failure) {
                    failure(error);
                }
            }];
}
+ (BHttpRequestOperation *)search:(NSString *)location success:(void (^)(id task,NSArray *locs, NSError *error))success failure:(void (^)(id task, NSError *error))failure{
    NSString *url = [ApiQueryLocation URLStringWithParam:@{@"q":location}];
    return [[BHttpRequestManager defaultManager]
     getJson:url
            parameters:nil
            success:^(id  _Nonnull task, id  _Nullable json) {
                HttpResponse *response = [HttpResponse responseWithDictionary:json];
                NSMutableArray *addrs = nil;
                NSError *error = nil;
                if (response.isSuccess) {
                    NSArray *list = response.data;
                    if ([list isKindOfClass:[NSArray class]]) {
                        addrs = [NSMutableArray array];
                        NSInteger n = [list count];
                        for (int i=0; i<n; i++) {
                            BMapLocation *loc = /*AUTORELEASE*/([[BMapLocation alloc] initWithGeoData:[list objectAtIndex:i]]);
                            [addrs addObject:loc];
                        }
                    }
                }
                if ( !addrs || [addrs count] ==0 ) {
                    NSDictionary *userInfo = @{NSLocalizedDescriptionKey:NSLocalizedString(@"未获取到地址信息", nil)};
                    error = [NSError errorWithDomain:HttpRequestDomain code:-1 userInfo:userInfo];
                }
                success(task, addrs, error);

            }
            failure:^(id  _Nullable task, id  _Nullable json, NSError * _Nonnull error) {
                failure(task, error);
            }];
}
@end
