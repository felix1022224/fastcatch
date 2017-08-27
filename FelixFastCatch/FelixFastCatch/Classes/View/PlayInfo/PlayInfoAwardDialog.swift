//
//  PlayInfoAwardDialog.swift
//  FelixFastCatch
//
//  Created by 卢凡 on 2017/8/27.
//  Copyright © 2017年 felix. All rights reserved.
//

import UIKit

class PlayInfoAwardDialog: BaseDialog {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    /// 奖品的图片
    private var awardImage:UIImageView!
    
    /// 奖品名称
    private var awardTitle:MainCustomerLabel!
    
    /// 奖品介绍
    private var awardDescription:MainCustomerLabel!
    
    override func createView() {
        createBackgroundImage(imageName: "抓中了背景")
        
        backgroundImage.frame.size = CGSize(width: 298, height: 366)
        backgroundImage.center = self.center
        
        createCloseBtn()
        
        let rootView = UIScrollView()
        rootView.frame.size = CGSize(width: backgroundImage.bounds.width*0.8, height: backgroundImage.bounds.height*0.85)
        rootView.center = backgroundImage.center
        addSubview(rootView)
        
        awardImage = UIImageView()
        awardImage.frame.size = CGSize(width: rootView.bounds.width, height: rootView.bounds.width)
        awardImage.frame = CGRect(x: 0, y: 0, width: awardImage.bounds.width, height: awardImage.bounds.height)
        rootView.addSubview(awardImage)
        
        awardTitle = MainCustomerLabel()
        awardTitle.text = "谁谁谁"
        awardTitle.font = UIFont(name: "FZY4K--GBK1-0", size: CGFloat(16))
        awardTitle.outTextColor = UIColor.white
        awardTitle.outLineWidth = Constants.UI.OUT_LINE_WIDTH
        awardTitle.outLienTextColor = Constants.UI.OUT_LINE_COLOR
        awardTitle.sizeToFit()
        awardTitle.frame = CGRect(x: 0, y: awardImage.bounds.height + 15, width: rootView.bounds.width, height: awardTitle.bounds.height)
        rootView.addSubview(awardTitle)
        
        awardDescription = MainCustomerLabel()
        awardDescription.text = "谁谁谁"
        awardDescription.font = UIFont(name: "FZY4K--GBK1-0", size: CGFloat(12))
        awardDescription.outTextColor = UIColor.white
        awardDescription.outLineWidth = Constants.UI.OUT_LINE_WIDTH
        awardDescription.outLienTextColor = Constants.UI.OUT_LINE_COLOR
        awardDescription.sizeToFit()
        awardDescription.frame = CGRect(x: 0, y: awardImage.bounds.height + 15 + awardTitle.bounds.height + 15, width: rootView.bounds.width, height: awardTitle.bounds.height)
        rootView.addSubview(awardDescription)
        
        rootView.contentSize = CGSize(width: rootView.bounds.width, height: awardImage.bounds.height + 15 + awardTitle.bounds.height + 15 + awardDescription.bounds.height + 25)
        
        addDialogToWindow()
    }
    
    /// 显示
    func showInfo(title:String, description:String, imagePath:String) -> () {
        awardTitle.text = title
        awardDescription.text = description
        awardImage.kf.setImage(with: URL(string: imagePath), placeholder: UIImage(named: "main_no_value"), options: nil, progressBlock: nil, completionHandler: nil)
        show()
    }

}
