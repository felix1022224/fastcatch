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
    
    override func textRect(forBounds bounds: CGRect, limitedToNumberOfLines numberOfLines: Int) -> CGRect {
        let insets = UIEdgeInsetsMake(CGFloat(0), CGFloat(5), CGFloat(5), CGFloat(0))
        var rect = super.textRect(forBounds: UIEdgeInsetsInsetRect(bounds, insets), limitedToNumberOfLines: numberOfLines)
        rect.origin.x    -= insets.left + 2
        rect.origin.y    -= insets.top
        rect.size.width  += (insets.left + insets.right)
        rect.size.height += (insets.top + insets.bottom)
        return rect
    }
    
    // 让其有交互能力，并添加一个长按手势
    func setup() {
        isUserInteractionEnabled = true
        self.addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: #selector(clickLabel)))
    }
    
    @objc func clickLabel() {
        
        // 让其成为响应者
        becomeFirstResponder()
        
        // 拿出菜单控制器单例
        let menu = UIMenuController.shared
        // 创建一个复制的item
        let copy = UIMenuItem(title: "复制", action: #selector(copyText))
        // 将复制的item交给菜单控制器（菜单控制器其实可以接受多个操作）
        menu.menuItems = [copy]
        // 设置菜单控制器的点击区域为这个控件的bounds
        menu.setTargetRect(bounds, in: self)
        // 显示菜单控制器，默认是不可见状态
        menu.setMenuVisible(true, animated: true)
        
    }
    
    @objc func copyText() {
        let index = self.text?.index((self.text?.endIndex)!, offsetBy: -7)
        let subString = self.text?.prefix(upTo: index!)
        UIPasteboard.general.string = String(subString!)
    }
    
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        if action == #selector(copyText) {
            return true
        } else {
            return false
        }
    }
    
    override var canBecomeFirstResponder: Bool { return true }
    
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
