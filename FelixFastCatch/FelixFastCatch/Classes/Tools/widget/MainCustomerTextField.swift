//
//  MainCustomerTextField.swift
//  FelixFastCatch
//
//  Created by 卢凡 on 2017/7/28.
//  Copyright © 2017年 felix. All rights reserved.
//

import UIKit

class MainCustomerTextField: UITextField {

    var outLineWidth:CGFloat!
    
    var outLienTextColor:UIColor!
    
    var outTextColor:UIColor!
    
    override func drawPlaceholder(in rect: CGRect) {
        
        let c = UIGraphicsGetCurrentContext()
        
        c!.setLineWidth(self.outLineWidth);
        
        c!.setLineJoin(CGLineJoin.round)
        
        c!.setTextDrawingMode(CGTextDrawingMode.stroke)
        
        self.attributedPlaceholder = NSAttributedString(string: placeholder!, attributes: [NSForegroundColorAttributeName: outLienTextColor])
        
        super.drawPlaceholder(in: rect)
        
        self.attributedPlaceholder = NSAttributedString(string: placeholder!, attributes: [NSForegroundColorAttributeName: outTextColor])
        
        c!.setTextDrawingMode(CGTextDrawingMode.fill)
        
        super.drawPlaceholder(in: rect)
    }
    
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: 15, dy: 0)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: 15, dy: 0)
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: 15, dy: 0)
    }

}
