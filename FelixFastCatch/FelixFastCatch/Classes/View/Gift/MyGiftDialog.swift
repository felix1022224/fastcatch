//
//  MyGiftDialog.swift
//  FelixFastCatch
//
//  Created by 卢凡 on 2017/7/31.
//  Copyright © 2017年 felix. All rights reserved.
//

import UIKit

class MyGiftDialog: BaseDialog {

    // 关闭按钮
    fileprivate var closeBtn:UIButton!
    
    // 切换tab的北京
    fileprivate var tabBackground:UIImageView!
    
    // 待邮寄
    fileprivate var tobeMailedBtn:UIButton!
    
    // 已邮寄
    fileprivate var hasbeenMailedBtn:UIButton!
    
    // 待邮寄的tabview
    fileprivate var tobeMailedTabView:UITableView!
    
    // 已邮寄的tabview
    fileprivate var hasbeenMailedTabView:UITableView!
    
    // 去邮寄按钮
    fileprivate var toMailedBtn:UIButton!
    
    // 是否选中了待发货
    fileprivate var isSelectTobe:Bool = true
    
    // 代理
    fileprivate var tobeMailedDelegate:FCMyGiftToBeMailedTabViewDelegate!
    fileprivate var hasBeenMailedDelegate:FCMyGiftHasBeenMailedTabViewDelegate!
    
    // 邮件确认
    fileprivate var mailedConfirmDialog:FCMailedConfirmDialog!
    
