//
//  GameHistoryCell.swift
//  FelixFastCatch
//
//  Created by 卢凡 on 2017/10/10.
//  Copyright © 2017年 felix. All rights reserved.
//

import UIKit
import Kingfisher

//游戏记录的cell
class GameHistoryCell: UITableViewCell {
    
    lazy var productTitleLabel = MainCustomerLabel()
    
    lazy var productTimeLabel = MainCustomerLabel()
    
    /// 游戏状态
    lazy var productStatusImage = UIImageView()
    
    /// 产品图片
    lazy var productImage = UIImageView()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = UIColor.clear
        selectionStyle = .none
        
        /// 背景
        let backgroundImage = UIImageView(image: UIImage(named: "游戏记录背景框"))
//        backgroundImage.sizeToFit()
        backgroundImage.frame.size = CGSize(width: (UIScreen.main.bounds.width * 0.98), height: (UIScreen.main.bounds.width * 0.95)*0.3)
        addSubview(backgroundImage)
        
        /// 产品背景图
        let productBackgroundImage = UIImageView(image: UIImage(named: "游戏记录框"))
        productBackgroundImage.sizeToFit()
        productBackgroundImage.frame = CGRect(x: productBackgroundImage.bounds.width/2.5, y: backgroundImage.bounds.height/2 - productBackgroundImage.bounds.height * 0.8/2, width: productBackgroundImage.bounds.width * 0.8, height: productBackgroundImage.bounds.height * 0.8)
        addSubview(productBackgroundImage)
        
        /// 产品图
        productImage.frame.size = CGSize(width: productBackgroundImage.bounds.width * 0.90, height: productBackgroundImage.bounds.height * 0.90)
        productImage.backgroundColor = UIColor.clear
        productImage.center = productBackgroundImage.center
        productImage.layer.cornerRadius = 3
        productImage.layer.masksToBounds = true
        addSubview(productImage)
        
        /// 游戏状态
        productStatusImage.image = UIImage(named: "游戏失败")
        productStatusImage.sizeToFit()
//        productStatusImage.frame.size = CGSize(width: (productStatusImage.image?.size.width)! * 0.4, height: (productStatusImage.image?.size.height)! * 0.4)
        addSubview(productStatusImage)
        
        productStatusImage.snp.makeConstraints { (make) in
            make.centerY.equalTo(backgroundImage).offset(-2.5)
            make.right.equalTo(backgroundImage).offset(-productBackgroundImage.bounds.width/2)
            make.width.equalTo(productStatusImage.bounds.width * 0.8)
            make.height.equalTo(productStatusImage.bounds.height * 0.8)
        }
        
        /// 产品的标题
        productTitleLabel.font = UIFont(name: "FZY4K--GBK1-0", size: CGFloat(13))
        productTitleLabel.outLineWidth = Constants.UI.OUT_LINE_WIDTH
        productTitleLabel.outTextColor = UIColor.white
        productTitleLabel.outLienTextColor = Constants.UI.OUT_LINE_COLOR
        productTitleLabel.text = "我是标题哈哈哈哈哈哈"
        productTitleLabel.sizeToFit()
        addSubview(productTitleLabel)
        
        productTitleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(productBackgroundImage).offset(5)
            make.left.equalTo(productBackgroundImage).offset(productBackgroundImage.bounds.width + 10)
            make.right.equalTo(productStatusImage).offset(productStatusImage.bounds.width + 10)
        }
        
        /// 时间记录
        productTimeLabel.font = UIFont(name: "FZY4K--GBK1-0", size: CGFloat(11))
        productTimeLabel.outLineWidth = Constants.UI.OUT_LINE_WIDTH
        productTimeLabel.outTextColor = UIColor.white
        productTimeLabel.outLienTextColor = Constants.UI.OUT_LINE_COLOR
        productTimeLabel.text = "我是时间"
        productTimeLabel.sizeToFit()
        addSubview(productTimeLabel)
        
        productTimeLabel.snp.makeConstraints { (make) in
            make.bottom.equalTo(productBackgroundImage).offset(-5)
            make.left.equalTo(productTitleLabel)
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func changeGameStatus(gameStatus:Int){
        if gameStatus == 2 {
            productStatusImage.image = UIImage(named: "游戏成功")
        }else{
            productStatusImage.image = UIImage(named: "游戏失败")
        }
    }
    
}
