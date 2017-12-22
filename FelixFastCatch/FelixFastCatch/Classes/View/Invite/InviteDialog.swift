//
//  InviteDialog.swift
//  FelixFastCatch
//
//  Created by 卢凡 on 2017/8/7.
//  Copyright © 2017年 felix. All rights reserved.
//

import UIKit

class InviteDialog: BaseDialog {

    /// 填写邀请码的按钮
    fileprivate var editInviteCode:UIButton!
    
    /// 立即邀请码的按钮
    fileprivate var nowInvite:UIButton!
    
    /// 查看已邀请的好友
    fileprivate var lookInviteList:UIButton!
    
    /// 我的邀请码
    fileprivate var myInviteCode:MainCustomerLabel!
    
    /// 输入邀请码
    fileprivate var editInviteCodeDialog:EditInviteCode!
    
    /// 已邀请好友的列表
    fileprivate var inviteListDialog:InviteListDialog!
    
    /// 分享的view
    fileprivate var sharedView:SharedViewDialog!
    
    override func createView() {
        createBackgroundImage(imageName: "bg_invite")
        
        backgroundImage.frame.size = CGSize(width: 290, height: 400)
        backgroundImage.center = self.center

        createCloseBtn()
        
        sharedView = SharedViewDialog(frame: UIScreen.main.bounds)
        
        /// 顶部的钻石
        let gemIcon = UIImageView()
        gemIcon.image = UIImage(named: "invite_gem")
        gemIcon.frame.size = CGSize(width: 87, height: 75)
        addSubview(gemIcon)
        
        gemIcon.snp.makeConstraints { (make) in
            make.top.equalTo(backgroundImage).offset(65)
            make.centerX.equalTo(backgroundImage)
        }
        
        /// 邀请的奖励规则1
        let rule1 = MainCustomerLabel()
        rule1.outLineWidth = Constants.UI.OUT_LINE_WIDTH
        rule1.outTextColor = UIColor.white
        rule1.outLienTextColor = Constants.UI.OUT_LINE_COLOR
        rule1.textAlignment = .center
        rule1.text = "邀请新用户奖励25代币"
        rule1.font = UIFont.getCustomeYuanTiFont(fontSize: 12)
        rule1.sizeToFit()
        addSubview(rule1)
        
        rule1.frame.size = CGSize(width: backgroundImage.bounds.width - 10, height: rule1.bounds.height)
        rule1.snp.makeConstraints { (make) in
            make.top.equalTo(gemIcon).offset(gemIcon.bounds.height + 35)
            make.centerX.equalTo(backgroundImage)
        }
        
        /// 邀请的奖励规则2
        let rule2 = MainCustomerLabel()
        rule2.outLineWidth = Constants.UI.OUT_LINE_WIDTH
        rule2.outTextColor = UIColor.white
        rule2.outLienTextColor = Constants.UI.OUT_LINE_COLOR
        rule2.textAlignment = .center
        rule2.text = "邀满10个好友额外奖励100代币"
        rule2.font = UIFont.getCustomeYuanTiFont(fontSize: 12)
        rule2.sizeToFit()
        addSubview(rule2)
        
        rule2.frame.size = CGSize(width: backgroundImage.bounds.width - 20, height: rule2.bounds.height)
        rule2.snp.makeConstraints { (make) in
            make.top.equalTo(rule1).offset(rule1.bounds.height + 15)
            make.centerX.equalTo(backgroundImage)
        }
        
        /// 查看已邀请的好友
        lookInviteList = UIButton(type: .custom)
        lookInviteList.setImage(UIImage(named: "look_invite_list"), for: .normal)
        lookInviteList.frame.size = CGSize(width: 94, height: 26)
        addSubview(lookInviteList)
        
        lookInviteList.addTarget(self, action: #selector(showMyInviteDialog), for: .touchUpInside)
        
        lookInviteList.snp.makeConstraints { (make) in
            make.top.equalTo(rule2).offset(rule2.bounds.height + 20)
            make.centerX.equalTo(backgroundImage)
        }
        
        /// 我的邀请码
        myInviteCode = MainCustomerLabel()
        myInviteCode.outLineWidth = Constants.UI.OUT_LINE_WIDTH
        myInviteCode.outTextColor = UIColor.white
        myInviteCode.outLienTextColor = Constants.UI.OUT_LINE_COLOR
        myInviteCode.textAlignment = .center
        myInviteCode.text = "我的邀请码:" + Constants.User.USER_TAG
        myInviteCode.font = UIFont.getCustomeYuanTiFont(fontSize: 16)
        myInviteCode.setup()
        myInviteCode.sizeToFit()
        addSubview(myInviteCode)

        myInviteCode.frame.size = CGSize(width: backgroundImage.bounds.width - 20, height: myInviteCode.bounds.height)
        myInviteCode.snp.makeConstraints { (make) in
            make.centerX.equalTo(backgroundImage)
            make.top.equalTo(lookInviteList).offset(lookInviteList.bounds.height + 25)
        }
        
        createBtns()
        
        addDialogToWindow()
    }
 
    /// 创建按钮集合
    func createBtns() -> () {
        editInviteCode = UIButton(type: .custom)
        editInviteCode.setImage(UIImage(named: "edit_invite"), for: .normal)
        editInviteCode.frame.size = CGSize(width: 118, height: 34)
        addSubview(editInviteCode)
        
        editInviteCode.snp.makeConstraints { (make) in
            make.right.equalTo(backgroundImage).offset(-(backgroundImage.bounds.width/2 ))
            make.bottom.equalTo(backgroundImage).offset(editInviteCode.bounds.height/2)
        }
        
        editInviteCode.addTarget(self, action: #selector(showEditInviteCode), for: .touchUpInside)
        
        nowInvite = UIButton(type: .custom)
        nowInvite.setImage(UIImage(named: "now_invite"), for: .normal)
        nowInvite.frame.size = CGSize(width: 118, height: 34)
        addSubview(nowInvite)
        
        nowInvite.snp.makeConstraints { (make) in
            make.left.equalTo(backgroundImage).offset(backgroundImage.bounds.width/2 + 6.5)
            make.bottom.equalTo(backgroundImage).offset(nowInvite.bounds.height/2)
        }
        
        nowInvite.addTarget(self, action: #selector(showNowShared), for: .touchUpInside)
    }
    
    @objc func showEditInviteCode() -> () {
        if editInviteCodeDialog == nil {
            editInviteCodeDialog = EditInviteCode(frame: UIScreen.main.bounds)
        }
        editInviteCodeDialog.createView()
        editInviteCodeDialog.show2(mainViewController: self.mainController)
    }
    
    @objc func showMyInviteDialog() -> () {
        if inviteListDialog == nil {
            inviteListDialog = InviteListDialog(frame: UIScreen.main.bounds)
        }
        inviteListDialog.createView()
        inviteListDialog.show()
    }
    
    /// 立即分享
    @objc func showNowShared() -> () {
        if WeChatShared.isInstall() == false {
            ToastUtils.showErrorToast(msg: "无法分享")
            return
        }
        showSharedView()
//        WeChatShared.shareURL("https://meizhe.meidaojia.com/makeup/activity/activity_banner/view_8292?code=" + Constants.User.USER_TAG, title: "免费抓娃娃啦，快来领游戏币！", description: "今年最火爆的明星和网红疯狂在抓的互联网实景娃娃机！", thumbImg: UIImage(named: "shared_logo"), to: LDWechatScene.Timeline) { (isSuccess, desc) in
//            if isSuccess == true {
//                ToastUtils.showSuccessToast(msg: "分享成功")
//            }else{
//                ToastUtils.showErrorToast(msg: "分享失败")
//            }
//        }
    }
    
    func showSharedView() -> () {
        sharedView = SharedViewDialog(frame: UIScreen.main.bounds)
        sharedView.shareTitle = ""
        sharedView.scheme = "https://meizhe.meidaojia.com/makeup/activity/activity_banner/view_8292?code=" + Constants.User.USER_TAG
        sharedView.createView()
        sharedView.show()
    }
    
    private var mainController:MainViewController!
    
    func show2(mainController:MainViewController) -> () {
        self.mainController = mainController
        show()
    }
    
}
