//
//  DHImageView.m
//  FastCatchKit
//
//  Created by user_ on 2017/12/3.
//  Copyright © 2017年 user_. All rights reserved.
//

#import "DHImageView.h"

@interface DHImageView ()

#define WEAKSELF  __weak __typeof(self) weakSelf = self;

@property (nonatomic, strong) UIImage *networkImage;

@end

@implementation DHImageView


- (void)setImageUrl:(NSString *)imageUrlstr placeholderImage:(UIImage *)placeholderimage {
    self.placeholderImage = placeholderimage;
    self.imageUrlStr = imageUrlstr;
}

- (void)setImageUrlStr:(NSString *)imageUrl {
    if (!imageUrl) {
        return;
    }
    _imageUrlStr = imageUrl;
    NSURL *url = [NSURL URLWithString:imageUrl];
    if (!url) {
        return;
    }
    WEAKSELF
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:url options:0 error:nil]];
        dispatch_async(dispatch_get_main_queue(), ^{
            weakSelf.networkImage = image;
            weakSelf.image = self.networkImage;
        });
    });
}

- (void)setPlaceholderImage:(UIImage *)placeholderImage {
    _placeholderImage = placeholderImage;
    if (!self.networkImage) {
        self.image = placeholderImage;
    }
}

@end
