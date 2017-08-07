//
//  CheckIn7DayView.swift
//  FelixFastCatch
//
//  Created by 卢凡 on 2017/8/7.
//  Copyright © 2017年 felix. All rights reserved.
//

import UIKit

class CheckIn7DayView: UIView {

    /// 签到的天数
    private var checkNumber:MainCustomerLabel!
    
    /// 签到的背景图
    private var checkBackground:UIImageView!
    
    private var isChecked = false
    
    init(frame: CGRect, number:Int, isChecked:Bool) {
        super.init(frame: frame)
        
        self.isChecked = isChecked
        
        checkBackground = UIImageView()
        if isChecked {
            checkBackground.image = UIImage(named: "8已签")
        }else{
            checkBackground.image = UIImage(named: "8未签")
        }
        checkBackground.sizeToFit()
        addSubview(checkBackground)
        
        self.frame.size = CGSize(width: checkBackground.bounds.width, height: checkBackground.bounds.height)
        
        checkNumber = MainCustomerLabel()
        checkNumber.text = String(number)
        checkNumber.font = UIFont(name: "Skranji-Bold", size: CGFloat(20))
        checkNumber.outLineWidth = 1
        checkNumber.outTextColor = UIColor.white
        checkNumber.outLienTextColor = UIColor.black
        checkNumber.sizeToFit()
        addSubview(checkNumber)
        
        checkNumber.frame = CGRect(x: checkBackground.bounds.width/2 - checkNumber.bounds.width/2, y: 5, width: checkNumber.bounds.width, height: checkNumber.bounds.height)
        
    }
    
    func setChecked(isChecked:Bool) -> () {
        self.isChecked = isChecked
        if isChecked {
            checkBackground.image = UIImage(named: "8已签")
        }else{
            checkBackground.image = UIImage(named: "8未签")
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
