//
//  GameUserInfoDialog.swift
//  FelixFastCatch
//
//  Created by 卢凡 on 2017/10/13.
//  Copyright © 2017年 felix. All rights reserved.
//

import UIKit
import SwiftyJSON

class GameUserInfoDialog: BaseDialog {

    var dataSources:JSON!
    
    // 用户头像
    fileprivate var userFaceImageView:UIImageView!
    
    // 用户头像背景图
    fileprivate var userFaceImageBackground:UIImageView!
    
    // 用户昵称
    fileprivate var userNickName:MainCustomerLabel = MainCustomerLabel()
    
    // 星座
    fileprivate var constellationLabel:MainCustomerLabel = MainCustomerLabel()
    
    // 性别
    fileprivate var sexLabel:MainCustomerLabel = MainCustomerLabel()
    
    override func createView() {
        createBackgroundImage(imageName: "TA的资料背景")
        
        backgroundImage.frame.size = CGSize(width: 334, height: 225)
        backgroundImage.center = self.center
        
        createCloseBtn()
        
        // 背景图
        let userFaceBorderImage = UIImage(named: "user_face_border")
        userFaceImageBackground = UIImageView()
        userFaceImageBackground.image = userFaceBorderImage
        userFaceImageBackground.frame = CGRect(x: self.bounds.width/2 - backgroundImage.bounds.width/2 + 54, y: self.bounds.height/2 - backgroundImage.bounds.height/2 + 80, width: 61, height: 61)
        addSubview(userFaceImageBackground)
        
        //头像
        userFaceImageView = UIImageView()
        userFaceImageView.layer.cornerRadius = 61 * 0.8 / 2
        userFaceImageView.layer.masksToBounds = true
        userFaceImageView.backgroundColor = UIColor.white
        
        userFaceImageView.frame.size = CGSize(width: 58, height: 58)
        
        addSubview(userFaceImageView)
        
        userFaceImageView.snp.makeConstraints { (make) in
            make.width.equalTo(50)
            make.height.equalTo(50)
            make.center.equalTo(userFaceImageBackground)
        }
        
        userFaceImageView.kf.setImage(with: URL(string: dataSources["avatar"].stringValue), placeholder: UIImage(named: "default_user_face"), options: nil, progressBlock: nil, completionHandler: nil)
        
        // 用户昵称
        userNickName.font = UIFont(name: "FZY4K--GBK1-0", size: CGFloat(16))
        userNickName.text = "昵称: \(dataSources["nick"].stringValue)"
        userNickName.outLineWidth = 3
        userNickName.outTextColor = UIColor.white
        userNickName.outLienTextColor = Constants.UI.OUT_LINE_COLOR
        userNickName.sizeToFit()
        userNickName.frame = userNickName.frame.insetBy(dx: CGFloat(1), dy: CGFloat(0))
        addSubview(userNickName)
        
        userNickName.snp.makeConstraints { (make) in
            make.top.equalTo(backgroundImage).offset(65)
            make.left.equalTo(userFaceImageBackground).offset(userFaceImageBackground.bounds.width + 40)
        }
        
        // 用户星座
        constellationLabel.font = UIFont(name: "FZY4K--GBK1-0", size: CGFloat(16))
        constellationLabel.text = "星座: " + dataSources["constellation"].stringValue
        constellationLabel.outLineWidth = 3
        constellationLabel.outTextColor = UIColor.white
        constellationLabel.outLienTextColor = Constants.UI.OUT_LINE_COLOR
        constellationLabel.sizeToFit()
        addSubview(constellationLabel)
        
        constellationLabel.snp.makeConstraints { (make) in
            make.top.equalTo(userNickName).offset(userNickName.bounds.height + 5)
            make.left.equalTo(userNickName)
        }
        
        // 用户性别
        sexLabel.font = UIFont(name: "FZY4K--GBK1-0", size: CGFloat(16))
        if dataSources["gender"].stringValue == "0" {
            sexLabel.text = "性别: 男"
        }else if Constants.User.USER_SEX == "-1"{
            sexLabel.text = "性别: 未知"
        }else{
            sexLabel.text = "性别: 女"
        }
        sexLabel.outLineWidth = 3
        sexLabel.outTextColor = UIColor.white
        sexLabel.outLienTextColor = Constants.UI.OUT_LINE_COLOR
        sexLabel.sizeToFit()
        addSubview(sexLabel)
        
        sexLabel.snp.makeConstraints { (make) in
            make.top.equalTo(constellationLabel).offset(constellationLabel.bounds.height + 5)
            make.left.equalTo(userNickName)
        }
        
        createTitlesGroup()
        
        addDialogToWindow()
    }
    
    fileprivate var bottomTitlesGroup = UIView()
    
    /// 创建成就集合
    func createTitlesGroup() -> () {
        bottomTitlesGroup.backgroundColor = UIColor.white
        addSubview(bottomTitlesGroup)
        
        let titles = dataSources["achievements"].arrayValue
        var width:CGFloat = 0
        var height:CGFloat = 0
        for i in 0...titles.count-1 {
            let itemView = getTitleItem(itemData: titles[i])
            itemView.frame = CGRect(x: CGFloat(i)*(itemView.bounds.width + 10),
                                    y: 0, width: itemView.bounds.width + 10, height: itemView.bounds.height)
            bottomTitlesGroup.addSubview(itemView)
            width = width + itemView.bounds.width
            height = itemView.bounds.height
        }
        
//        bottomTitlesGroup.frame.size = CGSize(width: width, height: height)
        
        bottomTitlesGroup.frame = CGRect(x: (UIScreen.main.bounds.width - width)/2, y: 0, width: width, height: height)
        
        bottomTitlesGroup.snp.makeConstraints { (make) in
            make.bottom.equalTo(backgroundImage).offset(-(bottomTitlesGroup.bounds.height + 10))
            make.left.equalTo(backgroundImage).offset(backgroundImage.bounds.width/2 - width/2)
        }

        
    }
    
    func getTitleItem(itemData:JSON) -> UIView {
        let itemView = UIView()
        
        let titleImage = UIImageView()
        titleImage.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        itemView.addSubview(titleImage)
        
        titleImage.kf.setImage(with: URL(string: itemData["achievementImg"].stringValue))
        
        let title = MainCustomerLabel()
        title.outLineWidth = Constants.UI.OUT_LINE_WIDTH
        title.outTextColor = UIColor.white
        title.outLienTextColor = Constants.UI.OUT_LINE_COLOR
        title.font = UIFont(name: "FZY4K--GBK1-0", size: CGFloat(11))
        title.text = itemData["name"].stringValue
        title.sizeToFit()
        title.frame = CGRect(x: 0, y: titleImage.bounds.height + 5, width: title.bounds.width, height: title.bounds.height)
        itemView.addSubview(title)
        
        if titleImage.bounds.width > title.bounds.width {
            itemView.frame.size = CGSize(width: titleImage.bounds.width, height: titleImage.bounds.height + 5 + title.bounds.height)
        }else{
            itemView.frame.size = CGSize(width: title.bounds.width, height: titleImage.bounds.height + 5 + title.bounds.height)
        }
        
        titleImage.frame = CGRect(x: (itemView.bounds.width - titleImage.bounds.width)/2, y: 0, width: 30, height: 30)
        
        return itemView
    }
    
    
    
}








