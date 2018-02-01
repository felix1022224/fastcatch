//
//  BasicDialog.swift
//  FelixFastCatch
//
//  Created by 卢凡 on 2018/1/24.
//  Copyright © 2018年 felix. All rights reserved.
//

import UIKit
import Spring

class BasicDialog: SpringView {

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
        
        setOptions()
    }
    
    func setOptions() {
        self.force = 0.7      //弹力大小
        self.duration = 0.6  //动画持续时间
        self.delay = 0.2      //动画延时多久执行
        
        self.damping = 0.7  //暂时不知什么用
        self.velocity = 0.7  //暂时不知
        self.scaleX = 0     //必须参数之一：范围0~1
        self.scaleY = 0     //必须参数之一：范围0~1
        self.x = 0              //必须参数之一：范围任意
        self.y = 0              //必须参数之一：范围任意
        self.rotate = 0      //暂时不知什么用
        
        self.curve = "easeIn"     // 动画进入或是消失的样式
    }
    
    // 创建view
    func createView() -> () {
    }
    
    open func createCloseBtn() {
        let closeBtn = UIButton.init(type: UIButtonType.custom)
        closeBtn.setBackgroundImage(UIImage.init(named: "关闭"), for: UIControlState.normal)
        closeBtn.sizeToFit()
        addSubview(closeBtn)
        closeBtn.snp.makeConstraints { (make) in
            make.right.equalTo(backgroundImage).offset(-10)
            make.top.equalTo(backgroundImage).offset(10)
        }
        closeBtn.addTarget(self, action: #selector(hide), for: UIControlEvents.touchUpInside)
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
        setOptions()
        self.animation = "zoomIn"  // 动画具体样式
        self.isHidden = false
        self.animate()
        UIView.animate(withDuration: 0.5) {
            self.shadow.alpha = 0.5
        }
    }
    
    // 隐藏
    @objc func hide() -> () {
        self.animation = "zoomOut"
        self.shadow.alpha = 0.0
        self.animate()
        self.animateNext {
            self.isHidden = true
            self.removeFromSuperview()
        }
    }
    
    func addOnClickListener(toView:UIView, target: AnyObject, action: Selector) {
        let gr = UITapGestureRecognizer(target: target, action: action)
        gr.numberOfTapsRequired = 1
        toView.addGestureRecognizer(gr)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
