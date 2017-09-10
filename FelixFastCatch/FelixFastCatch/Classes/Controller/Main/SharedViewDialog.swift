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
    
    override func createView() {
        
        rootView = UIView(frame: CGRect(x: 0, y: self.bounds.height, width: self.bounds.width, height: 100))
        rootView.backgroundColor = UIColor.white
        addSubview(rootView)
    
        sharedWechatSession = UIButton(type: .custom)
        sharedWechatSession.setImage(UIImage(named: "shared_wechat_session"), for: .normal)
        sharedWechatSession.sizeToFit()
        rootView.addSubview(sharedWechatSession)
        
        sharedWechatSession.snp.makeConstraints { (make) in
            make.width.equalTo(UIScreen.main.bounds.width/8)
            make.height.equalTo(UIScreen.main.bounds.width/8)
            make.left.equalTo(rootView).offset(15)
            make.centerY.equalTo(rootView)
        }
        
        sharedWechatSession.addTarget(self, action: #selector(sharedClick(sender:)), for: .touchUpInside)
        
        sharedWechatTimeLine = UIButton(type: .custom)
        sharedWechatTimeLine.setImage(UIImage(named: "shared_wechat_timeline"), for: .normal)
        sharedWechatTimeLine.sizeToFit()
        rootView.addSubview(sharedWechatTimeLine)
        
        sharedWechatTimeLine.snp.makeConstraints { (make) in
            make.width.equalTo(UIScreen.main.bounds.width/8)
            make.height.equalTo(UIScreen.main.bounds.width/8)
            make.left.equalTo(sharedWechatSession).offset(UIScreen.main.bounds.width/8 + 15)
            make.centerY.equalTo(rootView)
        }
        
        sharedWechatTimeLine.addTarget(self, action: #selector(sharedClick(sender:)), for: .touchUpInside)
        
        addDialogToWindow()
    }
    
    func sharedClick(sender:UIButton) -> () {
        if sender == sharedWechatSession {
            WeChatShared.shareURL(scheme, title: "免费抓娃娃啦，快来领游戏币！", description: "明星和网红们疯狂在抓的互联网实景娃娃机来啦！免费送钻快来抓！", thumbImg: UIImage(named: "shared_logo"), to: LDWechatScene.Session) { (isSuccess, info) in
                    if isSuccess {
                        ToastUtils.showSuccessToast(msg: "分享成功")
                    }else{
                        ToastUtils.showErrorToast(msg: "分享失败")
                    }
            }
        }else{
            WeChatShared.shareURL(scheme, title: "免费抓娃娃啦，快来领游戏币！", description: "明星和网红们疯狂在抓的互联网实景娃娃机来啦！免费送钻快来抓！", thumbImg: UIImage(named: "shared_logo"), to: LDWechatScene.Timeline) { (isSuccess, info) in
                if isSuccess {
                    ToastUtils.showSuccessToast(msg: "分享成功")
                }else{
                    ToastUtils.showErrorToast(msg: "分享失败")
                }
            }
        }
    }
    
    override func show() {
        UIView.animate(withDuration: 0.6) { [weak self] in
            self?.shadow.alpha = 0.5
            self?.isHidden = false
            self?.rootView.frame.origin.y = UIScreen.main.bounds.height - 100
        }
    }
    
    override func hide() {
        super.hide()
        rootView.removeFromSuperview()
        rootView = nil
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        hide()
    }

}
