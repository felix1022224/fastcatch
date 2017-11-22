//
//  FontExt.h
//  MZCoreKit
//
//  Created by 卢凡 on 2017/11/21.
//  Copyright © 2017年 felix. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FontExt : NSObject

+ (UIFont *)loadMyCustomFont:(NSString *)name size: (CGFloat)size;
+ (UIFont *)loadMyCustomFont:(NSString *)name size: (CGFloat)size type: (NSString *)type;

@end
