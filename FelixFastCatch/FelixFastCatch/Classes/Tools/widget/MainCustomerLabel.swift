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
        
        c!.setTextDrawingMode(CGTextDrawingMode.fill)
        
        super.drawText(in: rect)
        
    }
    
}
