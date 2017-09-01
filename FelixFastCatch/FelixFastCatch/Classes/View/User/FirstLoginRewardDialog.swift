//
//  FirstLoginRewardDialog.swift
//  FelixFastCatch
//  第一次登录的奖励
//  Created by 卢凡 on 2017/8/8.
//  Copyright © 2017年 felix. All rights reserved.
//

import UIKit

/// 第一次登录的奖励页面
class FirstLoginRewardDialog: BaseDialog {

    fileprivate lazy var gemImage:UIImageView = UIImageView()
    
    override func createView() {
        createBackgroundImage(imageName: "bg_novice_reward")
        
        backgroundImage.frame.size = CGSize(width: 290, height: 320)
        backgroundImage.center = self.center
        
        gemImage.image = UIImage(named: "icon_novice_reward_gem")
        gemImage.frame.size = CGSize(width: 105, height: 90)
        addSubview(gemImage)
        
        gemImage.snp.makeConstraints { (make) in
            make.width.equalTo(105)
            make.height.equalTo(90)
            make.centerX.equalTo(backgroundImage)
            make.top.equalTo(backgroundImage).offset(90)
        }
        
        let rewardInfo = MainCustomerLabel()
        rewardInfo.outTextColor = UIColor.white
        rewardInfo.outLineWidth = Constants.UI.OUT_LINE_WIDTH
        rewardInfo.outLienTextColor = Constants.UI.OUT_LINE_COLOR
        rewardInfo.text = "奖励100代币，赶紧去抓吧"
        rewardInfo.font = UIFont(name: "FZY4K--GBK1-0", size: CGFloat(20))
        rewardInfo.sizeToFit()
        addSubview(rewardInfo)
        
        rewardInfo.snp.makeConstraints { (make) in
            make.top.equalTo(gemImage).offset(gemImage.bounds.height + 20)
            make.centerX.equalTo(backgroundImage)
        }
        
        let goBtn = UIButton(type: .custom)
        goBtn.setBackgroundImage(UIImage(named: "icon_novice_reward_start"), for: .normal)
        goBtn.frame.size = CGSize(width: 120, height: 35)
        addSubview(goBtn)
        
        goBtn.snp.makeConstraints { (make) in
            make.width.equalTo(120)
            make.height.equalTo(35)
            make.centerX.equalTo(backgroundImage)
            make.bottom.equalTo(backgroundImage).offset(goBtn.bounds.height/2)
        }
        
        goBtn.addTarget(self, action: #selector(hide), for: .touchUpInside)
        
        addDialogToWindow()
    }

}
