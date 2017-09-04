//
//  HasBeenMailedView.swift
//  FelixFastCatch
//
//  Created by 卢凡 on 2017/8/8.
//  Copyright © 2017年 felix. All rights reserved.
//

import UIKit
import SwiftyJSON

class HasBeenMailedView: UIView {

    // 时间标签
    var timeLabel:MainCustomerLabel!
    
    // 商品图标集合
    fileprivate var productsGroup:UICollectionView!
    
    // 邮寄状态
    var statusLabel:MainCustomerLabel!
    
    // 邮寄时间
    var mailedTimeLabel:MainCustomerLabel!
    
    // 邮寄单号
    var mailedCodeLabel:MainCustomerLabel!
    
    // 主要内容的背景图
    fileprivate var contentBacngroundImage:UIImageView!
    
    fileprivate var hasBeenContentBackgroundImage:UIImage!
    
    // 代理
    fileprivate var hasbeenProductsDelegate:FCMyGiftHasBeenProductsDelegate!
    
    /// 当前行的数据
    private var itemData:JSON!
    
    func getHeight() -> CGFloat {
        return CGFloat(10 + timeLabel.bounds.height + productsGroup.bounds.height + 10 + statusLabel.bounds.height + 10 +
        mailedTimeLabel.bounds.height + 10 + mailedCodeLabel.bounds.height + 20)
    }
    
    init() {
        super.init(frame: CGRect.zero)
    }
    // 装载UI控件
    func setupUIWidget(item:JSON) -> () {
        
        self.itemData = item
        
        backgroundColor = UIColor.clear
        
        // 时间标签
        timeLabel = MainCustomerLabel()
        timeLabel.font = UIFont(name: "FZY4K--GBK1-0", size: CGFloat(12))
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
        layout.itemSize = CGSize(width: CGFloat(((hasBeenContentBackgroundImage?.size.width)! - 20) / 4 - 8), height: CGFloat((hasBeenProductBackground?.size.height)! + 5))
        
        var line = itemData["awards"].array!.count / 4
        if line <= 0 {
            line = 1
        }else{
            if itemData["awards"].array!.count % 4 > 0 {
                line = line + 1
            }
        }
        
        productsGroup = UICollectionView(frame: CGRect(x: 10, y: timeLabel.bounds.height + 34, width: hasBeenContentBackgroundImage!.size.width - 20, height: (hasBeenProductBackground?.size.height)! * CGFloat(line) + 10 * CGFloat(line)), collectionViewLayout: layout)
        productsGroup.backgroundColor = UIColor.clear
        
        hasbeenProductsDelegate = FCMyGiftHasBeenProductsDelegate(dataSource: itemData["awards"].array!)
        productsGroup.delegate = hasbeenProductsDelegate
        productsGroup.dataSource = hasbeenProductsDelegate
        
        productsGroup.register(FCHasBennMailedProductCell.self, forCellWithReuseIdentifier: "cellId")
        
        productsGroup.isScrollEnabled = false
        
        addSubview(productsGroup)
        
    }
    
    // 创建邮寄信息集合
    func createMailedInfo() -> () {
        
        // 邮寄状态
        statusLabel = MainCustomerLabel()
        statusLabel.outLineWidth = 2
        statusLabel.outTextColor = UIColor.white
        statusLabel.outLienTextColor = Constants.UI.OUT_LINE_COLOR
        statusLabel.text = "邮寄状态: 已寄出"
        statusLabel.font = UIFont(name: "FZY4K--GBK1-0", size: CGFloat(12))
        statusLabel.sizeToFit()
        addSubview(statusLabel)
        
        statusLabel.snp.makeConstraints { (make) in
            make.top.equalTo(productsGroup).offset(productsGroup.bounds.height)
            make.left.equalTo(self).offset(10)
            make.right.equalTo(self).offset(10)
        }
        
        // 邮寄时间
        mailedTimeLabel = MainCustomerLabel()
        mailedTimeLabel.outLineWidth = 2
        mailedTimeLabel.outTextColor = UIColor.white
        mailedTimeLabel.outLienTextColor = Constants.UI.OUT_LINE_COLOR
        mailedTimeLabel.text = "邮寄时间: 2017.8.9 10:00"
        mailedTimeLabel.font = UIFont(name: "FZY4K--GBK1-0", size: CGFloat(12))
        mailedTimeLabel.sizeToFit()
        addSubview(mailedTimeLabel)
        
//        mailedTimeLabel.isHidden = true
        
        mailedTimeLabel.snp.makeConstraints { (make) in
            make.top.equalTo(statusLabel).offset(statusLabel.bounds.height + 5)
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
        mailedCodeLabel.font = UIFont(name: "FZY4K--GBK1-0", size: CGFloat(12))
        mailedCodeLabel.sizeToFit()
        addSubview(mailedCodeLabel)
        
//        mailedCodeLabel.isHidden = true
        
        mailedCodeLabel.snp.makeConstraints { (make) in
            make.top.equalTo(mailedTimeLabel).offset(mailedTimeLabel.bounds.height + 5)
            make.left.equalTo(statusLabel)
            make.right.equalTo(statusLabel)
        }
        
        contentBacngroundImage.frame = CGRect(x: 0, y: timeLabel.bounds.height + 10 * 2, width: hasBeenContentBackgroundImage!.size.width, height: productsGroup.bounds.height + statusLabel.bounds.height + mailedTimeLabel.bounds.height +
            mailedCodeLabel.bounds.height + 12 * 3 + 10)
        
        //        contentBacngroundImage.snp.makeConstraints { (make) in
        //            make.width.equalTo(self)
        //            make.height.equalTo(productsGroup.bounds.height + statusLabel.bounds.height + mailedTimeLabel.bounds.height +
        //            mailedCodeLabel.bounds.height + 10 * 3)
        //            make.top.equalTo(productsGroup)
        //            make.bottom.equalTo(productsGroup.bounds.height + statusLabel.bounds.height + mailedTimeLabel.bounds.height +
        //                mailedCodeLabel.bounds.height + 10 * 3)
        //        }
        self.frame.size = CGSize(width: hasBeenContentBackgroundImage!.size.width, height: getHeight())
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
