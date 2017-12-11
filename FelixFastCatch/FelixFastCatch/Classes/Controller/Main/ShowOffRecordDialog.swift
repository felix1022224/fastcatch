//
//  ShowOffRecordDialog.swift
//  FelixFastCatch
//
//  Created by 卢凡 on 2017/8/13.
//  Copyright © 2017年 felix. All rights reserved.
//

import UIKit

/// 炫耀战绩
class ShowOffRecordDialog: BaseDialog {

    /// 继续游戏的callback
    var confirmCallback:(()->())? = nil
    
    /// 不再继续游戏的callback
    var cancelCallback:(()->())? = nil
    
    /// 倒计时的文字
    var againGameTimeLabel:MainCustomerLabel = MainCustomerLabel()
    
    var isDurexTheme:Bool = false
    
    override func createView() {
        
        if isDurexTheme {
            createBackgroundImage(imageName: "杜蕾斯-游戏成功背景")
        }else{
            createBackgroundImage(imageName: "游戏成功背景")
        }
        
        backgroundImage.center = self.center
        
//        let gemIcon = UIImageView(image: UIImage(named: "战绩钻石"))
//        gemIcon.sizeToFit()
//        addSubview(gemIcon)
//        
//        gemIcon.snp.makeConstraints { (make) in
//            make.top.equalTo(backgroundImage).offset(65)
//            make.centerX.equalTo(backgroundImage)
//        }
//        
//        let sharedInfo = MainCustomerLabel()
//        sharedInfo.outLineWidth = Constants.UI.OUT_LINE_WIDTH
//        sharedInfo.outTextColor = UIColor.white
//        sharedInfo.outLienTextColor = Constants.UI.OUT_LINE_COLOR
//        sharedInfo.text = "和好友分享你的战绩"
//        sharedInfo.font = UIFont(name: "FZY4K--GBK1-0", size: CGFloat(14))
//        sharedInfo.textAlignment = .center
//        sharedInfo.lineBreakMode = NSLineBreakMode.byWordWrapping
//        sharedInfo.numberOfLines = 0
//        sharedInfo.sizeToFit()
//        addSubview(sharedInfo)
//        
//        sharedInfo.snp.makeConstraints { (make) in
//            make.top.equalTo(gemIcon).offset(gemIcon.bounds.height + 10)
//            make.centerX.equalTo(backgroundImage)
//        }
        
        let nowShardBtn = UIButton(type: .custom)
        nowShardBtn.setBackgroundImage(UIImage(named: "立即分享"), for: .normal)
        nowShardBtn.setBackgroundImage(UIImage(named: "立即分享点击"), for: .highlighted)
        addSubview(nowShardBtn)
        
        nowShardBtn.addTarget(self, action: #selector(shared), for: .touchUpInside)
        
        nowShardBtn.snp.makeConstraints { (make) in
            make.bottom.equalTo(backgroundImage).offset(-15)
            make.right.equalTo(backgroundImage).offset(-backgroundImage.bounds.width/2 - 8)
        }
        
        /// 关闭按钮
        let closeBtn = UIButton(type: UIButtonType.custom)
        addSubview(closeBtn)
        
        closeBtn.snp.makeConstraints { (make) in
            make.top.equalTo(backgroundImage)
            make.right.equalTo(backgroundImage)
            make.width.equalTo(50)
            make.height.equalTo(50)
        }
        
        closeBtn.addTarget(self, action: #selector(close), for: .touchUpInside)
        
        //继续游戏的按钮
        let againGameButton = UIButton(type: UIButtonType.custom)
        againGameButton.setBackgroundImage(UIImage(named: "再玩一次"), for: .normal)
        againGameButton.setBackgroundImage(UIImage(named: "再玩一次点击"), for: .highlighted)
        self.addSubview(againGameButton)
        
        againGameButton.snp.makeConstraints { (make) in
            make.left.equalTo(backgroundImage).offset(backgroundImage.bounds.width/2 + 8)
            make.bottom.equalTo(backgroundImage).offset(-15)
        }
        
        againGameTimeLabel.font = UIFont(name: "FZY4K--GBK1-0", size: CGFloat(14))
        againGameTimeLabel.outLineWidth = 3
        againGameTimeLabel.outTextColor = UIColor.white
        againGameTimeLabel.outLienTextColor = UIColor(red: 29/255.0, green: 137/255.0, blue: 0/255.0, alpha: 0.75)
        againGameTimeLabel.text = "15s"
        addSubview(againGameTimeLabel)
        
        againGameTimeLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(againGameButton).offset(-1)
            make.right.equalTo(againGameButton).offset(-14)
        }
        
        againGameButton.addTarget(self, action: #selector(againGame), for: .touchUpInside)
        
        //开始倒计时
        isCounting = true
        
        addDialogToWindow()
    }
    
    fileprivate var deviceId:String!
    
    func show2(deviceId:String) -> () {
        self.deviceId = deviceId
        show()
    }

    @objc func shared() -> () {
        if WeChatShared.isInstall() == false {
            ToastUtils.showErrorToast(msg: "暂时无法分享")
            return
        }
        ToastUtils.showLoadingToast(msg: "请稍后……")
        getDataFromUrl(url: URL(string: "http://meizhe.meidaojia.com/makeup/public/images/doll/" + deviceId + ".jpg")!) { (data, response, error) in
            if error == nil {
                WeChatShared.shareImage(data!, thumbImage: UIImage(named: "shared_logo"), title: "抓中啦", description: "抓到了", to: .Timeline, resuleHandle: { (isSuccess, info) in
                    if isSuccess {
                        ToastUtils.showSuccessToast(msg: "分享成功")
                        self.hide()
                    }else{
                        ToastUtils.showErrorToast(msg: " 分享失败")
                    }
                })
            }
        }
    }
    
    func getDataFromUrl(url: URL, completion: @escaping (_ data: Data?, _  response: URLResponse?, _ error: Error?) -> Void) {
        URLSession.shared.dataTask(with: url) {
            (data, response, error) in
            completion(data, response, error)
            }.resume()
    }
    
    /// 再来一局
    @objc func againGame() -> () {
        if confirmCallback != nil {
            confirmCallback!()
        }
        hide()
    }
    
    /// 游戏倒计时
    fileprivate var countdownTimer: Timer?
    
    fileprivate var remainingSeconds: Int = 0 {
        willSet {
            if newValue < 10 {
                againGameTimeLabel.text = "0\(newValue)s"
            }else {
                againGameTimeLabel.text = "\(newValue)s"
            }
            
            if newValue <= 0 {
                againGameTimeLabel.text = "15s"
                isCounting = false
                close()
            }
        }
    }
    
    var isCounting = false {
        willSet {
            if newValue {
                countdownTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.updateTime), userInfo: nil, repeats: true)
                remainingSeconds = 15
            } else {
                countdownTimer?.invalidate()
                countdownTimer = nil
            }
        }
    }
    
    @objc func updateTime() {
        remainingSeconds -= 1
    }
    
    /// 关闭
    @objc func close(){
        if cancelCallback != nil {
            cancelCallback!()
        }
        hide()
    }
    
    override func hide() {
        ToastUtils.hide()
        isCounting = false
        UIView.animate(withDuration: 0.3, animations: {[weak self] in
            self?.shadow.alpha = 0.0
            self?.transform = CGAffineTransform(scaleX: 0.6,y: 0.6)
            self?.alpha = 0.0
        }) { [weak self] (isHide) in
            self?.alpha = 1
            self?.isHidden = true
            self?.shadow.removeFromSuperview()
            self?.removeFromSuperview()
            for subview in (self?.subviews)! {
                subview.removeFromSuperview()
            }
        }
    }
    
}
