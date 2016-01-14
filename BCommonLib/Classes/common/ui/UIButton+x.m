//
//  UIButton+x.m
//  iLookForiPad
//
//  Created by baboy on 13-3-20.
//  Copyright (c) 2013年 baboy. All rights reserved.
//

#import "UIButton+x.h"
#import "BCommonLibContext.h"
#import "BCommonLibHttp.h"
#import "NSString+x.h"
#import "UIImageView+cache.h"


@implementation UIButton (x)
- (void)centerImageAndTitle:(float)spacing{
    CGSize imageSize = self.imageView.frame.size;
    CGSize titleSize = [self.titleLabel.text sizeWithFont:self.titleLabel.font];
    CGFloat totalHeight = (imageSize.height + titleSize.height + spacing);
    
    self.imageEdgeInsets = UIEdgeInsetsMake(- (totalHeight - imageSize.height), 0 , 0.0, -titleSize.width);
    self.titleEdgeInsets = UIEdgeInsetsMake(0.0, - imageSize.width, - (totalHeight - titleSize.height), 0.0);
}
- (void)centerImageAndTitle{
    [self centerImageAndTitle:3.0];
}
/*
- (void)setImageURLString:(NSString *)url background:(BOOL)flag forState:(UIControlState)state{
    if (!url) {
        return;
    }
    UIImage *image = nil;
    if ( [url fileExists] ) {
        image = [UIImage imageWithContentsOfFile:url];
    }else{
        NSString *fp = [UIImageView cachePathForURLString:url];
        if ([fp fileExists]) {
            image = [UIImage imageWithContentsOfFile:fp];
        }
    }
    if (image) {
        if (flag) {
            [self setBackgroundImage:image forState:state];
        }else{
            [self setImage:image forState:state];
        }
        return;
    }
    [[BHttpRequestManager defaultManager]
     download:url
     progress:^(NSProgress * _Nullable downloadProgress) {
         
     }
     completionHandler:^(NSURLResponse * _Nullable response, NSURL * _Nullable filePath, NSError * _Nullable error) {
         NSDictionary *userInfo = [operation userInfo];
         id object = userInfo?[userInfo valueForKey:@"object"]:nil;
         NSString *fp = [operation cacheFilePath];
         if (self == object) {
             UIControlState state = [[userInfo valueForKey:@"state"] intValue];
             UIImage *image = [UIImage imageWithContentsOfFile:fp];
             if (image){
                 if (flag) {
                     [self setBackgroundImage:image forState:state];
                 }else{
                     [self setImage:image forState:state];
                 }
             }
         }
     }];
    
    [[BHttpRequestManager defaultManager]
     cacheFileRequestWithURLRequest:url
     parameters:nil
     userInfo:@{@"object":self, @"state":[NSNumber numberWithInt:state]}
     success:^(BHttpRequestOperation *operation, id data, bool isReadFromCache) {
         
     }
     failure:^(BHttpRequestOperation *operation, NSError *error) {
         
         DLOG(@"[UIButton] setImageURL error:%@", error);
     }];
}
- (void)setImageURLString:(NSString *)url placeholder:(UIImage*)placeholder background:(BOOL)flag forState:(UIControlState)state{
    if (placeholder) {
        if (flag) {
            [self setBackgroundImage:placeholder forState:state];
        }else{
            [self setImage:placeholder forState:state];
        }
    }
    [self setImageURLString:url background:flag forState:state];
}
- (void)setImageURLString:(NSString *)url placeholder:(UIImage*)placeholder forState:(UIControlState)state{
    [self setImageURLString:url placeholder:placeholder background:NO forState:state];
}
- (void)setBackgroundImageURLString:(NSString *)url placeholder:(UIImage*)placeholder forState:(UIControlState)state{
    [self setImageURLString:url placeholder:placeholder background:YES forState:state];
}
- (void)setImageURLString:(NSString *)url forState:(UIControlState)state{
    [self setImageURLString:url placeholder:nil background:NO forState:state];
    
}
- (void)setBackgroundImageURLString:(NSString *)url forState:(UIControlState)state{
    [self setImageURLString:url placeholder:nil background:YES forState:state];
    
}
 */
@end