//
//  EditInviteCode.swift
//  FelixFastCatch
//
//  Created by 卢凡 on 2017/8/27.
//  Copyright © 2017年 felix. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class EditInviteCode: BaseDialog {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    private var editInviteCodeTextFiled:MainCustomerTextField!
    
    private var cancelBtn:UIButton!
    
    private var okBtn:UIButton!
    
    /// 错误的label
    private var errorLabel:MainCustomerLabel!
    
    /// 使用成功
    private var inviteSuccessDialog:InviteSuccessDialog!
    
    override func createView() {
        createBackgroundImage(imageName: "兑换码背景")
        
        backgroundImage.frame.size = CGSize(width: 290, height: 165)
        backgroundImage.center = self.center
        
//        createCloseBtn()
        
        cancelBtn = UIButton(type: .custom)
        cancelBtn.setImage(UIImage(named: "取消填写"), for: .normal)
        cancelBtn.sizeToFit()
        addSubview(cancelBtn)
        
        cancelBtn.addTarget(self, action: #selector(hide), for: .touchUpInside)
        
        cancelBtn.snp.makeConstraints { (make) in
            make.bottom.equalTo(backgroundImage).offset(cancelBtn.bounds.height/2)
            make.right.equalTo(backgroundImage).offset(-(backgroundImage.bounds.width/2 + cancelBtn.bounds.width/2))
        }
        
        okBtn = UIButton(type: .custom)
        okBtn.setImage(UIImage(named: "确认填写"), for: .normal)
        okBtn.sizeToFit()
        addSubview(okBtn)
        
        okBtn.snp.makeConstraints { (make) in
            make.bottom.equalTo(backgroundImage).offset(okBtn.bounds.height/2)
            make.left.equalTo(backgroundImage).offset(backgroundImage.bounds.width/2 + cancelBtn.bounds.width/2)
        }
        
        okBtn.addTarget(self, action: #selector(useInviteCode), for: .touchUpInside)
        
        editInviteCodeTextFiled = MainCustomerTextField()
        editInviteCodeTextFiled.outLineWidth = Constants.UI.OUT_LINE_WIDTH
        editInviteCodeTextFiled.outTextColor = UIColor.white
        editInviteCodeTextFiled.outLienTextColor = Constants.UI.OUT_LINE_COLOR
        editInviteCodeTextFiled.font = UIFont(name: "FZY4K--GBK1-0", size: CGFloat(12))
        editInviteCodeTextFiled.background = UIImage(named: "bg_username")!
        editInviteCodeTextFiled.frame.size = CGSize(width: backgroundImage.bounds.width * 0.8, height: 40)
        editInviteCodeTextFiled.center = backgroundImage.center
        editInviteCodeTextFiled.placeholder = "请输入邀请码"
        editInviteCodeTextFiled.textColor = UIColor.white
        addSubview(editInviteCodeTextFiled)
        
        errorLabel = MainCustomerLabel()
        errorLabel.outLineWidth = Constants.UI.OUT_LINE_WIDTH
        errorLabel.outTextColor = UIColor.white
        errorLabel.outLienTextColor = UIColor.red
        errorLabel.font = UIFont(name: "FZY4K--GBK1-0", size: CGFloat(12))
        errorLabel.text = "邀请码无效"
        errorLabel.sizeToFit()
        addSubview(errorLabel)
        
        errorLabel.isHidden = true
        
        errorLabel.snp.makeConstraints { (make) in
            make.left.equalTo(editInviteCodeTextFiled).offset(5)
            make.top.equalTo(editInviteCodeTextFiled).offset(editInviteCodeTextFiled.bounds.height + 5)
        }
        
        inviteSuccessDialog = InviteSuccessDialog(frame: UIScreen.main.bounds)
        
        addDialogToWindow()
    }
    
    func useInviteCode() -> () {
        if editInviteCodeTextFiled.text == Constants.User.USER_TAG {
            self.errorLabel.isHidden = false
            return
        }
        
        endEditing(true)
        
        ToastUtils.showLoadingToast(msg: "正在请求数据")
        
        var params = NetWorkUtils.createBaseParams()
        params["tag"] = editInviteCodeTextFiled.text
        
        Alamofire.request(Constants.Network.User.USER_INVITE, method: .post, parameters: params, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            if NetWorkUtils.checkReponse(response: response) {
                let resultJson = JSON(data: response.data!)
                if resultJson["data"]["errcode"].intValue == 0 {
                    self.errorLabel.isHidden = true
                    self.showInviteSuccessDialog()
                    ToastUtils.hide()
                    if self.mainvc != nil {
                        self.mainvc.getsUserInfo()
                    }
                    self.hide()
                }else{
                    ToastUtils.showErrorToast(msg: resultJson["data"]["errmsg"].stringValue)
                }
            }else{
                self.errorLabel.isHidden = false
            }
        }
    }
    
    private var mainvc:MainViewController!
    
    func show2(mainViewController:MainViewController) -> () {
        mainvc = mainViewController
        show()
    }
    
    override func hide() {
        super.hide()
        self.mainvc = nil
    }
    
    func showInviteSuccessDialog() -> () {
        hide()
        inviteSuccessDialog.createView()
        inviteSuccessDialog.show()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        endEditing(true)
    }

}











