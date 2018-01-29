//
//  MineViewController.swift
//  FelixFastCatch
//
//  Created by 卢凡 on 2018/1/29.
//  Copyright © 2018年 felix. All rights reserved.
//

import UIKit

/// 我的页面
class MineViewController: UIViewController {

    /// 根布局
    private let rootView = UIScrollView()
    
    /// 用户头像
    let userAvater = UIImageView()
    
    /// 用户id
    let userIdLabel = UILabel()
    
    /// 用户昵称
    let userNameLabel = UILabel()
    
    /// 用户性别
    let userSex = UIImageView()
    
    /// 用户星座
    let userXingZuo = UILabel()
    
    private let statusHeight:CGFloat = UIDevice.current.isX() ? 44 : 20
    
    override func viewDidLoad() {
        super.viewDidLoad()

        rootView.backgroundColor = UIColor.white
        rootView.frame = CGRect.init(x: 0, y: -statusHeight, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height + statusHeight)
        view.addSubview(rootView)
        
        createTopInfo()
    }
    
    /// 创建顶部信息集合
    func createTopInfo() {
        let backgroundImage = UIImageView.init()
        backgroundImage.frame = CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height * 0.2)
        backgroundImage.image = UIImage.init(named: "我的背景")
        rootView.addSubview(backgroundImage)
        
        userAvater.frame.size = CGSize.init(width: 45, height: 45)
        userAvater.layer.cornerRadius = 5
        userAvater.layer.borderColor = UIColor.white.cgColor
        userAvater.layer.borderWidth = 2
        userAvater.layer.masksToBounds = true
        userAvater.frame.origin = CGPoint.init(x: UIScreen.main.bounds.width - userAvater.bounds.width - 30, y: UIScreen.main.bounds.height * 0.065)
        rootView.addSubview(userAvater)
        
        userAvater.kf.setImage(with: URL.init(string: Constants.User.USER_FACE_IMAGE))
        
        userIdLabel.font = UIFont.systemFont(ofSize: 12)
        userIdLabel.text = "ID:\(Constants.User.USER_ID)"
        userIdLabel.sizeToFit()
        rootView.addSubview(userIdLabel)
        
        userIdLabel.snp.makeConstraints { (make) in
            make.centerX.equalTo(userAvater)
            make.top.equalTo(userAvater).offset(userAvater.bounds.height + 5)
        }
        
        userNameLabel.font = UIFont.systemFont(ofSize: 20)
        userNameLabel.textColor = UIColor.white
        userNameLabel.text = Constants.User.USER_NICK_NAME
        userNameLabel.sizeToFit()
        rootView.addSubview(userNameLabel)
        
        userNameLabel.snp.makeConstraints { (make) in
            make.left.equalTo(rootView).offset(30)
            make.centerY.equalTo(userAvater)
            make.width.equalTo(UIScreen.main.bounds.width * 0.4)
        }
        
        if Constants.User.USER_SEX == "0" {
            userSex.image = UIImage.init(named: "性别男")?.tint(color: UIColor.white, blendMode: CGBlendMode.destinationIn)
        }else if Constants.User.USER_SEX == "-1"{
            userSex.image = UIImage.init(named: "性别男")?.tint(color: UIColor.white, blendMode: CGBlendMode.destinationIn)
        }else{
            userSex.image = UIImage.init(named: "性别女")?.tint(color: UIColor.white, blendMode: CGBlendMode.destinationIn)
        }
        userSex.sizeToFit()
        rootView.addSubview(userSex)
        
        userSex.snp.makeConstraints { (make) in
            make.left.equalTo(userNameLabel)
            make.top.equalTo(userNameLabel).offset(userNameLabel.bounds.height + 5)
        }
        
        /// 星座
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd"
        let con = ConstellationUtils.calculateWithDate(date: df.date(from: Constants.User.USER_BRITHDAY)!)
        userXingZuo.text = con
        userXingZuo.font = UIFont.systemFont(ofSize: 12)
        userXingZuo.sizeToFit()
        userXingZuo.textColor = UIColor.white
        rootView.addSubview(userXingZuo)
        
        userXingZuo.snp.makeConstraints { (make) in
            make.centerY.equalTo(userSex)
            make.left.equalTo(userSex).offset(userSex.bounds.width + 5)
        }
        
        /// 数量集合
        let numberGroupView = UIView()
        numberGroupView.layer.cornerRadius = 15
        numberGroupView.backgroundColor = UIColor.white
        rootView.addSubview(numberGroupView)
        
