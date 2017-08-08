//
//  FCMyGiftHasBeenMailedCell.swift
//  FastCatch
//
//  Created by 卢凡 on 2017/7/21.
//  Copyright © 2017年 felix. All rights reserved.
//

import UIKit
import SwiftyJSON

class FCMyGiftHasBeenMailedCell: UITableViewCell {
    
    /// cell view
    var hasBeenMailedView:HasBeenMailedView!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = UIColor.clear
        selectionStyle = UITableViewCellSelectionStyle.none
        
        hasBeenMailedView = HasBeenMailedView()

    }
    
    func setupItemUI(itemData:JSON) -> () {
        hasBeenMailedView.removeFromSuperview()
        self.removeFromSuperview()
        
        hasBeenMailedView = HasBeenMailedView()
        hasBeenMailedView.setupUIWidget(item: itemData)
        addSubview(hasBeenMailedView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    

}




























