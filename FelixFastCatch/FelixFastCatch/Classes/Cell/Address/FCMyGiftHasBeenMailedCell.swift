//
//  FCMyGiftHasBeenMailedCell.swift
//  FastCatch
//
//  Created by 卢凡 on 2017/7/21.
//  Copyright © 2017年 felix. All rights reserved.
//

import UIKit

class FCMyGiftHasBeenMailedCell: UITableViewCell {

    // 时间标签
    fileprivate var timeLabel:MainCustomerLabel!
    
    // 商品图标集合
    fileprivate var productsGroup:UICollectionView!
    
    // 邮寄状态
    fileprivate var statusLabel:MainCustomerLabel!
    
    // 邮寄时间
    fileprivate var mailedTimeLabel:MainCustomerLabel!
    
    // 邮寄单号
    fileprivate var mailedCodeLabel:MainCustomerLabel!
    
    // 主要内容的背景图
    fileprivate var contentBacngroundImage:UIImageView!
    
    fileprivate var hasBeenContentBackgroundImage:UIImage!
    
    // 代理
    fileprivate var hasbeenProductsDelegate:FCMyGiftHasBeenProductsDelegate!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = UIColor.clear
        selectionStyle = UITableViewCellSelectionStyle.none
        
        setupUIWidget()
    }
    
    // 装载UI控件
    func setupUIWidget() -> () {
        
        // 时间标签
        timeLabel = MainCustomerLabel()
        timeLabel.font = UIFont.systemFont(ofSize: CGFloat(12))
        timeLabel.outLineWidth = 2
        timeLabel.outTextColor = UIColor.white
        timeLabel.outLienTextColor = Constants.UI.OUT_LINE_COLOR
        timeLabel.text = "申请时间: 2017.7.8 12:30"
        timeLabel.sizeToFit()
        addSubview(timeLabel)
        
        timeLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self).offset(10)
        }
        
        hasBeenContentBackgroundImage = UIImage(named: "has_been_content_background")
        contentBacngroundImage = UIImageView()
        contentBacngroundImage.image = hasBeenContentBackgroundImage
        addSubview(contentBacngroundImage)
        
        createProductGroup()
        
        createMailedInfo()
    }
    
    // 创建产品图片集合
    func createProductGroup() -> () {
        
        let hasBeenProductBackground = UIImage(named: "已邮寄产品框")
        
        let layout = UICollectionViewFlowLayout()
        
        // 設置 section 的間距 四個數值分別代表 上、左、下、右 的間距
        layout.sectionInset = UIEdgeInsetsMake(2, 0, 2, 0);
        
        // 設置每一行的間距
        layout.minimumLineSpacing = 4
        
        // 設置每個 cell 的尺寸
        layout.itemSize = CGSize(width: CGFloat(((hasBeenContentBackgroundImage?.size.width)! - 20) / 4 - 8), height: CGFloat((hasBeenProductBackground?.size.height)! + 10))
        
        productsGroup = UICollectionView(frame: CGRect(x: 10, y: timeLabel.bounds.height + 20, width: hasBeenContentBackgroundImage!.size.width - 20, height: (hasBeenProductBackground?.size.height)! * 2 + 10 + 10), collectionViewLayout: layout)
        productsGroup.backgroundColor = UIColor.clear
        
        hasbeenProductsDelegate = FCMyGiftHasBeenProductsDelegate()
        productsGroup.delegate = hasbeenProductsDelegate
        productsGroup.dataSource = hasbeenProductsDelegate
        
        productsGroup.register(FCHasBennMailedProductCell.self, forCellWithReuseIdentifier: "cellId")
        
        productsGroup.isScrollEnabled = false
        
        addSubview(productsGroup)
        
//        productsGroup.snp.makeConstraints { (make) in
//            make.width.equalTo(self)
//            make.height.equalTo((hasBeenContentBackgroundImage?.size.height)! * 2 + 20)
//            make.top.equalTo(timeLabel).offset(timeLabel.bounds.height + 10)
//        }
        
    }
    
    // 创建邮寄信息集合
    func createMailedInfo() -> () {
        
        // 邮寄状态
        statusLabel = MainCustomerLabel()
        statusLabel.outLineWidth = 2
        statusLabel.outTextColor = UIColor.white
        statusLabel.outLienTextColor = Constants.UI.OUT_LINE_COLOR
        statusLabel.text = "邮寄状态: 已寄出"
        statusLabel.font = UIFont.systemFont(ofSize: CGFloat(12))
        statusLabel.sizeToFit()
        addSubview(statusLabel)
        
        statusLabel.snp.makeConstraints { (make) in
            make.top.equalTo(productsGroup).offset(productsGroup.bounds.height + 10)
            make.left.equalTo(self).offset(10)
            make.right.equalTo(self).offset(10)
        }
        
        // 邮寄时间
        mailedTimeLabel = MainCustomerLabel()
        mailedTimeLabel.outLineWidth = 2
        mailedTimeLabel.outTextColor = UIColor.white
        mailedTimeLabel.outLienTextColor = Constants.UI.OUT_LINE_COLOR
        mailedTimeLabel.text = "邮寄时间: 2017.8.9 10:00"
        mailedTimeLabel.font = UIFont.systemFont(ofSize: CGFloat(12))
        mailedTimeLabel.sizeToFit()
        addSubview(mailedTimeLabel)
        
        mailedTimeLabel.snp.makeConstraints { (make) in
            make.top.equalTo(statusLabel).offset(statusLabel.bounds.height + 10)
            make.left.equalTo(statusLabel)
            make.right.equalTo(statusLabel)
        }
        
        // 邮寄单号
        mailedCodeLabel = MainCustomerLabel()
        mailedCodeLabel.outLineWidth = 2
        mailedCodeLabel.outTextColor = UIColor.white
        mailedCodeLabel.outLienTextColor = Constants.UI.OUT_LINE_COLOR
        mailedCodeLabel.text = "邮寄单号: 1231231231231323131"
        mailedCodeLabel.numberOfLines = 1
        mailedCodeLabel.font = UIFont.systemFont(ofSize: CGFloat(12))
        mailedCodeLabel.sizeToFit()
        addSubview(mailedCodeLabel)
        
        mailedCodeLabel.snp.makeConstraints { (make) in
            make.top.equalTo(mailedTimeLabel).offset(mailedTimeLabel.bounds.height + 10)
            make.left.equalTo(statusLabel)
            make.right.equalTo(statusLabel)
        }
        
        
        contentBacngroundImage.frame = CGRect(x: 0, y: timeLabel.bounds.height + 10 * 2, width: hasBeenContentBackgroundImage!.size.width, height: productsGroup.bounds.height + statusLabel.bounds.height + mailedTimeLabel.bounds.height +
            mailedCodeLabel.bounds.height + 10 * 3 + 10)
        
//        contentBacngroundImage.snp.makeConstraints { (make) in
//            make.width.equalTo(self)
//            make.height.equalTo(productsGroup.bounds.height + statusLabel.bounds.height + mailedTimeLabel.bounds.height +
//            mailedCodeLabel.bounds.height + 10 * 3)
//            make.top.equalTo(productsGroup)
//            make.bottom.equalTo(productsGroup.bounds.height + statusLabel.bounds.height + mailedTimeLabel.bounds.height +
//                mailedCodeLabel.bounds.height + 10 * 3)
//        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}




























