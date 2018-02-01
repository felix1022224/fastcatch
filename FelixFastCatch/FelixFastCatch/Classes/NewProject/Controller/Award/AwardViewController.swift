//
//  AwardViewController.swift
//  FelixFastCatch
//
//  Created by 卢凡 on 2018/1/30.
//  Copyright © 2018年 felix. All rights reserved.
//

import UIKit
import SwiftyJSON

/// 奖品
class AwardViewController: UIViewController {

    private let statusHeight:CGFloat = UIDevice.current.isX() ? 44 : 20
    
    /// 用户未领取奖品数量
    let userAwardNumberLabel = UILabel()
    
    let centerGroupView = UIView()
    
    let bottomGroupView = UIView.init()
    
    /// tab 滚动的view
    let tabScrollView = UIScrollView()
    
    let notTakeTabButton = UIButton.init(type: UIButtonType.custom)
    let takeTabButton = UIButton.init(type: UIButtonType.custom)
    let changeTabButton = UIButton.init(type: UIButtonType.custom)
    
    /// 未邮寄列表
    let notTakeList = UITableView()
    
    /// 未提取数据
    var notTakeDataSources = [JSON]()
    
    /// 未提取列表的选择状态
    var notTakeSelectedStatus = [Int:Bool]()
    
    /// 已选择的个数
    var selectedNumber = UILabel()
    
    var takeList = UITableView()
    
    /// 已邮寄列表
    var takeListDelegate:TakeListDelegate!
    
    let pointLine = UIView()
    
    var changeList = UITableView()
    var changeListDelegate:ChangeListDelegate!
    
    // 免邮次数
    var freePostageNumber = 0
    
    // 需要支付的邮费
    var postageCashNumber = 0
    
    /// 确认兑换的弹窗
    var exchangeDialog:ConfirmExchangeDialog!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let backgroundImage = UIImageView.init()
        backgroundImage.frame = CGRect.init(x: 0, y: -statusHeight, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height * 0.25)
        backgroundImage.image = UIImage.init(named: "我的背景")
        view.addSubview(backgroundImage)
        
        userAwardNumberLabel.textColor = UIColor.white
        userAwardNumberLabel.font = UIFont.systemFont(ofSize: 18)
        userAwardNumberLabel.text = "我四只小兔几，未提取奖品16件"
        userAwardNumberLabel.sizeToFit()
        userAwardNumberLabel.frame.origin = CGPoint.init(x: 20, y: UIApplication.shared.statusBarFrame.height + 25)
        view.addSubview(userAwardNumberLabel)
        
        centerGroupView.backgroundColor = UIColor.white
        centerGroupView.frame = CGRect.init(x: UIScreen.main.bounds.width * 0.05, y: UIScreen.main.bounds.height * 0.12, width: UIScreen.main.bounds.width * 0.9, height: UIScreen.main.bounds.height * 0.88 - MainTabsViewController.tabHeight)
        view.addSubview(centerGroupView)
        
        centerGroupView.layer.cornerRadius = 20
        
