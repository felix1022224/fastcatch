//
//  EditAddressSuccessDialog.swift
//  FelixFastCatch
//
//  Created by 卢凡 on 2017/8/22.
//  Copyright © 2017年 felix. All rights reserved.
//

import UIKit

class SubmitSuccessDialog: BaseDialog {

    /*
     提交成功
    */
    
    override func createView() {
        createBackgroundImage(imageName: "提交成功背景")
        
        backgroundImage.frame.size = CGSize(width: 288, height: 285)
        backgroundImage.center = self.center
        
        /// 成功的对号
        let successImage = UIImageView()
        successImage.image = UIImage(named: "成功对号")
        addSubview(successImage)
        
        successImage.snp.makeConstraints { (make) in
            make.top.equalTo(backgroundImage).offset(85)
            make.centerX.equalTo(backgroundImage)
        }
        
        /// 提交成功的描述
        let successInfo = MainCustomerLabel()
        successInfo.text = "邮寄申请已提交成功"
        successInfo.outLineWidth = Constants.UI.OUT_LINE_WIDTH
        successInfo.outTextColor = UIColor.white
        successInfo.outLienTextColor = Constants.UI.OUT_LINE_COLOR
        successInfo.font = UIFont.getCustomeYuanTiFont(fontSize: 12)
        successInfo.sizeToFit()
        addSubview(successInfo)
        
        successInfo.snp.makeConstraints { (make) in
            make.top.equalTo(successImage).offset(successImage.bounds.height + 20)
            make.centerX.equalTo(backgroundImage)
        }
        
        /// 确认按钮
        let okBtn = UIButton(type: .custom)
        okBtn.setBackgroundImage(UIImage(named: ""), for: .normal)
        addSubview(okBtn)
        
        okBtn.snp.makeConstraints { (make) in
            make.width.equalTo(118)
            make.height.equalTo(35)
            make.centerX.equalTo(backgroundImage)
            make.bottom.equalTo(backgroundImage).offset(35/2)
        }
        
        okBtn.addTarget(self, action: #selector(hide), for: .touchUpInside)
        
        addDialogToWindow()
    }

}
