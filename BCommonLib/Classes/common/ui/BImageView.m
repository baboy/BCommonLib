//
//  BImageView.m
//  iLook
//
//  Created by Zhang Yinghui on 7/10/11.
//  Copyright 2011 LavaTech. All rights reserved.
//

#import "BImageView.h"
#import "BCommonLibContext.h"
#import "BCommonLibCategories.h"

#define BImgViewTitleFont			[UIFont boldSystemFontOfSize:12]
#define BImgViewTitleColor			[UIColor whiteColor]
#define BImgViewTitleShadowColor	[UIColor blackColor]


@interface BImageView()
- (void) handleTap:(UIGestureRecognizer *)recognizer;
- (void) createSubviews;
@end

@implementation BImageView

- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code.
        self.titleHeight = 20;
		self.backgroundColor = [UIColor clearColor];
		self.clipsToBounds = YES;
        [self createSubviews];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame imageURL:(NSString *)url{	
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code.
        self.titleHeight = 20;
		self.backgroundColor = [UIColor clearColor];
		self.clipsToBounds = YES;
        [self createSubviews];
		[self setImageURL:url];
    }
    return self;
}
- (void) createSubviews{
    _imgView = [[UIImageView alloc] initWithFrame:self.bounds];
    _imgView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _imgView.clipsToBounds = YES;
    [_imgView setContentMode:UIViewContentModeScaleAspectFill];
    [self addSubview:_imgView];
    
    _titleLabel = createLabel(CGRectZero, BImgViewTitleFont, [UIColor clearColor], BImgViewTitleColor, BImgViewTitleShadowColor, CGSizeMake(0, 1), NSTextAlignmentCenter, 1, NSLineBreakByTruncatingTail);
    _titleLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self addSubview:_titleLabel];
    
    CGRect rect = CGRectMake(0, self.bounds.size.height-12, self.bounds.size.width, 12);
    _progressView = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
    [_progressView setFrame:CGRectInset(rect, 5, 0)];
    _progressView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth;
    [_progressView setHidden:YES];
    [self addSubview:_progressView];
}
- (void)setFrame:(CGRect)frame{
	if (CGRectEqualToRect(frame, self.frame)) {
		return;
	}
	[super setFrame:frame];
    [self setNeedsLayout];
}
- (void)setTitleStyle:(BImageTitleStyle)titleStyle{
    _titleStyle = titleStyle;
    [self setNeedsLayout];
}
- (void) setPadding:(float)padding{
	_padding = padding;	
    [self setNeedsLayout];
}
- (void) addTarget:(id)target action:(SEL)action{
	if (target && action) {		
		_target = target;
		_action = action;
		UITapGestureRecognizer *tap = /*AUTORELEASE*/([[UITapGestureRecognizer alloc] initWithTarget: self action: @selector(handleTap:)]);
		[self addGestureRecognizer:tap];
	}
}
- (void) handleTap:(UIGestureRecognizer *)recognizer{
	if (recognizer.state == UIGestureRecognizerStateEnded) {
		if (_target && _action) {
			[_target performSelector:_action withObject:self afterDelay:0];
		}
	}
}
- (void) setImageLocalPath:(NSString *)fp{
	_imageLocalPath = nil;
	_imageLocalPath = fp;
	[_imgView setImage:[UIImage imageWithContentsOfFile:fp]];
}
- (void) setImageURL:(NSString *)imgUrl{
    [self.imgView setImageURL:[NSURL URLWithString:imgUrl]];
	
}
- (void) showProgress:(BOOL)showProgress{
    [_progressView setHidden:!showProgress];
}
- (void)setRadius:(float)rad{
    [self.layer setCornerRadius:rad];
    [_imgView.layer setCornerRadius:rad];
}
- (void) layoutSubviews{
    [super layoutSubviews];
    CGRect rect = self.bounds;
    if (_titleStyle == BImageTitleStyleBelow) {
        rect.size.height -= self.titleHeight;
    }
    [_imgView setFrame:CGRectInset(rect, _padding, _padding)];
    rect = CGRectMake(0, self.bounds.size.height-self.titleHeight, self.bounds.size.width, self.titleHeight);
    [_titleLabel setFrame:rect];
    rect.origin.y -= 12;;
    rect.size.height=12;
    [_progressView setFrame:CGRectInset(rect, 3, 0)];
}
- (void)dealloc {
	//[_object release];
	//[_imageURL release];
	//[_imageLocalPath release];
    //[_imgView release];
    //[_progressView release];
    //[super dealloc];
}


@end