        centerGroupView.layer.shadowColor = UIColor.init(red: 226/255.0, green: 238/255.0, blue: 253/255.0, alpha: 1.0).cgColor
        centerGroupView.layer.shadowOpacity = 1.0
        centerGroupView.layer.shadowRadius = 20
        centerGroupView.layer.shadowOffset = CGSize(width: 0.5, height: 0.5)
        
        
        createTabScrollView()
    }

    /// 创建顶部滚动的tab
    func createTabScrollView() {
        tabScrollView.frame.size = CGSize.init(width: UIScreen.main.bounds.width * 0.8, height: 40)
        tabScrollView.frame.origin = CGPoint.init(x: centerGroupView.bounds.width/2 - tabScrollView.bounds.width/2, y: 0)
        centerGroupView.addSubview(tabScrollView)
        
        let grayLineView = UIView()
        grayLineView.frame = CGRect.init(x: centerGroupView.bounds.width * 0.05, y: 42, width: centerGroupView.bounds.width * 0.9, height: 0.5)
        grayLineView.backgroundColor = UIColor.lightGray
        centerGroupView.addSubview(grayLineView)
        
        /// 未提取的按钮
        notTakeTabButton.setTitle("待提取", for: UIControlState.normal)
        notTakeTabButton.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        notTakeTabButton.setTitleColor(UIColor.gray, for: UIControlState.normal)
        notTakeTabButton.setTitleColor(UIColor.black, for: UIControlState.selected)
        notTakeTabButton.frame.size = CGSize.init(width: tabScrollView.bounds.width/3, height: 40)
        notTakeTabButton.frame.origin = CGPoint.init(x: 0, y: 0)
        tabScrollView.addSubview(notTakeTabButton)
        
        /// 未提取的按钮
        takeTabButton.setTitle("已提取", for: UIControlState.normal)
        takeTabButton.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        takeTabButton.setTitleColor(UIColor.gray, for: UIControlState.normal)
        takeTabButton.setTitleColor(UIColor.black, for: UIControlState.selected)
        takeTabButton.frame.size = CGSize.init(width: tabScrollView.bounds.width/3, height: 40)
        takeTabButton.frame.origin = CGPoint.init(x: notTakeTabButton.bounds.width, y: 0)
        tabScrollView.addSubview(takeTabButton)
        
        /// 未提取的按钮
        changeTabButton.setTitle("已兑换", for: UIControlState.normal)
        changeTabButton.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        changeTabButton.setTitleColor(UIColor.gray, for: UIControlState.normal)
        changeTabButton.setTitleColor(UIColor.black, for: UIControlState.selected)
        changeTabButton.frame.size = CGSize.init(width: tabScrollView.bounds.width/3, height: 40)
        changeTabButton.frame.origin = CGPoint.init(x: notTakeTabButton.bounds.width * 2, y: 0)
        tabScrollView.addSubview(changeTabButton)
        
        pointLine.frame.size = CGSize.init(width: changeTabButton.bounds.width * 0.3, height: 1.5)
        pointLine.backgroundColor = UIColor.orange
        pointLine.frame.origin = CGPoint.init(x: notTakeTabButton.bounds.width/2 - pointLine.bounds.width/2, y: 32)
        tabScrollView.addSubview(pointLine)
        
        notTakeTabButton.addTarget(self, action: #selector(tabItemClick(sender:)), for: UIControlEvents.touchUpInside)
        takeTabButton.addTarget(self, action: #selector(tabItemClick(sender:)), for: UIControlEvents.touchUpInside)
        changeTabButton.addTarget(self, action: #selector(tabItemClick(sender:)), for: UIControlEvents.touchUpInside)
        
        createNotTakeList()
        
        createTakeList()
        createChangeList()
        
        createSendGroup()
        
        notTakeList.isHidden = false
        takeList.isHidden = true
        changeList.isHidden = true
        
        notTakeTabButton.isSelected = true
        takeTabButton.isSelected = false
        changeTabButton.isSelected = false
        
        bottomGroupView.isHidden = false
    }
    
    @objc func tabItemClick(sender:UIButton) {
        if sender == notTakeTabButton {
            notTakeList.isHidden = false
            takeList.isHidden = true
            changeList.isHidden = true
            
            notTakeTabButton.isSelected = true
            takeTabButton.isSelected = false
            changeTabButton.isSelected = false
            
            bottomGroupView.isHidden = false
            
            UIView.animate(withDuration: 0.3, animations: {[weak self] in
                self?.pointLine.frame.origin.x = (self?.notTakeTabButton.bounds.width)!/2 - (self?.pointLine.bounds.width)!/2
            })
        }else if sender == takeTabButton {
            notTakeList.isHidden = true
            takeList.isHidden = false
            changeList.isHidden = true
            
            notTakeTabButton.isSelected = false
            takeTabButton.isSelected = true
            changeTabButton.isSelected = false
            
            bottomGroupView.isHidden = true
            
            let x = self.notTakeTabButton.bounds.width/2 - self.pointLine.bounds.width/2
            UIView.animate(withDuration: 0.3, animations: {[weak self] in
                self?.pointLine.frame.origin.x = x + (self?.notTakeTabButton.bounds.width)!
            })
            
        }else{
            notTakeList.isHidden = true
            takeList.isHidden = true
            changeList.isHidden = false
            
            notTakeTabButton.isSelected = false
            takeTabButton.isSelected = false
            changeTabButton.isSelected = true
            
            bottomGroupView.isHidden = true
            
            let x = self.notTakeTabButton.bounds.width/2 - self.pointLine.bounds.width/2
            UIView.animate(withDuration: 0.3, animations: {[weak self] in
                self?.pointLine.frame.origin.x = x + (self?.notTakeTabButton.bounds.width)! * 2
            })
            
        }
    }
    
    /// 创建底部view
    func createSendGroup() {
        bottomGroupView.backgroundColor = UIColor.white
        view.addSubview(bottomGroupView)
        
        bottomGroupView.layer.shadowColor = UIColor.init(red: 0/255.0, green: 0/255.0, blue: 0/255.0, alpha: 1.0).cgColor
        bottomGroupView.layer.shadowOpacity = 1.0
        bottomGroupView.layer.shadowRadius = 0
        bottomGroupView.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        
        bottomGroupView.frame = CGRect.init(x: 0, y: UIScreen.main.bounds.height - MainTabsViewController.tabHeight - 45, width: UIScreen.main.bounds.width, height: 45)
        
        selectedNumber.font = UIFont.systemFont(ofSize: 14)
        selectedNumber.text = "已选择0个"
        selectedNumber.sizeToFit()
        selectedNumber.frame.origin = CGPoint.init(x: 10, y: 45/2 - selectedNumber.bounds.height/2)
        bottomGroupView.addSubview(selectedNumber)
        
        let takeButton = UIButton.init(type: UIButtonType.custom)
        takeButton.frame.size = CGSize.init(width: UIScreen.main.bounds.width * 0.3, height: 45)
        takeButton.setBackgroundImage(UIImage.init(named: "申请提取"), for: UIControlState.normal)
        takeButton.frame.origin = CGPoint.init(x: UIScreen.main.bounds.width - takeButton.bounds.width, y: 0)
        bottomGroupView.addSubview(takeButton)
        
        let changeCountButton = UIButton.init(type: UIButtonType.custom)
        changeCountButton.frame.size = CGSize.init(width: UIScreen.main.bounds.width * 0.3, height: 45)
        changeCountButton.setBackgroundImage(UIImage.init(named: "兑换积分"), for: UIControlState.normal)
        changeCountButton.frame.origin = CGPoint.init(x: UIScreen.main.bounds.width - takeButton.bounds.width - changeCountButton.bounds.width, y: 0)
        bottomGroupView.addSubview(changeCountButton)
        
        takeButton.addTarget(self, action: #selector(mailed), for: UIControlEvents.touchUpInside)
        changeCountButton.addTarget(self, action: #selector(change), for: UIControlEvents.touchUpInside)
    }
    
    /// 申请提取的按钮
    @objc func mailed(){
        var awardType0 = false
        var awardType1 = false
        for key in Array(notTakeSelectedStatus.keys) {
            if notTakeSelectedStatus[key] == true {
                if notTakeDataSources[key]["awardType"].intValue == 0 {
                    awardType0 = true
                }
                if notTakeDataSources[key]["awardType"].intValue == 1 {
                    awardType1 = true
                }
            }
        }
        
        if awardType0 && awardType1 {
            ToastUtils.showErrorToast(msg: "虚拟奖品与实物奖品无法同时发货,请重新选择")
            return
        }
        
        var sendData = [JSON]()
        for key in Array(notTakeSelectedStatus.keys) {
            if notTakeSelectedStatus[key] == true {
                sendData.append(notTakeDataSources[key])
            }
        }
        
        if sendData.count <= 0 {
            ToastUtils.showErrorToast(msg: "请选择要提取的奖品")
            return
        }
        
        let takeViewController = TakeViewController()
        takeViewController.sendData = sendData
        takeViewController.isOnline = awardType1
        
        takeViewController.freePostageNumber = freePostageNumber
        takeViewController.postageCashNumber = postageCashNumber
        
        takeViewController.mailedCallback = {[weak self] in
            self?.notTakeList.isHidden = true
            self?.takeList.isHidden = false
            self?.changeList.isHidden = true
            
            self?.notTakeTabButton.isSelected = false
            self?.takeTabButton.isSelected = true
            self?.changeTabButton.isSelected = false
            
            self?.bottomGroupView.isHidden = true
            
            let x = (self?.notTakeTabButton.bounds.width)!/2 - (self?.pointLine.bounds.width)!/2
            UIView.animate(withDuration: 0.3, animations: {[weak self] in
                self?.pointLine.frame.origin.x = x + (self?.notTakeTabButton.bounds.width)!
            })
            
            self?.getNotTakeListDataSource()
            self?.getTakeList()
        }
        
        self.navigationController?.pushViewController(takeViewController, animated: true)
    }
    
    /// 兑换积分的按钮
    @objc func change(){
        var sendData = [JSON]()
        for key in Array(notTakeSelectedStatus.keys) {
            if notTakeSelectedStatus[key] == true {
                sendData.append(notTakeDataSources[key])
            }
        }
        
        if sendData.count <= 0 {
            ToastUtils.showErrorToast(msg: "请选择要兑换的奖品")
            return
        }
        
        exchangeDialog = ConfirmExchangeDialog(frame: UIScreen.main.bounds)
        
        exchangeDialog.exchangeData = sendData
        exchangeDialog.exchangeSuccessCallback = {[weak self] in
            self?.notTakeList.isHidden = true
            self?.takeList.isHidden = true
            self?.changeList.isHidden = false
            
            self?.notTakeTabButton.isSelected = false
            self?.takeTabButton.isSelected = false
            self?.changeTabButton.isSelected = true
            
            self?.bottomGroupView.isHidden = true
            
            /// 刷新列表
            self?.getChangeListData()
            self?.getNotTakeListDataSource()
            
            let x = (self?.notTakeTabButton.bounds.width)!/2 - (self?.pointLine.bounds.width)!/2
            UIView.animate(withDuration: 0.3, animations: {[weak self] in
                self?.pointLine.frame.origin.x = x + (self?.notTakeTabButton.bounds.width)! * 2
            })
        }
        exchangeDialog.createView()
        exchangeDialog.show()
        
    }
    
}
