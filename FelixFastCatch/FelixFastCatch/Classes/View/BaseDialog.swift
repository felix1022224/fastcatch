//
//  BaseDialog.swift
//  FelixFastCatch
//
//  Created by 卢凡 on 2017/7/27.
//  Copyright © 2017年 felix. All rights reserved.
//

import UIKit

class BaseDialog: UIView {

    var keyWindow:UIWindow!
    
    // 背景透明色
    var shadow:UIControl!
    
    // 背景图片
    var backgroundImage:UIImageView!
    
    // 关闭按钮
    var closeBtn:UIButton!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        keyWindow = UIApplication.shared.keyWindow
    }
    
    // 创建view
    func createView() -> () {
        
    }
    
    open func createBackgroundImage(imageName:String) {
        backgroundImage = UIImageView()
        backgroundImage.image = UIImage(named: imageName)
        backgroundImage.sizeToFit()
        backgroundImage.center = self.center
        addSubview(backgroundImage)
    }
    
    // 添加view到window中
    func addDialogToWindow(){
        self.shadow = UIControl(frame: (keyWindow?.bounds)!)
        self.shadow.backgroundColor = UIColor.black
        self.shadow.alpha = 0.0
        keyWindow?.addSubview(self.shadow)
        keyWindow?.addSubview(self)
        
        self.isHidden = true
    }
    
    func addDidalogToWindowNoShadow() {
        keyWindow?.addSubview(self)
    }
    
    // 显示
    func show() -> () {
        self.transform = CGAffineTransform(scaleX: 1.2,y: 1.2);
        UIView.animate(withDuration: 0.4) { [weak self] in
            self?.shadow.alpha = 0.5
            self?.isHidden = false
            self?.transform = CGAffineTransform(scaleX: 1,y: 1)
        }
    }
    
    // 隐藏
    func hide() -> () {
        UIView.animate(withDuration: 0.3) { [weak self] in
            self?.shadow.alpha = 0.0
            self?.transform = CGAffineTransform(scaleX: 0.0,y: 0.0)
        }
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.31) { [weak self] in
            self?.shadow.removeFromSuperview()
            self?.removeFromSuperview()
            for subview in (self?.subviews)! {
                subview.removeFromSuperview()
            }
        }
        
    }
    
    func addOnClickListener(toView:UIView, target: AnyObject, action: Selector) {
        let gr = UITapGestureRecognizer(target: target, action: action)
        gr.numberOfTapsRequired = 1
        toView.addGestureRecognizer(gr)
    }
    
    func createCloseBtn() -> () {
        // 关闭按钮
        closeBtn = UIButton(type: .custom)
        let closeImage = UIImage(named: "icon_close")
        closeBtn.setBackgroundImage(closeImage, for: .normal)
        closeBtn.frame = CGRect(x: self.bounds.width/2 + backgroundImage.bounds.width/2 - 18, y: self.bounds.height/2 - backgroundImage.bounds.height/2 + 18, width:27, height: 27)
        addSubview(closeBtn)
        closeBtn.addTarget(self, action: #selector(hide), for: .touchUpInside)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
