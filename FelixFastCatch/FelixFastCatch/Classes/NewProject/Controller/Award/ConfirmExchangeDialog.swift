//
//  ConfirmExchangeDialog.swift
//  FelixFastCatch
//
//  Created by 卢凡 on 2018/1/31.
//  Copyright © 2018年 felix. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire

class ConfirmExchangeDialog: BasicDialog {

    /// 要兑换的礼品
    var exchangeData = [JSON]()
    
    /// 兑换成功的回调
    var exchangeSuccessCallback:(()->())!
    
    override func createView() {
        createBackgroundImage(imageName: "兑换积分弹窗")
        
        createCloseBtn()
        
        let title = UILabel()
        title.text = "兑换积分"
        title.font = UIFont.systemFont(ofSize: 18, weight: UIFont.Weight.bold)
        title.textColor = UIColor.init(red: 91/255.0, green: 130/255.0, blue: 239/255.0, alpha: 1.0)
        title.sizeToFit()
        addSubview(title)
        
        title.snp.makeConstraints { (make) in
            make.centerX.equalTo(backgroundImage)
            make.top.equalTo(backgroundImage).offset(backgroundImage.bounds.height * 0.5)
        }
        
        let info = UILabel.init()
        info.text = "确定将这些奖品 兑换成积分嘛？"
        info.font = UIFont.systemFont(ofSize: 14)
        info.textColor = UIColor.gray
        info.sizeToFit()
        addSubview(info)
        
        info.snp.makeConstraints { (make) in
            make.top.equalTo(title).offset(title.bounds.height + 10)
            make.centerX.equalTo(backgroundImage)
        }
        
        let cancelButton = UIButton.init(type: UIButtonType.custom)
        cancelButton.setImage(UIImage.init(named: "再想想"), for: UIControlState.normal)
        cancelButton.sizeToFit()
        addSubview(cancelButton)

        cancelButton.snp.makeConstraints { (make) in
            make.left.equalTo(backgroundImage)
            make.bottom.equalTo(backgroundImage).offset(-15)
        }
        cancelButton.addTarget(self, action: #selector(hide), for: UIControlEvents.touchUpInside)
        
        let confirmButton = UIButton.init(type: UIButtonType.custom)
        confirmButton.setImage(UIImage.init(named: "确认兑换"), for: UIControlState.normal)
        confirmButton.sizeToFit()
        addSubview(confirmButton)
        
        confirmButton.snp.makeConstraints { (make) in
            make.right.equalTo(backgroundImage)
            make.bottom.equalTo(backgroundImage).offset(-15)
        }
        
        confirmButton.addTarget(self, action: #selector(exchangePoints), for: UIControlEvents.touchUpInside)
        
        addDialogToWindow()
    }
    
    /// 兑换积分
    @objc func exchangePoints() {
        ToastUtils.showLoadingToast(msg: "请稍后")
        var ids = ""
        for i in 0..<exchangeData.count {
            let item = exchangeData[i]
            ids.append("" + String(item["id"].stringValue))
            if i != exchangeData.count - 1 {
                ids.append(",")
            }
        }
        
        var params = NetWorkUtils.createBaseParams()
        params["id"] = ids
        
        Alamofire.request(Constants.Network.User.EXCHANGE_POINTS, method: HTTPMethod.post, parameters: params).responseJSON { (dataResponse) in
            if NetWorkUtils.checkReponse(response: dataResponse) {
                ToastUtils.hide()
                ToastUtils.showSuccessToast(msg: "兑换成功")
                if self.exchangeSuccessCallback != nil {
                    self.exchangeSuccessCallback!()
                }
                self.hide()
            }else {
                ToastUtils.showErrorToast(msg: "兑换失败")
            }
        }
    }

}
