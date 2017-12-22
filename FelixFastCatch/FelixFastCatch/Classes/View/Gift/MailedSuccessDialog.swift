//
//  MailedSuccessDialog.swift
//  FelixFastCatch
//
//  Created by 卢凡 on 2017/8/13.
//  Copyright © 2017年 felix. All rights reserved.
//

import UIKit

class MailedSuccessDialog: BaseDialog {


    private var gemInfo:MainCustomerLabel!
    
    override func createView() {
        createBackgroundImage(imageName: "提交成功背景")
        
        backgroundImage.frame.size = CGSize(width: 290, height: 265)
        backgroundImage.center = self.center
        
        let gemIcon = UIImageView(image: UIImage(named: "成功对号"))
        gemIcon.sizeToFit()
        addSubview(gemIcon)
        
        gemIcon.snp.makeConstraints { (make) in
            make.top.equalTo(backgroundImage).offset(gemIcon.bounds.height)
            make.centerX.equalTo(backgroundImage)
        }
        
        gemInfo = MainCustomerLabel()
        gemInfo.outLineWidth = Constants.UI.OUT_LINE_WIDTH
        gemInfo.outTextColor = UIColor.white
        gemInfo.outLienTextColor = Constants.UI.OUT_LINE_COLOR
        gemInfo.font = UIFont.getCustomeYuanTiFont(fontSize: 16)
        gemInfo.text = "提交成功"
        gemInfo.sizeToFit()
        addSubview(gemInfo)
        
        gemInfo.snp.makeConstraints { (make) in
            make.centerX.equalTo(backgroundImage)
            make.top.equalTo(gemIcon).offset(gemIcon.bounds.height + 15)
        }
        
        let overBtn = UIButton(type: .custom)
        overBtn.setImage(UIImage(named: "完成按钮"), for: .normal)
        overBtn.sizeToFit()
        addSubview(overBtn)
        
        overBtn.snp.makeConstraints { (make) in
            make.bottom.equalTo(backgroundImage).offset(overBtn.bounds.height/2)
            make.centerX.equalTo(backgroundImage)
        }
        
        overBtn.addTarget(self, action: #selector(hide), for: .touchUpInside)
        
        
        addDialogToWindow()
    }
    
}
