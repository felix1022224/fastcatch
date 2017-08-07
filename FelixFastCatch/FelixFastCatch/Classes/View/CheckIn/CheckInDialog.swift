//
//  CheckInDialog.swift
//  FelixFastCatch
//
//  Created by 卢凡 on 2017/8/7.
//  Copyright © 2017年 felix. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class CheckInDialog: BaseDialog {

    /// 大于8天的（包括8天的签到背景）
    fileprivate var greater8DayImageView:UIImageView!
    
    /// 签到按钮
    fileprivate var checkInBtn:UIButton!
    
    /// 7 天以下的签到天数
    fileprivate var check1DayView:CheckIn7DayView!
    fileprivate var check2DayView:CheckIn7DayView!
    fileprivate var check3DayView:CheckIn7DayView!
    fileprivate var check4DayView:CheckIn7DayView!
    fileprivate var check5DayView:CheckIn7DayView!
    fileprivate var check6DayView:CheckIn7DayView!
    fileprivate var check7DayView:CheckIn7DayView!
    
    fileprivate var check7DayViews:[CheckIn7DayView] = [CheckIn7DayView]()
    
    override func createView() {
        createBackgroundImage(imageName: "checkin_background")
        
        backgroundImage.frame.size = CGSize(width: 290, height: 200)
        backgroundImage.center = self.center
        
        createCloseBtn()
        
        if Constants.User.checkDays > 7 {
            /// 大于8天的签到页面
            createGreater8DayCheckInView()
        }else{
            /// 小于8天的签到页面
            create7DayCheckInView()
        }
        
        /// 签到按钮
        checkInBtn = UIButton()
        checkInBtn.setBackgroundImage(UIImage(named: "签到按钮"), for: .normal)
        checkInBtn.setBackgroundImage(UIImage(named: "已签到按钮"), for: .disabled)
        addSubview(checkInBtn)
        
        checkInBtn.addTarget(self, action: #selector(UserCheckIn), for: .touchUpInside)
        
        if Constants.User.todayChecked {
            checkInBtn.isEnabled = false
        }else{
            checkInBtn.isEnabled = true
        }
        
        checkInBtn.snp.makeConstraints { (make) in
            make.width.equalTo(120)
            make.height.equalTo(35)
            make.bottom.equalTo(backgroundImage).offset(35/2)
            make.centerX.equalTo(backgroundImage)
        }
        
        addDialogToWindow()
    }

}


// MARK: - 8天之前的签到页面 1-7天
extension CheckInDialog{
    
    /// 创建1-7天的签到页面
    func create7DayCheckInView() -> () {
        
        check2DayView = CheckIn7DayView(frame: CGRect.zero, number: 2, isChecked: false)
        check2DayView.sizeToFit()
        addSubview(check2DayView)
        
        check2DayView.snp.makeConstraints { (make) in
            make.top.equalTo(backgroundImage).offset(55)
            make.centerX.equalTo(backgroundImage).offset(-check2DayView.bounds.width/2)
        }
        
        check1DayView = CheckIn7DayView(frame: CGRect.zero, number: 1, isChecked: false)
        addSubview(check1DayView)

        check1DayView.snp.makeConstraints { (make) in
            make.right.equalTo(check2DayView).offset(-check2DayView.bounds.width * 1.5)
            make.centerY.equalTo(check2DayView)
        }
        
        check3DayView = CheckIn7DayView(frame: CGRect.zero, number: 3, isChecked: false)
        addSubview(check3DayView)
        
        check3DayView.snp.makeConstraints { (make) in
            make.left.equalTo(check2DayView).offset(check2DayView.bounds.width * 1.5)
            make.centerY.equalTo(check2DayView)
        }
        
        check5DayView = CheckIn7DayView(frame: CGRect.zero, number: 5, isChecked: false)
        addSubview(check5DayView)
        
        check5DayView.snp.makeConstraints { (make) in
            make.right.equalTo(check2DayView).offset(-(check2DayView.bounds.width/2 + 10))
            make.top.equalTo(check2DayView).offset(check2DayView.bounds.height + 5)
        }
        
        check6DayView = CheckIn7DayView(frame: CGRect.zero, number: 6, isChecked: false)
        addSubview(check6DayView)
        
        check6DayView.snp.makeConstraints { (make) in
            make.right.equalTo(check2DayView).offset(check2DayView.bounds.width/2 + 10)
            make.top.equalTo(check2DayView).offset(check2DayView.bounds.height + 5)
        }
        
        check4DayView = CheckIn7DayView(frame: CGRect.zero, number: 4, isChecked: false)
        addSubview(check4DayView)
        
        check4DayView.snp.makeConstraints { (make) in
            make.right.equalTo(check5DayView).offset(-check5DayView.bounds.width*1.5)
            make.centerY.equalTo(check5DayView)
        }
        
        check7DayView = CheckIn7DayView(frame: CGRect.zero, number: 7, isChecked: false)
        addSubview(check7DayView)
        
        check7DayView.snp.makeConstraints { (make) in
            make.left.equalTo(check6DayView).offset(check6DayView.bounds.width*1.5)
            make.centerY.equalTo(check6DayView)
        }
        
        check7DayViews.append(check1DayView)
        check7DayViews.append(check2DayView)
        check7DayViews.append(check3DayView)
        check7DayViews.append(check4DayView)
        check7DayViews.append(check5DayView)
        check7DayViews.append(check6DayView)
        check7DayViews.append(check7DayView)
        
        initCheckIn7DayView()
    }
    
    /// 初始化前七天签到样式
    func initCheckIn7DayView() -> () {
        check1DayView.setChecked(isChecked: false)
        check2DayView.setChecked(isChecked: false)
        check3DayView.setChecked(isChecked: false)
        check4DayView.setChecked(isChecked: false)
        check5DayView.setChecked(isChecked: false)
        check6DayView.setChecked(isChecked: false)
        check7DayView.setChecked(isChecked: false)
        
        print("checked:\(Constants.User.checkDays)")
        
        for i in 0..<Constants.User.checkDays {
            check7DayViews[i].setChecked(isChecked: true)
        }
    }
    
}


// MARK: - 8天以后的签到页面
extension CheckInDialog{
    
    /// 创建大于7天的签到页面
    func createGreater8DayCheckInView() -> () {
        let checkInYes = UIImage(named: "8已签")
        let checkInNo = UIImage(named: "8未签")
        
        greater8DayImageView = UIImageView()
        if Constants.User.todayChecked {
            greater8DayImageView.image = checkInYes
        }else{
            greater8DayImageView.image = checkInNo
        }
        greater8DayImageView.sizeToFit()
        addSubview(greater8DayImageView)
        
        greater8DayImageView.center = backgroundImage.center
    }
    
}

// MARK: - 向服务端请求签到
extension CheckInDialog{
    
    func UserCheckIn() -> () {
        Alamofire.request(Constants.Network.User.USER_CHECKIN, method: .post, parameters: NetWorkUtils.createBaseParams(), encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            if NetWorkUtils.checkReponse(response: response) {
                self.checkInBtn.isEnabled = false
                let json = JSON(response.result.value!)
                Constants.User.checkDays = json["data"]["checkedDays"].intValue
                Constants.User.todayChecked = true
                
                if Constants.User.checkDays > 8 {
                    
                }else{
                    self.initCheckIn7DayView()
                }
            }
        }
    }
    
}


