        numberGroupView.layer.shadowColor = UIColor.init(red: 226/255.0, green: 238/255.0, blue: 253/255.0, alpha: 1.0).cgColor
        numberGroupView.layer.shadowOpacity = 0.8
        numberGroupView.layer.shadowRadius = 5
        numberGroupView.layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
        
        numberGroupView.snp.makeConstraints { (make) in
            make.centerX.equalTo(rootView)
            make.top.equalTo(rootView).offset(rootView.bounds.height * 0.16)
            make.width.equalTo(UIScreen.main.bounds.width * 0.9)
            make.height.equalTo(60)
        }
        
        let goldNumber = UILabel()
        goldNumber.text = "代币\n\(Constants.User.diamondsCount)"
        goldNumber.font = UIFont.systemFont(ofSize: 14)
        goldNumber.numberOfLines = 2
        goldNumber.textAlignment = .center
        goldNumber.sizeToFit()
        numberGroupView.addSubview(goldNumber)
        
        goldNumber.snp.makeConstraints { (make) in
            make.left.equalTo(numberGroupView).offset(30)
            make.centerY.equalTo(numberGroupView)
        }
        
        let redNumber = UILabel()
        redNumber.text = "红包\n\(Constants.User.diamondsCount)"
        redNumber.font = UIFont.systemFont(ofSize: 14)
        redNumber.textAlignment = .center
        redNumber.numberOfLines = 2
        redNumber.sizeToFit()
        numberGroupView.addSubview(redNumber)
        
        redNumber.snp.makeConstraints { (make) in
            make.centerX.equalTo(numberGroupView)
            make.centerY.equalTo(numberGroupView)
        }
        
        let couponNumber = UILabel()
        couponNumber.text = "优惠券\n\(Constants.User.userCouponNumber)"
        couponNumber.font = UIFont.systemFont(ofSize: 14)
        couponNumber.textAlignment = .center
        couponNumber.numberOfLines = 2
        couponNumber.sizeToFit()
        numberGroupView.addSubview(couponNumber)
        
        couponNumber.snp.makeConstraints { (make) in
            make.right.equalTo(numberGroupView).offset(-30)
            make.centerY.equalTo(numberGroupView)
        }
        
