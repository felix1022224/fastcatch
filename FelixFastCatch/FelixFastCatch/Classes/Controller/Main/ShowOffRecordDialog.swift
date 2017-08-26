//
//  ShowOffRecordDialog.swift
//  FelixFastCatch
//
//  Created by 卢凡 on 2017/8/13.
//  Copyright © 2017年 felix. All rights reserved.
//

import UIKit

/// 炫耀战绩
class ShowOffRecordDialog: BaseDialog {

    override func createView() {
        createBackgroundImage(imageName: "炫耀战绩背景")
        
        backgroundImage.frame.size = CGSize(width: 289, height: 274)
        backgroundImage.center = self.center
        
        createCloseBtn()
        
        let gemIcon = UIImageView(image: UIImage(named: "战绩钻石"))
        gemIcon.sizeToFit()
        addSubview(gemIcon)
        
        gemIcon.snp.makeConstraints { (make) in
            make.top.equalTo(backgroundImage).offset(65)
            make.centerX.equalTo(backgroundImage)
        }
        
        let sharedInfo = MainCustomerLabel()
        sharedInfo.outLineWidth = Constants.UI.OUT_LINE_WIDTH
        sharedInfo.outTextColor = UIColor.white
        sharedInfo.outLienTextColor = Constants.UI.OUT_LINE_COLOR
        sharedInfo.text = "和好友分享你的战绩"
        sharedInfo.font = UIFont(name: "FZY4K--GBK1-0", size: CGFloat(14))
        sharedInfo.textAlignment = .center
        sharedInfo.lineBreakMode = NSLineBreakMode.byWordWrapping
        sharedInfo.numberOfLines = 0
        sharedInfo.sizeToFit()
        addSubview(sharedInfo)
        
        sharedInfo.snp.makeConstraints { (make) in
            make.top.equalTo(gemIcon).offset(gemIcon.bounds.height + 10)
            make.centerX.equalTo(backgroundImage)
        }
        
        let nowShardBtn = UIButton(type: .custom)
        nowShardBtn.setBackgroundImage(UIImage(named: "分享按钮"), for: .normal)
        addSubview(nowShardBtn)
        
        nowShardBtn.snp.makeConstraints { (make) in
            make.width.equalTo(118)
            make.height.equalTo(35)
            make.bottom.equalTo(backgroundImage).offset(35/2)
            make.centerX.equalTo(backgroundImage)
        }
        
        addDialogToWindow()
    }

}
