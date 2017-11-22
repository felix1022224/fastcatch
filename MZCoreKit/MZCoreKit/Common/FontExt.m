//
//  FontExt.m
//  MZCoreKit
//
//  Created by 卢凡 on 2017/11/21.
//  Copyright © 2017年 felix. All rights reserved.
//

#import "FontExt.h"
#import <CoreText/CoreText.h>

@implementation FontExt

+ (UIFont *) loadMyCustomFont:(NSString *)name size: (CGFloat)size {
    return [self loadMyCustomFont:name size:size type:@"ttf"];
}

+ (UIFont *) loadMyCustomFont:(NSString *)name size: (CGFloat)size type: (NSString *)type {
    NSString *fontPath = [[NSBundle bundleWithIdentifier:@"xcqromance.BookRoomKit"] pathForResource:name ofType:type];
    NSData *inData = [NSData dataWithContentsOfFile:fontPath];
    CFErrorRef error;
    CGDataProviderRef provider = CGDataProviderCreateWithCFData((__bridge CFDataRef)inData);
    CGFontRef font = CGFontCreateWithDataProvider(provider);
    if (! CTFontManagerRegisterGraphicsFont(font, &error)) {
        CFStringRef errorDescription = CFErrorCopyDescription(error);
        NSLog(@"Failed to load font: %@,%@", errorDescription,name);
        CFRelease(errorDescription);
    }
    CFRelease(font);
    CFRelease(provider);
    NSString *fontName = (__bridge NSString *)CGFontCopyPostScriptName(font);
    UIFont* uifont = [UIFont fontWithName:fontName size:size];
    return uifont;
}

@end