        createListGroup()
    }
    
    /// 创建底部选项集合
    func createListGroup() {
        
        ///vip会员
        let vipGroup = UIView()
        vipGroup.frame = CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50)
        rootView.addSubview(vipGroup)
        
        let vipIcon = UIImageView()
        vipIcon.image = UIImage.init(named: "vip会员icon")
        vipIcon.sizeToFit()
        vipGroup.addSubview(vipIcon)
        
        vipIcon.snp.makeConstraints { (make) in
            make.centerY.equalTo(vipGroup)
            make.left.equalTo(vipGroup).offset(40)
        }
        
        let vipName = UILabel()
        vipName.text = "VIP会员"
        vipName.font = UIFont.systemFont(ofSize: 16)
        vipName.sizeToFit()
        vipGroup.addSubview(vipName)
        
        vipName.snp.makeConstraints { (make) in
            make.left.equalTo(vipGroup).offset(90)
            make.centerY.equalTo(vipIcon)
        }
        
        /// 不是vip的提示
        let notVipLabel = UILabel()
        notVipLabel.font = UIFont.systemFont(ofSize: 11)
        let attrText = NSMutableAttributedString.init(string: "开通会员，送480代币+充值9折特权")
        attrText.addAttribute(NSAttributedStringKey.foregroundColor, value: UIColor.red, range: NSRange(location: 6, length:10))
        notVipLabel.attributedText = attrText
        notVipLabel.sizeToFit()
        vipGroup.addSubview(notVipLabel)
        
        notVipLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(vipGroup)
            make.left.equalTo(vipName).offset(vipName.bounds.width + 10)
        }
        
        /// 续费按钮
        let renewFeeBtn = UIButton.init(type: .custom)
        renewFeeBtn.layer.cornerRadius = 10
        renewFeeBtn.layer.masksToBounds = true
        renewFeeBtn.layer.borderColor = UIColor.gray.cgColor
        renewFeeBtn.layer.borderWidth = 0.5
        renewFeeBtn.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        renewFeeBtn.backgroundColor = UIColor.white
        renewFeeBtn.titleLabel?.textColor = UIColor.black
        renewFeeBtn.setTitle("续费", for: UIControlState.normal)
        renewFeeBtn.setTitleColor(UIColor.black, for: UIControlState.normal)
        renewFeeBtn.frame = CGRect.init(x: UIScreen.main.bounds.width - 120, y: vipGroup.bounds.height/2 - 10, width: 40, height: 20)
        vipGroup.addSubview(renewFeeBtn)
        
        let arrowIcon = UIImageView()
        arrowIcon.image = UIImage.init(named: "我的item箭头")
        arrowIcon.sizeToFit()
        vipGroup.addSubview(arrowIcon)
        
        arrowIcon.frame.origin = CGPoint.init(x: UIScreen.main.bounds.width - 40 - arrowIcon.bounds.width, y: vipGroup.bounds.height/2 - arrowIcon.bounds.height/2)
        
        vipGroup.frame.origin = CGPoint.init(x: 0, y: UIScreen.main.bounds.height * 0.3)
        
        /// 邀请
        let inviteGroupView = UIView()
        inviteGroupView.frame = CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50)
        rootView.addSubview(inviteGroupView)
        
        let inviteIcon = UIImageView()
        inviteIcon.image = UIImage.init(named: "我的邀请")
        inviteIcon.sizeToFit()
        inviteGroupView.addSubview(inviteIcon)
        
        inviteIcon.snp.makeConstraints { (make) in
            make.centerY.equalTo(inviteGroupView)
            make.left.equalTo(inviteGroupView).offset(40)
        }
        
        let inviteName = UILabel()
        inviteName.text = "邀请奖励"
        inviteName.font = UIFont.systemFont(ofSize: 16)
        inviteName.sizeToFit()
        inviteGroupView.addSubview(inviteName)
        
        inviteName.snp.makeConstraints { (make) in
            make.left.equalTo(inviteGroupView).offset(90)
            make.centerY.equalTo(inviteIcon)
        }
        
        let inviteArrowIcon = UIImageView()
        inviteArrowIcon.image = UIImage.init(named: "我的item箭头")
        inviteArrowIcon.sizeToFit()
        inviteGroupView.addSubview(inviteArrowIcon)
        
        inviteArrowIcon.frame.origin = CGPoint.init(x: UIScreen.main.bounds.width - 40 - arrowIcon.bounds.width, y: inviteGroupView.bounds.height/2 - arrowIcon.bounds.height/2)
        
        inviteGroupView.frame.origin = CGPoint.init(x: 0, y: vipGroup.frame.origin.y + 10 + 50 * 1)
        
        /// 我的成就
        let achievementGroupView = UIView()
        achievementGroupView.frame = CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50)
        rootView.addSubview(achievementGroupView)
        
        let achievementIcon = UIImageView()
        achievementIcon.image = UIImage.init(named: "我的成就")
        achievementIcon.sizeToFit()
        inviteGroupView.addSubview(achievementIcon)
        
        achievementIcon.snp.makeConstraints { (make) in
            make.centerY.equalTo(achievementGroupView)
            make.left.equalTo(achievementGroupView).offset(40)
        }
        
        let achievementName = UILabel()
        achievementName.text = "我的成就"
        achievementName.font = UIFont.systemFont(ofSize: 16)
        achievementName.sizeToFit()
        achievementGroupView.addSubview(achievementName)
        
        achievementName.snp.makeConstraints { (make) in
            make.left.equalTo(achievementGroupView).offset(90)
            make.centerY.equalTo(achievementIcon)
        }
        
        let achievementArrowIcon = UIImageView()
        achievementArrowIcon.image = UIImage.init(named: "我的item箭头")
        achievementArrowIcon.sizeToFit()
        achievementGroupView.addSubview(achievementArrowIcon)
        
        achievementArrowIcon.frame.origin = CGPoint.init(x: UIScreen.main.bounds.width - 40 - arrowIcon.bounds.width, y: achievementGroupView.bounds.height/2 - arrowIcon.bounds.height/2)
        
        achievementGroupView.frame.origin = CGPoint.init(x: 0, y: vipGroup.frame.origin.y + 10*2 + 50 * 2)
        
        /// 我的消息
        let messageGroupView = UIView()
        messageGroupView.frame = CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50)
        rootView.addSubview(messageGroupView)
        
        let messageIcon = UIImageView()
        messageIcon.image = UIImage.init(named: "我的消息")
        messageIcon.sizeToFit()
        messageGroupView.addSubview(messageIcon)
        
        messageIcon.snp.makeConstraints { (make) in
            make.centerY.equalTo(messageGroupView)
            make.left.equalTo(messageGroupView).offset(40)
        }
        
        let messageName = UILabel()
        messageName.text = "我的消息"
        messageName.font = UIFont.systemFont(ofSize: 16)
        messageName.sizeToFit()
        messageGroupView.addSubview(messageName)
        
        messageName.snp.makeConstraints { (make) in
            make.left.equalTo(messageGroupView).offset(90)
            make.centerY.equalTo(messageIcon)
        }
        
        let messageArrowIcon = UIImageView()
        messageArrowIcon.image = UIImage.init(named: "我的item箭头")
        messageArrowIcon.sizeToFit()
        messageGroupView.addSubview(messageArrowIcon)
        
        messageArrowIcon.frame.origin = CGPoint.init(x: UIScreen.main.bounds.width - 40 - arrowIcon.bounds.width, y: messageGroupView.bounds.height/2 - arrowIcon.bounds.height/2)
        
        messageGroupView.frame.origin = CGPoint.init(x: 0, y: vipGroup.frame.origin.y + 10*3 + 50 * 3)
        
        /// 游戏记录
        let gameHistoryGroupView = UIView()
        gameHistoryGroupView.frame = CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50)
        rootView.addSubview(gameHistoryGroupView)
        
        let gameHistoryIcon = UIImageView()
        gameHistoryIcon.image = UIImage.init(named: "我的游戏记录")
        gameHistoryIcon.sizeToFit()
        gameHistoryGroupView.addSubview(gameHistoryIcon)
        
        gameHistoryIcon.snp.makeConstraints { (make) in
            make.centerY.equalTo(gameHistoryGroupView)
            make.left.equalTo(gameHistoryGroupView).offset(40)
        }
        
        let gameHistoryName = UILabel()
        gameHistoryName.text = "游戏记录"
        gameHistoryName.font = UIFont.systemFont(ofSize: 16)
        gameHistoryName.sizeToFit()
        gameHistoryGroupView.addSubview(gameHistoryName)
        
        gameHistoryName.snp.makeConstraints { (make) in
            make.left.equalTo(gameHistoryGroupView).offset(90)
            make.centerY.equalTo(gameHistoryIcon)
        }
        
        let gameHistoryArrowIcon = UIImageView()
        gameHistoryArrowIcon.image = UIImage.init(named: "我的item箭头")
        gameHistoryArrowIcon.sizeToFit()
        gameHistoryGroupView.addSubview(gameHistoryArrowIcon)
        
        gameHistoryArrowIcon.frame.origin = CGPoint.init(x: UIScreen.main.bounds.width - 40 - arrowIcon.bounds.width, y: gameHistoryGroupView.bounds.height/2 - arrowIcon.bounds.height/2)
        
        gameHistoryGroupView.frame.origin = CGPoint.init(x: 0, y: vipGroup.frame.origin.y + 10*4 + 50 * 4)
        
        
        /// 设置
        let settingsGroupView = UIView()
        settingsGroupView.frame = CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50)
        rootView.addSubview(settingsGroupView)
        
        let settingsIcon = UIImageView()
        settingsIcon.image = UIImage.init(named: "我的设置")
        settingsIcon.sizeToFit()
        settingsGroupView.addSubview(settingsIcon)
        
        settingsIcon.snp.makeConstraints { (make) in
            make.centerY.equalTo(settingsGroupView)
            make.left.equalTo(settingsGroupView).offset(40)
        }
        
        let settingsName = UILabel()
        settingsName.text = "设置"
        settingsName.font = UIFont.systemFont(ofSize: 16)
        settingsName.sizeToFit()
        settingsGroupView.addSubview(settingsName)
        
        settingsName.snp.makeConstraints { (make) in
            make.left.equalTo(settingsGroupView).offset(90)
            make.centerY.equalTo(settingsIcon)
        }
        
        let settingsArrowIcon = UIImageView()
        settingsArrowIcon.image = UIImage.init(named: "我的item箭头")
        settingsArrowIcon.sizeToFit()
        settingsGroupView.addSubview(settingsArrowIcon)
        
        settingsArrowIcon.frame.origin = CGPoint.init(x: UIScreen.main.bounds.width - 40 - arrowIcon.bounds.width, y: settingsGroupView.bounds.height/2 - arrowIcon.bounds.height/2)
        
        settingsGroupView.frame.origin = CGPoint.init(x: 0, y: vipGroup.frame.origin.y + 10*5 + 50 * 5)
        
        
    }

}

extension UIImage
{
    func tint(color: UIColor, blendMode: CGBlendMode) -> UIImage
    {
        let drawRect = CGRect.init(x: 0.0, y: 0.0, width: size.width, height: size.height)
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        //let context = UIGraphicsGetCurrentContext()
        //CGContextClipToMask(context, drawRect, CGImage)
        color.setFill()
        UIRectFill(drawRect)
        draw(in: drawRect, blendMode: blendMode, alpha: 1.0)
        let tintedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return tintedImage!
    }
}
