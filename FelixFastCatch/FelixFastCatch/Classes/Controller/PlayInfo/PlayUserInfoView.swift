//
//  PlayUserInfoView.swift
//  FelixFastCatch
//
//  Created by 卢凡 on 2017/10/12.
//  Copyright © 2017年 felix. All rights reserved.
//

import UIKit

/// 正在游戏的用户
class PlayUserInfoView: NSObject {

}

extension PlayViewController {
    
    /// 创建正在游戏中的用户的UI
    func createPlayUserInfo() -> () {
        
        let gameUserImageBackground = UIView()
        gameUserImageBackground.frame.size = CGSize(width: 40, height: 40)
        gameUserImageBackground.backgroundColor = UIColor.white
        gameUserImageBackground.layer.cornerRadius = 40/2
        gameUserImageBackground.layer.masksToBounds = true
        
        gameUserImage.backgroundColor = UIColor.white
        gameUserImage.frame.size = CGSize(width: 36, height: 36)
//        gameUserImage.center = gameUserImageBackground.center
        gameUserImage.layer.cornerRadius = 36/2
        gameUserImage.layer.masksToBounds = true
        
        view.addSubview(gameUserGroup)
        
        gameUserNickName.font = UIFont(name: "FZY4K--GBK1-0", size: CGFloat(11))
        gameUserNickName.outLineWidth = Constants.UI.OUT_LINE_WIDTH
        gameUserNickName.outTextColor = UIColor.white
        gameUserNickName.outLienTextColor = Constants.UI.OUT_LINE_COLOR
        gameUserNickName.text = "用户昵称"
        gameUserNickName.sizeToFit()
        
        gameUserNickNameBackground.frame = CGRect(x: 5, y: 2, width: 40 + gameUserNickName.bounds.width + 10, height: 36)
        gameUserNickNameBackground.layer.cornerRadius = 36/2
        gameUserNickNameBackground.layer.masksToBounds = true
        gameUserNickNameBackground.backgroundColor = UIColor(red: 0/255.0, green: 0/255.0, blue: 0/255.0, alpha: 0.3)
        gameUserGroup.addSubview(gameUserNickNameBackground)
        gameUserGroup.addSubview(gameUserNickName)
        
        gameUserGroup.addSubview(gameUserImageBackground)
        gameUserImage.center = gameUserImageBackground.center
        view.addSubview(gameUserImage)
        
        gameUserNickName.snp.makeConstraints { (make) in
            make.centerY.equalTo(gameUserNickNameBackground)
            make.left.equalTo(gameUserImageBackground).offset(gameUserImageBackground.bounds.width + 5)
        }
        
        gameUserGroup.snp.makeConstraints { (make) in
            make.right.equalTo(view).offset(-14)
            make.top.equalTo(gemBackground).offset(gemBackground.bounds.height + 14)
            make.width.equalTo(40 + gameUserNickName.bounds.width + 10)
        }
        
        gameUserImage.frame = CGRect(x: UIScreen.main.bounds.width - (40 + gameUserNickName.bounds.width + 10) - 14 + 2, y: gemBackground.bounds.height + 14 + 4 + UIApplication.shared.statusBarFrame.height, width: 36, height: 36)
        
//        gameUserImage.snp.makeConstraints { (make) in
//            make.left.equalTo(gameUserGroup).offset(2)
//            make.top.equalTo(gameUserGroup).offset(2)
//        }
        
        gameUserImage.isHidden = true
        gameUserGroup.isHidden = true
    }
    
    public func updateGameUserInfoWidget(userFaceImage:String, userNickName:String) -> () {
        gameUserImage.kf.setImage(with: URL(string: userFaceImage))
        gameUserNickName.text = userNickName
        gameUserNickNameBackground.frame = CGRect(x: 5, y: 4, width: 40 + gameUserNickName.bounds.width + 10, height: 36)
        gameUserGroup.snp.makeConstraints { (make) in
            make.right.equalTo(view).offset(-10)
            make.top.equalTo(gemBackground).offset(gemBackground.bounds.height + 14)
            make.width.equalTo(40 + gameUserNickName.bounds.width + 10)
        }
        
        gameUserImage.frame = CGRect(x: UIScreen.main.bounds.width - (40 + gameUserNickName.bounds.width + 10) - 14 + 2,
                                     y: gemBackground.bounds.height + 14 + 4 + UIApplication.shared.statusBarFrame.height, width: 36, height: 36)
        
        gameUserImage.isHidden = false
        gameUserGroup.isHidden = false
    }
    
    public func removeGameUserInfo(){
        gameUserImage.isHidden = true
        gameUserGroup.isHidden = true
    }
    
}