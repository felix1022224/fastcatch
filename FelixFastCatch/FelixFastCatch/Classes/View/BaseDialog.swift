//
//  BaseDialog.swift
//  FelixFastCatch
//
//  Created by 卢凡 on 2017/7/27.
//  Copyright © 2017年 felix. All rights reserved.
//

import UIKit

class BaseDialog: UIView {

    private var keyWindow:UIWindow!
    
    // 背景透明色
    private var shadow:UIControl!
    
    // 背景图片
    var backgroundImage:UIImageView!
    
    // 关闭按钮
    fileprivate var closeBtn:UIButton!
    
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
        UIView.animate(withDuration: 0.2) { [weak self] in
            self?.shadow.removeFromSuperview()
            self?.shadow = nil
            self?.removeFromSuperview()
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
        let closeImage = UIImage(named: "close_icon")
        closeBtn.setBackgroundImage(closeImage, for: .normal)
        closeBtn.frame = CGRect(x: self.bounds.width/2 + backgroundImage.bounds.width/2 - (closeImage?.size.width)!/2 - 10, y: self.bounds.height/2 - backgroundImage.bounds.height/2 + (closeImage?.size.height)!/2 + 5, width: (closeImage?.size.width)!, height: (closeImage?.size.height)!)
        addSubview(closeBtn)
        closeBtn.addTarget(self, action: #selector(hide), for: .touchUpInside)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}