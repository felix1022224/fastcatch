//
//  GameQADialog.swift
//  FelixFastCatch
//
//  Created by 卢凡 on 2018/2/5.
//  Copyright © 2018年 felix. All rights reserved.
//

import UIKit

class GameQADialog: BasicDialog {

    override func createView() {
        let bgView = UIView.init()
        bgView.frame.size = CGSize.init(width: UIScreen.main.bounds.width * 0.65, height: UIScreen.main.bounds.width * 0.65)
        bgView.backgroundColor = UIColor.white
        bgView.frame.origin = CGPoint.init(x: UIScreen.main.bounds.width/2 - bgView.bounds.width/2, y: UIScreen.main.bounds.height/2 - bgView.bounds.height/2)
        addSubview(bgView)
        
        bgView.layer.cornerRadius = 20
        bgView.layer.masksToBounds = true
        
        let closeBtn = UIButton.init(type: UIButtonType.custom)
        closeBtn.setBackgroundImage(UIImage.init(named: "关闭"), for: UIControlState.normal)
        closeBtn.sizeToFit()
        addSubview(closeBtn)
        closeBtn.snp.makeConstraints { (make) in
            make.right.equalTo(bgView).offset(-10)
            make.top.equalTo(bgView).offset(10)
        }
        closeBtn.addTarget(self, action: #selector(hide), for: UIControlEvents.touchUpInside)
        
        let title = UILabel.init()
        title.text = "官方客服群"
        title.font = UIFont.systemFont(ofSize: 18)
        title.sizeToFit()
        addSubview(title)
        
        title.snp.makeConstraints { (make) in
            make.top.equalTo(bgView).offset(bgView.bounds.height * 0.15)
            make.centerX.equalTo(bgView)
        }
        
        let info = UILabel.init()
        info.text = "秒抓客服官方群:\n\n652498141"
        info.font = UIFont.systemFont(ofSize: 12)
        info.textAlignment = .center
        info.numberOfLines = 5
        info.sizeToFit()
        addSubview(info)
        
        info.snp.makeConstraints { (make) in
            make.centerX.equalTo(bgView)
            make.centerY.equalTo(bgView)
        }
        
        let okButton = UIButton.init(type: UIButtonType.custom)
        okButton.setBackgroundImage(UIImage.init(named: "复制"), for: UIControlState.normal)
        okButton.sizeToFit()
        addSubview(okButton)
        
        okButton.snp.makeConstraints { (make) in
            make.centerX.equalTo(bgView)
            make.bottom.equalTo(bgView).offset(-15)
        }
        
        okButton.addTarget(self, action: #selector(copyQQ), for: UIControlEvents.touchUpInside)
        
        addDialogToWindow()
    }
    
    @objc func copyQQ() {
        UIPasteboard.general.string = "652498141"
        ToastUtils.showSuccessToast(msg: "复制成功")
        hide()
    }
    
}
