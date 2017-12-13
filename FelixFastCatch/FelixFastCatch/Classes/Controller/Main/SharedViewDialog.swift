//
//  SharedViewDialog.swift
//  FelixFastCatch
//
//  Created by 卢凡 on 2017/9/6.
//  Copyright © 2017年 felix. All rights reserved.
//

import UIKit

class SharedViewDialog: BaseDialog {

    fileprivate var rootView:UIView!
    
    fileprivate var sharedWechatSession:UIButton!
    fileprivate var sharedWechatTimeLine:UIButton!
    
    var scheme:String!
    
    var shareTitle:String! 
    
    var shareInfo:String!
    
    var thumbShareImage:String!
    
    override func createView() {
        
        rootView = UIView(frame: CGRect(x: 0, y: self.bounds.height, width: self.bounds.width, height: 181 + 55))
        rootView.backgroundColor = UIColor.white
        addSubview(rootView)
    
        let title = UILabel()
        title.text = " 分享 "
        title.font = UIFont.systemFont(ofSize: 20)
        title.sizeToFit()
        rootView.addSubview(title)
        
        title.snp.makeConstraints { (make) in
            make.top.equalTo(rootView).offset(20)
            make.centerX.equalTo(rootView)
        }
        
        ///微信好友
        sharedWechatSession = UIButton(type: .custom)
        sharedWechatSession.setBackgroundImage(UIImage(named: "shared_wechat_session"), for: .normal)
        sharedWechatSession.sizeToFit()
        rootView.addSubview(sharedWechatSession)
        
        sharedWechatSession.snp.makeConstraints { (make) in
            make.width.equalTo(UIScreen.main.bounds.width/8)
            make.height.equalTo(UIScreen.main.bounds.width/8)
            make.left.equalTo(rootView).offset(35)
            make.top.equalTo(title).offset(title.bounds.height + 30)
        }
        
        sharedWechatSession.addTarget(self, action: #selector(sharedClick(sender:)), for: .touchUpInside)
        
        let sessionLabel = UILabel()
        sessionLabel.font = UIFont.systemFont(ofSize: 14)
        sessionLabel.text = "好友"
        sessionLabel.sizeToFit()
        rootView.addSubview(sessionLabel)
        
        sessionLabel.snp.makeConstraints { (make) in
            make.centerX.equalTo(sharedWechatSession)
            make.top.equalTo(sharedWechatSession).offset(UIScreen.main.bounds.width/7.5 + 8)
        }
        
        ///微信朋友圈
        sharedWechatTimeLine = UIButton(type: .custom)
        sharedWechatTimeLine.setBackgroundImage(UIImage(named: "shared_wechat_timeline"), for: .normal)
        sharedWechatTimeLine.sizeToFit()
        rootView.addSubview(sharedWechatTimeLine)
        
        sharedWechatTimeLine.snp.makeConstraints { (make) in
            make.width.equalTo(UIScreen.main.bounds.width/8)
            make.height.equalTo(UIScreen.main.bounds.width/8)
            make.left.equalTo(sharedWechatSession).offset(UIScreen.main.bounds.width/8 + 35)
            make.top.equalTo(title).offset(title.bounds.height + 30)
        }
        
        sharedWechatTimeLine.addTarget(self, action: #selector(sharedClick(sender:)), for: .touchUpInside)
        
        let timeLienLabel = UILabel()
        timeLienLabel.font = UIFont.systemFont(ofSize: 14)
        timeLienLabel.text = "朋友圈"
        timeLienLabel.sizeToFit()
        rootView.addSubview(timeLienLabel)
        
        let line = UIView()
        line.backgroundColor = UIColor.lightGray
        line.frame = CGRect(x: 0, y: 180, width: UIScreen.main.bounds.width, height: 0.5)
        rootView.addSubview(line)
        
        timeLienLabel.snp.makeConstraints { (make) in
            make.centerX.equalTo(sharedWechatTimeLine)
            make.top.equalTo(sharedWechatTimeLine).offset(UIScreen.main.bounds.width/7.5 + 8)
        }
        
        let cancelButton = UIButton(type: UIButtonType.system)
        cancelButton.setTitle("取消", for: .normal)
        cancelButton.setTitleColor(UIColor.gray, for: .normal)
        cancelButton.frame = CGRect(x: 0, y: 181, width: UIScreen.main.bounds.width, height: 55)
        rootView.addSubview(cancelButton)
        
        cancelButton.addTarget(self, action: #selector(hide), for: .touchUpInside)
        
        addDialogToWindow()
    }
    
    @objc func sharedClick(sender:UIButton) -> () {
        ToastUtils.showLoadingToast(msg: "请稍后...")
        if sender == sharedWechatSession {
            if thumbShareImage == "" || thumbShareImage == nil {
                WeChatShared.shareURL(scheme, title: "免费抓娃娃啦，快来领游戏币！", description: "明星和网红们疯狂在抓的互联网实景娃娃机来啦！免费送钻快来抓！", thumbImg: UIImage(named: "shared_logo"), to: LDWechatScene.Session) { (isSuccess, info) in
                    if isSuccess {
                        ToastUtils.showSuccessToast(msg: "分享成功")
                    }else{
                        ToastUtils.showErrorToast(msg: "分享失败")
                    }
                }
            }else{
                getDataFromUrl(url: URL(string: thumbShareImage)!, completion: { [weak self] (data, response, error) in
                    if response != nil {
                        WeChatShared.shareURL((self?.scheme)!, title: self?.shareTitle, description: self?.shareInfo, thumbImg: UIImage(data: data!), to: LDWechatScene.Session) { (isSuccess, info) in
                            if isSuccess {
                                ToastUtils.showSuccessToast(msg: "分享成功")
                            }else{
                                ToastUtils.showErrorToast(msg: "分享失败")
                            }
                        }
                    }
                })
            }
        }else{
            if thumbShareImage == "" || thumbShareImage == nil {
                WeChatShared.shareURL(scheme, title: "免费抓娃娃啦，快来领游戏币！", description: "明星和网红们疯狂在抓的互联网实景娃娃机来啦！免费送钻快来抓！", thumbImg: UIImage(named: "shared_logo"), to: LDWechatScene.Timeline) { (isSuccess, info) in
                    if isSuccess {
                        ToastUtils.showSuccessToast(msg: "分享成功")
                    }else{
                        ToastUtils.showErrorToast(msg: "分享失败")
                    }
                }
            }else{
                getDataFromUrl(url: URL(string: thumbShareImage)!, completion: { [weak self] (data, response, error) in
                    if response != nil {
                        WeChatShared.shareURL((self?.scheme)!, title: self?.shareTitle, description: self?.shareInfo, thumbImg: UIImage(data: data!), to: LDWechatScene.Timeline) { (isSuccess, info) in
                            if isSuccess {
                                ToastUtils.showSuccessToast(msg: "分享成功")
                            }else{
                                ToastUtils.showErrorToast(msg: "分享失败")
                            }
                        }
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
    
    override func show() {
        UIView.animate(withDuration: 0.3) { [weak self] in
            self?.shadow.alpha = 0.5
            self?.isHidden = false
            self?.rootView.frame.origin.y = UIScreen.main.bounds.height - (181 + 55)
        }
    }
    
    override func hide() {
//        super.hide()
        UIView.animate(withDuration: 0.3, animations: {[weak self] in
            self?.shadow.alpha = 0.0
            self?.rootView.frame.origin.y = UIScreen.main.bounds.height + (181 + 55)
        }) { [weak self] (isHide) in
            self?.isHidden = true
            self?.shadow.removeFromSuperview()
            self?.removeFromSuperview()
            for subview in (self?.subviews)! {
                subview.removeFromSuperview()
            }
            self?.rootView.removeFromSuperview()
            self?.rootView = nil
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        hide()
    }

}
