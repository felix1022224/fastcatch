//
//  SPMainTagView.m
//  Radio
//
//  Created by WealongCai on 15/12/10.
//  Copyright (c) 2015年 qzone. All rights reserved.
//

#import "SPPageTagView.h"


@interface SPPageTagView()
@property (nonatomic, assign, readwrite) BOOL isHighlighted;
@end


@implementation SPPageTagView

- (void)highlightTagView
{
    NSException *exception = [NSException exceptionWithName:@"Method no override Exception" reason:@"Method highlightTagView must be override!" userInfo:nil];
    @throw exception;
}

- (void)unhighlightTagView
{
    NSException *exception = [NSException exceptionWithName:@"Method no override Exception" reason:@"Method unhighlightTagView must be override!" userInfo:nil];
    @throw exception;
}

@end

@implementation SPPageTagTitleView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.frame = frame;
        
        self.contentView = [TabContentView new];
        self.contentView.userInteractionEnabled = YES;
        
        UIImageView * testImage = [UIImageView new];
        testImage.image = [UIImage imageNamed:@"普通抓"];
        [testImage sizeToFit];
        
        self.titleImage = [DHImageView new];
//        self.titleImage.image = [UIImage imageNamed:@"普通抓"];
//        [self.titleImage sizeToFit];
//        [self.titleImage setHidden:true];
        self.titleImage.frame = CGRectMake(0, 0, testImage.bounds.size.width, testImage.bounds.size.height);
        
        self.title = [DHOutLineLabel new];

        [self.title setOutLineWidth:2];
        [self.title setOutLineTextColor:[UIColor colorWithRed:160/255.0 green:123/255.0 blue:80/255.0 alpha:1.0]];
        [self.title setLabelTextColor:[UIColor whiteColor]];
        
        self.title.backgroundColor = [UIColor clearColor];
        
        self.title.textAlignment = NSTextAlignmentCenter;
        self.title.frame = CGRectMake(self.titleImage.bounds.size.width + 5, self.title.bounds.origin.y, self.title.frame.size.width, self.title.bounds.size.height);
        
        [self.contentView addSubview:self.titleImage];
        
        [self addSubview:self.contentView];
    }
    return self;
}

- (void)setHighlightedTitleColor:(UIColor *)highlightedTitleColor
{
    [super setHighlightedTitleColor:highlightedTitleColor];
}

- (void)setNormalTitleColor:(UIColor *)normalTitleColor
{
    [super setNormalTitleColor:normalTitleColor];
}


- (void)highlightTagView
{
    self.title.textColor = self.highlightedTitleColor;
    self.isHighlighted = YES;
}

- (void)unhighlightTagView
{
    self.title.textColor = self.normalTitleColor ;
    self.isHighlighted = NO;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [_title sizeToFit];
//    [_titleImage sizeToFit];
    _contentView.frame = CGRectMake(0, 0, _titleImage.bounds.size.width, _titleImage.bounds.size.height);
    _contentView.center = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
}

@end


