//
//  TitlesCell.swift
//  FelixFastCatch
//
//  Created by 卢凡 on 2017/10/13.
//  Copyright © 2017年 felix. All rights reserved.
//

import UIKit

class TitlesCell: UICollectionViewCell {
    
    lazy var itemBackgroundImage = UIImageView()
    
    /// 标题
    lazy var title = MainCustomerLabel()
    
    /// 图片
    lazy var image = UIImageView()
    
    lazy var info = MainCustomerLabel()
    
    /// 敬请期待
    lazy var awaitImage = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = UIColor.clear
        
        itemBackgroundImage.image = UIImage(named: "成就背景")
        itemBackgroundImage.frame.size = CGSize(width: self.bounds.width*0.99, height: self.bounds.height*0.99)
        addSubview(itemBackgroundImage)
        
        title.outLineWidth = Constants.UI.OUT_LINE_WIDTH
        title.outTextColor = UIColor.white
        title.outLienTextColor = Constants.UI.OUT_LINE_COLOR
        title.font = UIFont(name: "FZY4K--GBK1-0", size: CGFloat(12))
        title.text = "萌新"
        title.textAlignment = .center
        title.sizeToFit()
        addSubview(title)
        
        title.snp.makeConstraints { (make) in
            make.top.equalTo(itemBackgroundImage).offset(10)
            make.centerX.equalTo(self)
        }
        
        image.frame = CGRect(x: self.bounds.width/2 - 50/2, y: 10 + title.bounds.height + 15, width: 50, height: 50)
        addSubview(image)
        
        info.outLineWidth = 2
        info.outTextColor = UIColor.white
        info.outLienTextColor = Constants.UI.OUT_LINE_COLOR
        info.font = UIFont(name: "FZY4K--GBK1-0", size: CGFloat(10))
//        info.text = "萌新\n123333"
        info.numberOfLines = 2
        info.textAlignment = .center
        info.sizeToFit()
        addSubview(info)
        
        info.snp.makeConstraints { (make) in
            make.bottom.equalTo(self)
            make.centerX.equalTo(self)
            make.left.equalTo(self).offset(5)
            make.right.equalTo(self).offset(-5)
            make.height.equalTo(itemBackgroundImage.bounds.height * 0.3)
        }
        
        image.kf.setImage(with: URL(string: "https://ss0.bdstatic.com/70cFvHSh_Q1YnxGkpoWK1HF6hhy/it/u=3525174135,2597372701&fm=200&gp=0.jpg"))
        
        awaitImage.image = UIImage(named: "敬请期待")
        awaitImage.frame.size = CGSize(width: self.bounds.width, height: self.bounds.height)
        addSubview(awaitImage)
        
        awaitImage.isHidden = true
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func getAttributeStringWithString(_ string: String,lineSpace:CGFloat
        ) -> NSAttributedString{
        let attributedString = NSMutableAttributedString(string: string)
        let paragraphStye = NSMutableParagraphStyle()
        
        //调整行间距
        paragraphStye.lineSpacing = lineSpace
        paragraphStye.alignment = .center
        let rang = NSMakeRange(0, CFStringGetLength(string as CFString!))
        attributedString .addAttribute(NSAttributedStringKey.paragraphStyle, value: paragraphStye, range: rang)
        return attributedString
        
    }
    
}
