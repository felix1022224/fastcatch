//
//  PayListTableViewCell.swift
//  FelixFastCatch
//
//  Created by 卢凡 on 2018/1/4.
//  Copyright © 2018年 felix. All rights reserved.
//

import UIKit

class PayListTableViewCell: UITableViewCell {

    // 顶部背景
    var topContentBackground:UIImageView!
    
    // 钻石标题
    lazy var gemTitle:MainCustomerLabel = MainCustomerLabel()
    
    // 钻石描述
    lazy var gemInfo:MainCustomerLabel = MainCustomerLabel()
    
    // 购买按钮
    lazy var payBtn:UIButton = UIButton(type: .custom)
    
    // 购买价格
    lazy var payNumberLabel:MainCustomerLabel = MainCustomerLabel()
    
    let gem = UIImageView()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = UIColor.clear
        selectionStyle = .none
        
        // 顶部背景
        topContentBackground = UIImageView()
        topContentBackground.frame.size = CGSize(width: UIScreen.main.bounds.width - 40, height: (UIScreen.main.bounds.width - 40) * 0.3)
        topContentBackground.image = UIImage(named: "代币充值底")?.stretchableImage(withLeftCapWidth: 0, topCapHeight: 0)
        addSubview(topContentBackground)
        
        // 钻石
        gem.image = UIImage(named: "充值金币")
        gem.sizeToFit()
        addSubview(gem)
        
        gem.snp.makeConstraints { (make) in
            make.centerY.equalTo(topContentBackground)
            make.left.equalTo(topContentBackground).offset(25)
        }
        
        // 钻石标题
        gemTitle.font = UIFont.getCustomeYuanTiFont(fontSize: 16)
        gemTitle.outLineWidth = Constants.UI.OUT_LINE_WIDTH
        gemTitle.outTextColor = UIColor.white
        gemTitle.outLienTextColor = Constants.UI.OUT_LINE_COLOR
        gemTitle.numberOfLines = 1
        
        addSubview(gemTitle)
        
        gemTitle.snp.makeConstraints { (make) in
            make.top.equalTo(gem)
            make.left.equalTo(gem).offset(gem.bounds.width + 10)
        }
        
        // 钻石描述
        gemInfo.font = UIFont.getCustomeYuanTiFont(fontSize: 11)
        gemInfo.outLineWidth = Constants.UI.OUT_LINE_WIDTH
        gemInfo.outTextColor = UIColor.white
        gemInfo.outLienTextColor = Constants.UI.OUT_LINE_COLOR
        gemInfo.numberOfLines = 1
        
        addSubview(gemInfo)
        
        gemInfo.snp.makeConstraints { (make) in
            make.bottom.equalTo(gem)
            make.left.equalTo(gemTitle)
        }
        
        // 购买按钮
        payBtn.setBackgroundImage(UIImage(named: "普通充值按钮"), for: .normal)
        payBtn.titleLabel?.font = UIFont.getCustomeYuanTiFont(fontSize: 11)
        payBtn.titleLabel?.textColor = UIColor.white
        payBtn.sizeToFit()
        addSubview(payBtn)
        payBtn.frame = CGRect(x: self.bounds.width - 10 - payBtn.bounds.width , y: topContentBackground.bounds.height / 2 - payBtn.bounds.height/2, width: payBtn.bounds.width, height: payBtn.bounds.height)
        
//        gemInfo.snp.makeConstraints { (make) in
//            make.centerY.equalTo(topContentBackground)
//            make.left.equalTo(gem).offset(gem.bounds.width + 5)
//            make.right.equalTo(payBtn).offset(-(payBtn.bounds.width + 5))
//        }
        
        payNumberLabel.outLineWidth = Constants.UI.OUT_LINE_WIDTH
        payNumberLabel.outTextColor = UIColor.white
        payNumberLabel.outLienTextColor = Constants.UI.OUT_LINE_COLOR
        payNumberLabel.font = UIFont.getCustomeYuanTiFont(fontSize: 12)
        payNumberLabel.sizeToFit()
        addSubview(payNumberLabel)
        
        payNumberLabel.snp.makeConstraints { (make) in
            make.centerX.equalTo(payBtn).offset(8)
            make.centerY.equalTo(payBtn).offset(-1)
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