    override func createView() {
        createBackgroundImage(imageName: "待邮寄背景")
        
        // 关闭按钮
        closeBtn = UIButton(type: .custom)
        let closeImage = UIImage(named: "关闭我的奖品")
        closeBtn.setBackgroundImage(closeImage, for: .normal)
        closeBtn.frame = CGRect(x: self.bounds.width/2 + backgroundImage.bounds.width/2 - (closeImage?.size.width)!/2 - 5, y: self.bounds.height/2 - backgroundImage.bounds.height/2 + (closeImage?.size.height)!/2 + 5, width: (closeImage?.size.width)!, height: (closeImage?.size.height)!)
        addSubview(closeBtn)
        closeBtn.addTarget(self, action: #selector(hide), for: .touchUpInside)
        
        // 切换tab背景
        tabBackground = UIImageView(image: UIImage(named: "点击背景"))
        addSubview(tabBackground)
        tabBackground.frame = CGRect(x: self.bounds.width/2 - tabBackground.bounds.width/2, y: self.bounds.height/2 - backgroundImage.bounds.height / 2 + 65, width: tabBackground.bounds.width, height: tabBackground.bounds.height)
        
        // 待邮寄
        tobeMailedBtn = UIButton()
        tobeMailedBtn.setBackgroundImage(UIImage(named: "待邮寄未点"), for: .normal)
        tobeMailedBtn.setBackgroundImage(UIImage(named: "待邮寄未点"), for: .highlighted)
        tobeMailedBtn.setBackgroundImage(UIImage(named: "待邮寄已点"), for: .selected)
        tobeMailedBtn.sizeToFit()
        
        addSubview(tobeMailedBtn)
        tobeMailedBtn.addTarget(self, action: #selector(changeSelectTab), for: .touchUpInside)
        tobeMailedBtn.snp.makeConstraints { (make) in
            make.centerY.equalTo(tabBackground)
            make.left.equalTo(tabBackground).offset(2)
        }
        
        tobeMailedBtn.isUserInteractionEnabled = false
        tobeMailedBtn.isSelected = true
        
        // 已邮寄
        hasbeenMailedBtn = UIButton()
        hasbeenMailedBtn.setBackgroundImage(UIImage(named: "已邮寄未点"), for: .normal)
        hasbeenMailedBtn.setBackgroundImage(UIImage(named: "已邮寄未点"), for: .highlighted)
        hasbeenMailedBtn.setBackgroundImage(UIImage(named: "已邮寄已点"), for: .selected)
        hasbeenMailedBtn.sizeToFit()
        addSubview(hasbeenMailedBtn)
        hasbeenMailedBtn.addTarget(self, action: #selector(changeSelectTab), for: .touchUpInside)
        hasbeenMailedBtn.snp.makeConstraints { (make) in
            make.centerY.equalTo(tabBackground)
            make.left.equalTo(self.bounds.width/2)
        }
        
        // 去邮寄
        toMailedBtn = UIButton(type: .custom)
        toMailedBtn.setBackgroundImage(UIImage(named: "按钮我要邮寄"), for: .normal)
        toMailedBtn.sizeToFit()
        addSubview(toMailedBtn)
        
        toMailedBtn.snp.makeConstraints { (make) in
            make.bottom.equalTo(backgroundImage).offset(toMailedBtn.bounds.height/2 - 5)
            make.centerX.equalTo(self)
        }
        
        toMailedBtn.addTarget(self, action: #selector(showMailedConfirmDialog), for: .touchUpInside)
        
        mailedConfirmDialog = FCMailedConfirmDialog(frame: self.bounds)
        
        setupTabViews()
        
        addDialogToWindow()
    }
    
    // 展示邮件信息确认页面
    func showMailedConfirmDialog() -> () {
        mailedConfirmDialog.createView()
        mailedConfirmDialog.show()
    }
    
}

// 顶部tab切换逻辑
extension MyGiftDialog{
    
    @objc func changeSelectTab() -> () {
        if isSelectTobe {
            isSelectTobe = false
            tobeMailedBtn.isUserInteractionEnabled = true
            hasbeenMailedBtn.isUserInteractionEnabled = false
            tobeMailedBtn.isSelected = false
            hasbeenMailedBtn.isSelected = true
            
            tobeMailedTabView.isHidden = true
            hasbeenMailedTabView.isHidden = false
            
        }else {
            isSelectTobe = true
            tobeMailedBtn.isUserInteractionEnabled = false
            hasbeenMailedBtn.isUserInteractionEnabled = true
            tobeMailedBtn.isSelected = true
            hasbeenMailedBtn.isSelected = false
            
            tobeMailedTabView.isHidden = false
            hasbeenMailedTabView.isHidden = true
            
        }
    }
    
}

// tabview
extension MyGiftDialog{
    
    func setupTabViews() -> () {
        
        // 待邮寄
        tobeMailedDelegate = FCMyGiftToBeMailedTabViewDelegate()
        
        tobeMailedTabView = UITableView()
        addSubview(tobeMailedTabView)
        tobeMailedTabView.backgroundColor = UIColor.clear
        tobeMailedTabView.delegate = tobeMailedDelegate
        tobeMailedTabView.dataSource = tobeMailedDelegate
        tobeMailedTabView.separatorColor = UIColor.clear
        tobeMailedTabView.showsVerticalScrollIndicator = false
        tobeMailedTabView.register(FCMyGiftCell.self, forCellReuseIdentifier: "cellId")
        
        tobeMailedTabView.snp.makeConstraints { (make) in
            make.top.equalTo(tabBackground).offset(tabBackground.bounds.height + 10)
            make.centerX.equalTo(self)
            make.bottom.equalTo(backgroundImage).offset(-50)
            make.width.equalTo((UIImage(named: "内容块")?.size.width)!)
        }
        
        // 已邮寄
        hasBeenMailedDelegate = FCMyGiftHasBeenMailedTabViewDelegate()
        
        let hasBeenContentBackgroundImage = UIImage(named: "has_been_content_background")
        
        hasbeenMailedTabView = UITableView()
        addSubview(hasbeenMailedTabView)
        hasbeenMailedTabView.backgroundColor = UIColor.clear
        hasbeenMailedTabView.separatorColor = UIColor.clear
        hasbeenMailedTabView.showsVerticalScrollIndicator = false
        
        hasbeenMailedTabView.delegate = hasBeenMailedDelegate
        hasbeenMailedTabView.dataSource = hasBeenMailedDelegate
        hasbeenMailedTabView.register(FCMyGiftHasBeenMailedCell.self, forCellReuseIdentifier: "cellId")
        
        hasbeenMailedTabView.snp.makeConstraints { (make) in
            make.top.equalTo(tabBackground).offset(tabBackground.bounds.height + 10)
            make.centerX.equalTo(self)
            make.bottom.equalTo(backgroundImage).offset(-50)
            make.width.equalTo((hasBeenContentBackgroundImage!.size.width))
        }
        
        hasbeenMailedTabView.isHidden = true
        
    }

}