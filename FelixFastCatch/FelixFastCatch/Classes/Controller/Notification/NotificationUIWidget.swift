//
//  NotificationWidget.swift
//  FelixFastCatch
//
//  Created by 卢凡 on 2017/12/14.
//  Copyright © 2017年 felix. All rights reserved.
//

import UIKit

class NotificationUIWidget: NSObject {

}

extension NotificationViewController {
    
    func setupUI() {
        /// 设置背景
        let backgroundImage = UIImageView(image: UIImage(named: "邮寄背景"))
        backgroundImage.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        view.addSubview(backgroundImage)
        
        /// 顶部标题
        let topTitile = UIImageView(image: UIImage(named: "消息列表顶部标题"))
        view.addSubview(topTitile)
        
        topTitile.snp.makeConstraints { (make) in
            make.centerX.equalTo(view)
            make.top.equalTo(UIApplication.shared.statusBarFrame.height)
            make.width.equalTo(Constants.UI.TITLE_IMAGE_WIDTH)
            make.height.equalTo(Constants.UI.TITLE_IMAGE_HEIGHT)
        }
        
        /// 返回按钮
        let backBtn = UIButton(type: .custom)
        backBtn.setImage(UIImage(named: "邮寄返回"), for: .normal)
        backBtn.sizeToFit()
        view.addSubview(backBtn)
        
        backBtn.snp.makeConstraints { (make) in
            make.left.equalTo(view).offset(14)
            make.centerY.equalTo(topTitile)
        }
        
        backBtn.addTarget(self, action: #selector(closeVC), for: .touchUpInside)
        
        createNotificationList()
    }
    
    /// 关闭页面
    @objc func closeVC() {
        self.navigationController?.popViewController(animated: true)
    }
}
