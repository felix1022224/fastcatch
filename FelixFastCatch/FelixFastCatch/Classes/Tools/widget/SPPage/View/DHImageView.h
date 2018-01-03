//
//  DHImageView.h
//  FastCatchKit
//
//  Created by user_ on 2017/12/3.
//  Copyright © 2017年 user_. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DHImageView : UIImageView

@property (nonatomic,strong) UIImage *placeholderImage;

@property (nonatomic, strong) NSString *imageUrlStr;

- (void)setImageUrl:(NSString *)imageUrlstr placeholderImage:(UIImage *)placeholderimage;

@end
