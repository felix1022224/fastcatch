//
//  MainBeginnerGuidPayView.swift
//  FelixFastCatch
//
//  Created by 卢凡 on 2017/9/28.
//  Copyright © 2017年 felix. All rights reserved.
//

import UIKit

/// 首页第一次进入时购买的引导view
class MainBeginnerGuidPayView: BaseDialog {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    private var giftGuidView:MainBeginnerGuidGiftView!
    
    private let guidView = UIImageView()
    
    override func createView() {
        
        let topGrayView = UIView()
        topGrayView.backgroundColor = UIColor(red: 0/255.0, green: 0/255.0, blue: 0/255.0, alpha: 0.8)
        addSubview(topGrayView)
        
        guidView.image = UIImage(named: "充值")
        guidView.sizeToFit()
        addSubview(guidView)
        
        guidView.snp.makeConstraints { (make) in
            make.left.equalTo(self)
            make.bottom.equalTo(self)
        }
        
        topGrayView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height - guidView.bounds.height)
        
        let rightGrayView = UIView()
        rightGrayView.backgroundColor = UIColor(red: 0/255.0, green: 0/255.0, blue: 0/255.0, alpha: 0.8)
        addSubview(rightGrayView)
        
        rightGrayView.frame = CGRect(x: guidView.bounds.width, y: UIScreen.main.bounds.height - guidView.bounds.height, width: UIScreen.main.bounds.width - guidView.bounds.width, height: guidView.bounds.height)
        
        addDialogToWindow()
    }

    // 添加view到window中
    override func addDialogToWindow(){
        self.shadow = UIControl(frame: (keyWindow?.bounds)!)
//        keyWindow?.addSubview(self.shadow)
        keyWindow?.addSubview(self)
        
        self.isHidden = true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        hide()
        
        giftGuidView = MainBeginnerGuidGiftView(frame: UIScreen.main.bounds)
        giftGuidView.createView()
        giftGuidView.show()
    }
    
}
