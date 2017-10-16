//
//  TokenHistoryCell.swift
//  FelixFastCatch
//
//  Created by 卢凡 on 2017/10/10.
//  Copyright © 2017年 felix. All rights reserved.
//

import UIKit

class TokenHistoryCell: UITableViewCell {

    /// 代币变化的label
    lazy var tokenChangeLabel = MainCustomerLabel()
    
    /// 代币记录的图标
    lazy var actionImage = UIImageView()
    
    /// 代币记录的title
    lazy var tokenChangeTitle = MainCustomerLabel()
    
    /// 代币记录的时间
    lazy var tokenChangeTime = MainCustomerLabel()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = UIColor.clear
        selectionStyle = .none
        
        /// 背景
        let backgroundImage = UIImageView(image: UIImage(named: "代币记录背景框"))
//        backgroundImage.sizeToFit()
        backgroundImage.frame.size = CGSize(width: (UIScreen.main.bounds.width * 0.98), height: (UIScreen.main.bounds.width * 0.98)*0.3)
        addSubview(backgroundImage)
        
        /// item前面的图标
        actionImage.image = UIImage(named: "代币记录游戏图标")
        actionImage.sizeToFit()
        addSubview(actionImage)
        
        actionImage.snp.makeConstraints { (make) in
            make.left.equalTo(backgroundImage).offset(20)
            make.centerY.equalTo(backgroundImage)
        }
        
        /// 代币变化的label
        tokenChangeLabel.font = UIFont(name: "FZY4K--GBK1-0", size: CGFloat(18))
        tokenChangeLabel.outLineWidth = Constants.UI.OUT_LINE_WIDTH
        tokenChangeLabel.outTextColor = UIColor.white
        tokenChangeLabel.outLienTextColor = Constants.UI.OUT_LINE_COLOR
        tokenChangeLabel.text = "- 100"
        tokenChangeLabel.sizeToFit()
        addSubview(tokenChangeLabel)
        
        tokenChangeLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(backgroundImage)
            make.right.equalTo(backgroundImage).offset(-25)
        }
        
        /// 代币记录的title
        tokenChangeTitle.font = UIFont(name: "FZY4K--GBK1-0", size: CGFloat(14))
        tokenChangeTitle.outLineWidth = Constants.UI.OUT_LINE_WIDTH
        tokenChangeTitle.outTextColor = UIColor.white
        tokenChangeTitle.outLienTextColor = Constants.UI.OUT_LINE_COLOR
        tokenChangeTitle.text = "败家子，输了100"
        tokenChangeTitle.sizeToFit()
        addSubview(tokenChangeTitle)
        
        tokenChangeTitle.snp.makeConstraints { (make) in
            make.top.equalTo(actionImage).offset(5)
            make.left.equalTo(actionImage).offset(actionImage.bounds.width + 10)
        }
        
        /// 代币记录的时间
        tokenChangeTime.font = UIFont(name: "FZY4K--GBK1-0", size: CGFloat(12))
        tokenChangeTime.outLineWidth = Constants.UI.OUT_LINE_WIDTH
        tokenChangeTime.outTextColor = UIColor.white
        tokenChangeTime.outLienTextColor = Constants.UI.OUT_LINE_COLOR
        tokenChangeTime.text = "败家子，输了100"
        tokenChangeTime.sizeToFit()
        addSubview(tokenChangeTime)
        
        tokenChangeTime.snp.makeConstraints { (make) in
            make.bottom.equalTo(actionImage).offset(-5)
            make.left.equalTo(tokenChangeTitle)
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
