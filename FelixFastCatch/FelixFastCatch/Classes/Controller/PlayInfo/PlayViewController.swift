//
//  PlayViewController.swift
//  FelixFastCatch
//
//  Created by 卢凡 on 2017/7/26.
//  Copyright © 2017年 felix. All rights reserved.
//

import UIKit
import Alamofire

class PlayViewController: UIViewController {

    /// 设备id
    var deviceId:String = ""
    
    /// 背景view
    fileprivate lazy var backgroundView:UIView = UIView()
    
    /// 钻石背景
    fileprivate lazy var gemBackground:UIImageView = UIImageView()
    
    /// 钻石数量
    fileprivate lazy var gemLabel:MainCustomerLabel = MainCustomerLabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.navigationBar.isHidden = true
        
        view.backgroundColor = UIColor.white

        enter()
        
        setupUI()
    }

    deinit {
        out(deviceId: deviceId)
    }
    
}


// MARK: - 装载与游戏相关的控件
extension PlayViewController{
    
    /// 加载UI
    func setupUI() -> () {
        createBackground()
        
        createBtns()
    }
    
    /// 创建背景板
    func createBackground() -> () {
        backgroundView.backgroundColor = UIColor.lightGray
        backgroundView.frame = self.view.bounds
        view.addSubview(backgroundView)
    }
    
    /// 创建按钮的集合
    func createBtns() -> () {
        let backBtn = UIButton(type: .custom)
        backBtn.setImage(UIImage(named: "icon_back"), for: .normal)
        backBtn.sizeToFit()
        view.addSubview(backBtn)
        backBtn.addTarget(self, action: #selector(backBtnClick), for: .touchUpInside)
        
        backBtn.snp.makeConstraints { (make) in
            make.top.equalTo(UIApplication.shared.statusBarFrame.height + 5)
            make.left.equalTo(self.view).offset(10)
        }
        
        createGemBackground()
    }
    
    /// 创建钻石
    func createGemBackground() -> () {
        gemBackground.image = UIImage(named: "bg_gem_number")
        gemBackground.sizeToFit()
        view.addSubview(gemBackground)
        
        gemBackground.snp.makeConstraints { (make) in
            make.top.equalTo(self.view).offset(UIApplication.shared.statusBarFrame.height + 10)
            make.right.equalTo(self.view).offset(-10)
        }
        
        gemLabel.text = "99999"
        gemLabel.outLineWidth = 2
        gemLabel.outTextColor = UIColor.white
        gemLabel.outLienTextColor = UIColor.black
        gemLabel.font = UIFont.systemFont(ofSize: CGFloat(12))
        view.addSubview(gemLabel)
        
        gemLabel.snp.makeConstraints { (make) in
            make.right.equalTo(gemBackground).offset(-28)
            make.centerY.equalTo(gemBackground).offset(2)
        }
    }
    
    /// 关闭当前页面
    func backBtnClick() -> () {
        self.navigationController?.popViewController(animated: true)
    }
    
}

// MARK: - 进入和退出房间
extension PlayViewController{
    
    /// 进入房间
    fileprivate func enter(){
        var params = NetWorkUtils.createBaseParams()
        params["deviceid"] = deviceId
        
        Alamofire.request(Constants.Network.Machine.ENTER_WATCH, method: .post, parameters: params, encoding: URLEncoding.httpBody, headers: nil).responseJSON { (response) in
            if response.error == nil && response.data != nil {
                print("result_进入房间:\(response.result.value ?? "")")
            }
        }
        
    }
    
    /// 退出房间
    fileprivate func out(deviceId:String){
        var params = NetWorkUtils.createBaseParams()
        params["deviceid"] = deviceId
        Alamofire.request(Constants.Network.Machine.OUT_WATCH, method: .post, parameters: params).responseJSON { (response) in
            if response.error == nil && response.data != nil {
                print("result_退出房间:\(response.result.value ?? "")")
            }
        }
    }
    
}
