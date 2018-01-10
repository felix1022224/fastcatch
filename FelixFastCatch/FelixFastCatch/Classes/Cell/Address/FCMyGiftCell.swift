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
    
    /// 剩余时间
    var timeLabel:MainCustomerLabel!
    
    let timeBackgroundView = UIView()
    var integralLabel:MainCustomerLabel!
    
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
            make.left.equalTo(contentGroup).offset(productBackgroundImage.bounds.width / 2.5)
        }
        
        // 产品图
        productImage = UIImageView()
        productImage.backgroundColor = UIColor.white
        productImage.layer.cornerRadius = 3
        productImage.layer.masksToBounds = true
        addSubview(productImage)
        
        productImage.snp.makeConstraints { (make) in
            make.width.equalTo(productBackgroundImage.bounds.width * 0.9)
            make.height.equalTo(productBackgroundImage.bounds.height * 0.9)
            make.center.equalTo(productBackgroundImage)
        }
        
        // 选择按钮
        selectBtn = UIButton()
        selectBtn.setBackgroundImage(UIImage(named: "邮寄未选中"), for: .normal)
        selectBtn.setBackgroundImage(UIImage(named: "邮寄未选中"), for: .highlighted)
        selectBtn.setBackgroundImage(UIImage(named: "邮寄选中"), for: .selected)
        selectBtn.sizeToFit()
        addSubview(selectBtn)
        selectBtn.snp.makeConstraints { (make) in
            make.centerY.equalTo(contentGroup)
            make.right.equalTo(contentGroup).offset(-(productBackgroundImage.bounds.width / 2.5))
        }
        
        // 产品名标题
        productTitleLabel = MainCustomerLabel()
        productTitleLabel.numberOfLines = 1
        productTitleLabel.font = UIFont.getCustomeYuanTiFont(fontSize: 13)
        productTitleLabel.outLineWidth = Constants.UI.OUT_LINE_WIDTH
        productTitleLabel.outTextColor = UIColor.white
        productTitleLabel.outLienTextColor = Constants.UI.OUT_LINE_COLOR
        addSubview(productTitleLabel)
        
        productTitleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(productBackgroundImage).offset(productBackgroundImage.bounds.width + 10)
            make.right.equalTo(selectBtn).offset(-(selectBtn.bounds.width + 10))
            make.top.equalTo(productImage).offset(5)
        }
        
        // 剩余时间
        timeLabel = MainCustomerLabel()
        timeLabel.text = "申请提取剩余时间:100天"
        timeLabel.numberOfLines = 1
        timeLabel.font = UIFont.getCustomeYuanTiFont(fontSize: 11)
        timeLabel.outLineWidth = 2
        timeLabel.outTextColor = UIColor.white
        timeLabel.outLienTextColor = Constants.UI.OUT_LINE_COLOR
        timeLabel.sizeToFit()
        addSubview(timeLabel)
        
        timeLabel.snp.makeConstraints { (make) in
            make.bottom.equalTo(productImage).offset(-5)
            make.left.equalTo(productTitleLabel)
            make.right.equalTo(productTitleLabel)
        }
        
        // 积分背景
        timeBackgroundView.frame = CGRect(x: productBackgroundImage.bounds.width / 2.5 + 1, y: contentGroup.bounds.height - productBackgroundImage.bounds.height/2 - (productBackgroundImage.bounds.height * 0.25)/2, width: productBackgroundImage.bounds.width - 2, height: productBackgroundImage.bounds.height * 0.25)
        timeBackgroundView.backgroundColor = UIColor(red: 0/255.0, green: 0/255.0, blue: 0/255.0, alpha: 0.5)
        let corners: UIRectCorner = [.bottomLeft,.bottomRight]
        timeBackgroundView.corner(byRoundingCorners: corners, radii: 6)
        addSubview(timeBackgroundView)
        
        // 积分label
        integralLabel = MainCustomerLabel()
        integralLabel.text = "9999积分"
        integralLabel.numberOfLines = 1
        integralLabel.font = UIFont.getCustomeYuanTiFont(fontSize: 11)
        integralLabel.outLineWidth = 1
        integralLabel.outTextColor = UIColor.white
        integralLabel.outLienTextColor = Constants.UI.OUT_LINE_COLOR
        integralLabel.textAlignment = .center
        integralLabel.sizeToFit()
        integralLabel.frame.size = CGSize(width: productBackgroundImage.bounds.width, height: productBackgroundImage.bounds.height * 0.3)
        addSubview(integralLabel)
        
        integralLabel.center = timeBackgroundView.center
        
    }
}

extension UIView {
    
    /// 部分圆角
    ///
    /// - Parameters:
    ///   - corners: 需要实现为圆角的角，可传入多个
    ///   - radii: 圆角半径
    func corner(byRoundingCorners corners: UIRectCorner, radii: CGFloat) {
        let maskPath = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radii, height: radii))
        let maskLayer = CAShapeLayer()
        maskLayer.frame = self.bounds
        maskLayer.path = maskPath.cgPath
        self.layer.mask = maskLayer
    }
}





























