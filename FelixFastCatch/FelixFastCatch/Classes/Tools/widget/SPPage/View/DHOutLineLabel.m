//
//  DHOutLineLabel.m
//  FastCatchKit
//
//  Created by user_ on 2017/12/3.
//  Copyright © 2017年 user_. All rights reserved.
//

#import "DHOutLineLabel.h"

@implementation DHOutLineLabel

- (void)drawTextInRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, self.outLineWidth);
    CGContextSetLineJoin(context, kCGLineJoinRound);
    CGContextSetTextDrawingMode(context, kCGTextStroke);
    self.textColor = self.outLineTextColor;
    [super drawTextInRect:rect];
    self.textColor = self.labelTextColor;
    CGContextSetTextDrawingMode(context, kCGTextFill);
    [super drawTextInRect:rect];
}


@end
