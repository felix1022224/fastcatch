
//
//  MessageTableViewCell.swift
//  FelixFastCatch
//
//  Created by 卢凡 on 2018/1/31.
//  Copyright © 2018年 felix. All rights reserved.
//

import UIKit

class MessageTableViewCell: UITableViewCell {

    var title = UILabel()
    var time = UILabel()
    var info = UITextView()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        
        let iconImage = UIImageView()
        iconImage.image = UIImage.init(named: "我的消息item")
        iconImage.sizeToFit()
        iconImage.frame.origin = CGPoint.init(x: 15, y: 15)
        addSubview(iconImage)
        
        title.font = UIFont.systemFont(ofSize: 14)
        title.text = "标题"
        title.numberOfLines = 1
        title.sizeToFit()
        title.frame.origin = CGPoint.init(x: 15 + 10 + iconImage.bounds.width, y: 15)
        addSubview(title)
        
        time.font = UIFont.systemFont(ofSize: 11)
        time.text = "2018-10-20 13:32:00"
        time.numberOfLines = 1
        time.textColor = UIColor.gray
        time.sizeToFit()
        time.frame.origin = CGPoint.init(x: UIScreen.main.bounds.width - 15 - time.bounds.width, y: 15 + title.bounds.height/2 - time.bounds.height/2)
        addSubview(time)
        
        info.font = UIFont.systemFont(ofSize: 12)
        info.text = "简介"
        info.textColor = UIColor.gray
        info.textContainer.maximumNumberOfLines = 3
        info.isEditable = false
        info.isScrollEnabled = false
        info.sizeToFit()
        info.frame.size = CGSize.init(width: UIScreen.main.bounds.width - title.frame.origin.x, height: info.bounds.height * 4)
        info.frame.origin = CGPoint.init(x: 15 + iconImage.bounds.width, y: 15 + title.bounds.height + 10)
        addSubview(info)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
