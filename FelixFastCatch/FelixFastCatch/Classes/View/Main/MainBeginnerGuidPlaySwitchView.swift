//
//  MainBeginnerGuidPlaySwitchView.swift
//  FelixFastCatch
//
//  Created by 卢凡 on 2017/9/28.
//  Copyright © 2017年 felix. All rights reserved.
//

import UIKit

class MainBeginnerGuidPlaySwitchView: BaseDialog {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    private let guidView = UIImageView()
    
    func createView2(playViewController:GameSceneViewController) -> () {
        self.playviewController = playViewController
        
        let guidImage = UIImage(named: "摄像头")
        
        guidView.image = guidImage
        guidView.sizeToFit()
        addSubview(guidView)
        
        guidView.snp.makeConstraints { (make) in
            make.bottom.equalTo(self).offset(-(UIScreen.main.bounds.height - UIScreen.main.bounds.width + UIApplication.shared.statusBarFrame.height))
            make.right.equalTo(self).offset(-3)
        }
        
        let topGrayView = UIView()
        topGrayView.backgroundColor = UIColor(red: 0/255.0, green: 0/255.0, blue: 0/255.0, alpha: 0.8)
        addSubview(topGrayView)

        topGrayView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width - 3, height:UIScreen.main.bounds.width - guidView.bounds.height - UIApplication.shared.statusBarFrame.height)

        let leftGrayView = UIView()
        leftGrayView.backgroundColor = UIColor(red: 0/255.0, green: 0/255.0, blue: 0/255.0, alpha: 0.8)
        addSubview(leftGrayView)

        leftGrayView.frame = CGRect(x: 0, y: topGrayView.bounds.height, width: UIScreen.main.bounds.width - 3 - guidView.bounds.width, height: (guidImage?.size.height)!)

        let rightGrayView  = UIView()
        rightGrayView.backgroundColor = UIColor(red: 0/255.0, green: 0/255.0, blue: 0/255.0, alpha: 0.8)
        addSubview(rightGrayView)

        rightGrayView.frame = CGRect(x: UIScreen.main.bounds.width - 3, y: 0, width: 3, height: UIScreen.main.bounds.width - UIApplication.shared.statusBarFrame.height)

        let bottomGrayView  = UIView()
        bottomGrayView.backgroundColor = UIColor(red: 0/255.0, green: 0/255.0, blue: 0/255.0, alpha: 0.8)
        addSubview(bottomGrayView)

        bottomGrayView.frame = CGRect(x: 0, y:UIScreen.main.bounds.width - UIApplication.shared.statusBarFrame.height, width: UIScreen.main.bounds.width, height:UIScreen.main.bounds.height - (UIScreen.main.bounds.width) + UIApplication.shared.statusBarFrame.height)
        
        addDialogToWindow()
    }
    
    // 添加view到window中
    override func addDialogToWindow(){
        self.shadow = UIControl(frame: (keyWindow?.bounds)!)
        //        keyWindow?.addSubview(self.shadow)
        keyWindow?.addSubview(self)
        
        self.isHidden = true
    }
    
    private var playviewController:GameSceneViewController!
    
    func show2() -> () {
//        self.playviewController.lensBtn.isHidden = false
        show()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        self.playviewController.lensBtn.isHidden = true
        self.playviewController = nil
        hide()
    }

}
