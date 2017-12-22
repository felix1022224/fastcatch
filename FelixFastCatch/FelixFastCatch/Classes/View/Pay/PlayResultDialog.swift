//
//  PlayResultDialog.swift
//  FelixFastCatch
//
//  Created by 卢凡 on 2017/8/2.
//  Copyright © 2017年 felix. All rights reserved.
//

import UIKit

class PlayResultDialog: BaseDialog {

    var isSuccess:Bool = false
    
    fileprivate lazy var successTitle:MainCustomerLabel = MainCustomerLabel()
    
    fileprivate lazy var successInfo:MainCustomerLabel = MainCustomerLabel()
    
    fileprivate lazy var errorTitle:MainCustomerLabel = MainCustomerLabel()
    
    override func createView() {
        createBackgroundImage(imageName: "抓中了背景")
        
        successTitle.outLineWidth = Constants.UI.OUT_LINE_WIDTH
        successTitle.outTextColor = UIColor.white
        successTitle.outLienTextColor = Constants.UI.OUT_LINE_COLOR
        successTitle.font = UIFont.getCustomeYuanTiFont(fontSize: 20)
        successTitle.text = "抓中啦！"
        successTitle.sizeToFit()
        addSubview(successTitle)
        
        successTitle.snp.makeConstraints { (make) in
            make.centerX.equalTo(backgroundImage)
            make.centerY.equalTo(backgroundImage).offset(-successTitle.bounds.height)
        }
        
        successInfo.outLineWidth = Constants.UI.OUT_LINE_WIDTH
        successInfo.outTextColor = UIColor.white
        successInfo.outLienTextColor = Constants.UI.OUT_LINE_COLOR
        successInfo.font = UIFont.getCustomeYuanTiFont(fontSize: 20)
        successInfo.text = "已放入你的奖品背包"
        successInfo.sizeToFit()
        addSubview(successInfo)
        
        successInfo.snp.makeConstraints { (make) in
            make.centerX.equalTo(successTitle)
            make.centerY.equalTo(backgroundImage).offset(successInfo.bounds.height)
        }
        
        errorTitle.outLineWidth = Constants.UI.OUT_LINE_WIDTH
        errorTitle.outTextColor = UIColor.white
        errorTitle.outLienTextColor = Constants.UI.OUT_LINE_COLOR
        errorTitle.font = UIFont.getCustomeYuanTiFont(fontSize: 20)
        errorTitle.text = "啊哦！就差一点点"
        errorTitle.sizeToFit()
        addSubview(errorTitle)
        
        errorTitle.snp.makeConstraints { (make) in
            make.center.equalTo(backgroundImage)
        }
        
        if isSuccess {
            successTitle.isHidden = false
            successInfo.isHidden = false
            errorTitle.isHidden = true
        }else{
            successTitle.isHidden = true
            successInfo.isHidden = true
            errorTitle.isHidden = false
        }
        
        addDialogToWindow()
    }
    
    override func show() {
        super.show()
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2) { [weak self] in
            self?.hide()
        }
    }

}
