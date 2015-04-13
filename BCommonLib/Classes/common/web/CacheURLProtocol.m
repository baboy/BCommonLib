//
//  CacheURLProtocol.m
//  iLook
//
//  Created by Yinghui Zhang on 2/26/12.
//  Copyright (c) 2012 LavaTech. All rights reserved.
//

#import "CacheURLProtocol.h"
#import "Base64.h"
#import "BCommonLibHttp.h"
#import "Global.h"

@interface CacheURLProtocol()
@property(nonatomic, retain) BHttpRequestOperation *cacheOperation;
@end

@implementation CacheURLProtocol
+ (BOOL)canInitWithRequest:(NSURLRequest *)request{
    DLOG(@"%@",request);
    if ([request respondsToSelector:@selector(setValue:forHTTPHeaderField:)]) {
        [(NSMutableURLRequest*)request setValue:@"Mozilla/5.0 (iPad; U; CPU OS 3_2 like Mac OS X; en-us) AppleWebKit/531.21.10 (KHTML, like Gecko) Version/4.0.4 Mobile/7B334b Safari/531.21.10" forHTTPHeaderField:@"User-Agent"];
    }
    NSString *scheme = [[request URL] scheme];
    return ([scheme isEqualToString:CacheSchemeName]);
}

+ (NSURLRequest *)canonicalRequestForRequest:(NSURLRequest *)request{
    return request;
}

// Called when URL loading system initiates a request using this protocol. Initialise input stream, buffers and decryption engine.
- (void)startLoading{    
    NSURL *cacheURL = [self.request URL];
    NSString *urlString = [cacheURL httpURLString];
    NSURL *reqURL = [NSURL URLWithString:urlString];
    
    BHttpRequestCacheHandler *cache = [BHttpRequestCacheHandler fileCacheHandler];
    NSData *data = [cache cacheDataForURL:reqURL];
    if (data) {
        [self.client URLProtocol:self didLoadData:data];
        [self.client URLProtocolDidFinishLoading:self];
        return;
    }
    BHttpRequestOperation *operation =
    [[BHttpRequestManager defaultManager]
     fileRequestWithURLRequest:urlString
     parameters:nil
     success:^(BHttpRequestOperation *operation, id data) {
         data = [operation responseData];
         [self.client URLProtocol:self didLoadData:data];
         [self.client URLProtocolDidFinishLoading:self];
     }
     failure:^(BHttpRequestOperation *operation, NSError *error) {
         
         [self.client URLProtocol:self didFailWithError:error];
     }];
    self.cacheOperation = operation;
}

// Called by URL loading system in response to normal finish, error or abort. Cleans up in each case.
- (void)stopLoading{
    //DLOG(@"stopLoading...:%d",[[cacheRequest responseData] length]);
    if (self.cacheOperation) {
        [self.cacheOperation cancel];
    }
    self.cacheOperation = nil;
}
- (void)dealloc{  
    if (self.cacheOperation) {
        [self.cacheOperation cancel];
    }
    //_cacheOperation ;
    //[super dealloc];
}
@end


@implementation NSURL(cache)

+ (NSString*) URLStringWithScheme:(NSString *)scheme urlString:(NSString*)urlString{    
    NSString *base64 = [Base64 stringByWebSafeEncodeString:urlString];
    NSString *url = [NSString stringWithFormat:@"%@://%@",scheme,base64];
    return url;
}
+ (NSString *) cacheImageURLString:(NSString *)urlString{    
    return [self URLStringWithScheme:CacheSchemeName urlString:urlString];

}
+ (NSURL*) cacheImageURLWithString:(NSString *)urlString{
    return [NSURL URLWithString:[self cacheImageURLString:urlString]];
}

+ (NSURL *) imageURLWithString:(NSString *)urlString{
    return [NSURL URLWithString:[NSURL URLStringWithScheme:ImageScheme urlString:urlString]];
}
+ (NSURL *) videoURLWithString:(NSString *)urlString{    
    return [NSURL URLWithString:[NSURL URLStringWithScheme:VideoScheme urlString:urlString]];
}
+ (BOOL) isCacheImageURL:(NSURL *)url{
    if (url && [[url absoluteString] hasPrefix:[NSString stringWithFormat:@"%@://",CacheSchemeName]]) {
        return YES;
    }
    return NO;
}

- (BOOL) isImageURL{
    return  [[self absoluteString] hasPrefix:[NSString stringWithFormat:@"%@://",ImageScheme]];
}
- (BOOL) isVideoURL{    
    return [[self absoluteString] hasPrefix:[NSString stringWithFormat:@"%@://",VideoScheme]];
}
- (NSString *)httpURLString{
    NSString *urlString = [Base64 stringByWebSafeDecodeString:[self host]];
    urlString = [urlString stringByReplacingOccurrencesOfString:@"&amp;" withString:@"&"];
    return urlString;
}
+ (NSString *)imageScheme{
    return ImageScheme;
}
+ (NSString *)videoScheme{
    return VideoScheme;
}
@end

