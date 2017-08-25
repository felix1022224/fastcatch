//
//  MainCustomerLabel.swift
//  FelixFastCatch
//
//  Created by 卢凡 on 2017/7/26.
//  Copyright © 2017年 felix. All rights reserved.
//

import UIKit


/// 自定义描边文字
class MainCustomerLabel: UILabel {

    var outLineWidth:CGFloat!
    
    var outLienTextColor:UIColor!
    
    var outTextColor:UIColor!
    
    override func drawText(in rect: CGRect) {
        
        let c = UIGraphicsGetCurrentContext()
        
        c!.setLineWidth(self.outLineWidth);
        
        c!.setLineJoin(CGLineJoin.round)
        
        c!.setTextDrawingMode(CGTextDrawingMode.stroke)
        
        self.textColor = outLienTextColor;
        
        super.drawText(in: rect)
        
        self.textColor = outTextColor;
        
        c!.setTextDrawingMode(CGTextDrawingMode.fillClip)
        
        super.drawText(in: rect)
    }
    
    override func textRect(forBounds bounds: CGRect, limitedToNumberOfLines numberOfLines: Int) -> CGRect {
        let insets = UIEdgeInsetsMake(CGFloat(0), CGFloat(5), CGFloat(5), CGFloat(0))
        var rect = super.textRect(forBounds: UIEdgeInsetsInsetRect(bounds, insets), limitedToNumberOfLines: numberOfLines)
        rect.origin.x    -= insets.left + 2
        rect.origin.y    -= insets.top
        rect.size.width  += (insets.left + insets.right)
        rect.size.height += (insets.top + insets.bottom)
        return rect
    }
    
//    override func textRect(forBounds bounds: CGRect, limitedToNumberOfLines numberOfLines: Int) -> CGRect {
////        var insets = UIEdgeInsets.zero
////        insets.left = 10
////        insets.right = 5
////        var rect = super.textRect(forBounds: UIEdgeInsetsInsetRect(bounds, insets), limitedToNumberOfLines: numberOfLines)
////        rect.origin.x    -= insets.left
////        rect.origin.y    -= insets.top
////        rect.size.width  += (insets.left + insets.right - 5)
////        rect.size.height += (insets.top + insets.bottom)
//        
//        var uiedgeInsets = UIEdgeInsetsMake(CGFloat(0), CGFloat(5), CGFloat(5), CGFloat(0))
//        return super.textRect(forBounds: UIEdgeInsetsInsetRect(bounds, uiedgeInsets), limitedToNumberOfLines: numberOfLines)
//    }
    
    
}
