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
        
        nowShardBtn.addTarget(self, action: #selector(shared), for: .touchUpInside)
        
        nowShardBtn.snp.makeConstraints { (make) in
            make.width.equalTo(118)
            make.height.equalTo(35)
            make.bottom.equalTo(backgroundImage).offset(35/2)
            make.centerX.equalTo(backgroundImage)
        }
        
        addDialogToWindow()
    }
    
    fileprivate var deviceId:String!
    
    func show2(deviceId:String) -> () {
        self.deviceId = deviceId
        show()
    }

    func shared() -> () {
        ToastUtils.showLoadingToast(msg: "请稍后……")
        getDataFromUrl(url: URL(string: "http://meizhe.meidaojia.com/makeup/public/images/doll/" + deviceId + ".jpg")!) { (data, response, error) in
            if error == nil {
                WeChatShared.shareImage(data!, thumbImage: UIImage(named: "shared_logo"), title: "抓中啦", description: "抓到了", to: .Timeline, resuleHandle: { (isSuccess, info) in
                    if isSuccess {
                        ToastUtils.showSuccessToast(msg: "分享成功")
                    }else{
                        ToastUtils.showErrorToast(msg: " 分享失败")
                    }
                })
            }
        }
    }
    
    override func hide() {
        super.hide()
        ToastUtils.hide()
    }
    
    func getDataFromUrl(url: URL, completion: @escaping (_ data: Data?, _  response: URLResponse?, _ error: Error?) -> Void) {
        URLSession.shared.dataTask(with: url) {
            (data, response, error) in
            completion(data, response, error)
            }.resume()
    }
    
}
