//
//  ExchangePointsDialog.swift
//  FelixFastCatch
//
//  Created by 卢凡 on 2018/1/10.
//  Copyright © 2018年 felix. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire

/// 确认兑换积分的弹窗
class ExchangePointsDialog: BaseDialog {

    /// 要兑换的礼品
    var exchangeData = [JSON]()
    
    /// 兑换成功的回调，回调上一个接口刷新list
    var exchangeSuccessCallback:(()->())? = nil
    
    override func createView() {
        createBackgroundImage(imageName: "兑换积分底")
        backgroundImage.center = self.center
        
        // 取消按钮
        let cancelBtn = UIButton(type: .custom)
        cancelBtn.setBackgroundImage(UIImage(named: "取消"), for: .normal)
        cancelBtn.setBackgroundImage(UIImage(named: "取消点击"), for: .highlighted)
        cancelBtn.sizeToFit()
        addSubview(cancelBtn)
        
        cancelBtn.snp.makeConstraints { (make) in
            make.left.equalTo(backgroundImage).offset(15)
            make.bottom.equalTo(backgroundImage).offset(-10)
        }
        
        cancelBtn.addTarget(self, action: #selector(hide), for: .touchUpInside)
        
        // 确认按钮
        let confirmBtn = UIButton(type: .custom)
        confirmBtn.setBackgroundImage(UIImage(named: "确认"), for: .normal)
        confirmBtn.setBackgroundImage(UIImage(named: "确认点击"), for: .highlighted)
        confirmBtn.sizeToFit()
        addSubview(confirmBtn)
        
        confirmBtn.snp.makeConstraints { (make) in
            make.right.equalTo(backgroundImage).offset(-15)
            make.bottom.equalTo(backgroundImage).offset(-10)
        }
        
        confirmBtn.addTarget(self, action: #selector(exchangePoints), for: .touchUpInside)
        
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
