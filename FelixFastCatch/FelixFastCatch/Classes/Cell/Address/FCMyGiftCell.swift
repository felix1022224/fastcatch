//
//  FCMyGiftCell.swift
//  FastCatch
//
//  Created by 卢凡 on 2017/7/20.
//  Copyright © 2017年 felix. All rights reserved.
//

import UIKit

class FCMyGiftCell: UITableViewCell {

    // 内容背景
    fileprivate var contentGroup:UIImageView!
    
    // 产品背景图
    fileprivate var productBackgroundImage:UIImageView!
    
    // 产品图
    var productImage:UIImageView!
    
    // 选择按钮
    var selectBtn:UIButton!
    
    // 产品名称
    var productTitleLabel:MainCustomerLabel!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = UIColor.clear
        selectionStyle = UITableViewCellSelectionStyle.none
        
        setupUIWidget()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

extension FCMyGiftCell{

    // 装载布局
    func setupUIWidget() -> () {
        contentGroup = UIImageView()
        contentGroup.image = UIImage(named: "邮寄item背景")
        contentGroup.sizeToFit()
        contentGroup.frame.size = CGSize(width: UIScreen.main.bounds.width * 0.98, height: (UIScreen.main.bounds.width * 0.98)*0.3)
        addSubview(contentGroup)
        
        // 产品背景图
        productBackgroundImage = UIImageView()
        productBackgroundImage.image = UIImage(named: "邮寄产品框")
        productBackgroundImage.sizeToFit()
        addSubview(productBackgroundImage)
        
        productBackgroundImage.snp.makeConstraints { (make) in
            make.centerY.equalTo(contentGroup).offset(-2.5)
//            make.top.equalTo(contentGroup).offset(contentGroup.bounds.height / 2 - productBackgroundImage.bounds.height / 2)
            make.left.equalTo(contentGroup).offset(productBackgroundImage.bounds.width / 2.5)
        }
        
        // 产品图
        productImage = UIImageView()
        productImage.backgroundColor = UIColor.white
        productImage.layer.cornerRadius = 3
        productImage.layer.masksToBounds = true
        addSubview(productImage)
        
        productImage.snp.makeConstraints { (make) in
            make.width.equalTo(productBackgroundImage.bounds.width * 0.85)
            make.height.equalTo(productBackgroundImage.bounds.height * 0.85)
            make.center.equalTo(productBackgroundImage)
        }
        
        // 选择按钮
        selectBtn = UIButton()
        selectBtn.setBackgroundImage(UIImage(named: "邮寄未选中"), for: .normal)
        selectBtn.setBackgroundImage(UIImage(named: "邮寄未选中"), for: .highlighted)
        selectBtn.setBackgroundImage(UIImage(named: "邮寄选中"), for: .selected)
        selectBtn.sizeToFit()
        addSubview(selectBtn)
//        selectBtn.addTarget(self, action: #selector(selectBtnClick), for: .touchUpInside)
        selectBtn.snp.makeConstraints { (make) in
            make.centerY.equalTo(contentGroup)
            make.right.equalTo(contentGroup).offset(-(productBackgroundImage.bounds.width / 2.5))
        }
        
        // 产品名标题
        productTitleLabel = MainCustomerLabel()
        productTitleLabel.numberOfLines = 1
        productTitleLabel.font = UIFont(name: "FZY4K--GBK1-0", size: CGFloat(15))
        productTitleLabel.outLineWidth = Constants.UI.OUT_LINE_WIDTH
        productTitleLabel.outTextColor = UIColor.white
        productTitleLabel.outLienTextColor = Constants.UI.OUT_LINE_COLOR
        addSubview(productTitleLabel)
        
        productTitleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(productBackgroundImage).offset(productBackgroundImage.bounds.width + 10)
            make.right.equalTo(selectBtn).offset(-(selectBtn.bounds.width + 10))
            make.centerY.equalTo(contentGroup)
        }
        
    }
    
//    func selectBtnClick() -> () {
//        if selectBtn.isSelected {
//            selectBtn.isSelected = false
//        }else {
//            selectBtn.isSelected = true
//        }
//    }
    
}




























