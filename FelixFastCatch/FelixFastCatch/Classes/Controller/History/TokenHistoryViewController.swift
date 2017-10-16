//
//  TokenHistoryViewController.swift
//  FelixFastCatch
//
//  Created by 卢凡 on 2017/10/10.
//  Copyright © 2017年 felix. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

/// 代币记录的view
class TokenHistoryViewController: UIViewController {

    // 返回按钮
    fileprivate lazy var backBtn = UIButton(type: UIButtonType.custom)
    
    // 游戏记录列表
    fileprivate lazy var tokenHistoryList = UITableView()
    
    // 游戏记录的数据
    fileprivate lazy var tokenHistoryDataSource = [JSON]()
    
    // 联系客服的弹窗
    fileprivate var customerServiceDialog:CustomerServiceInfoDialog!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        createBtnsAndBackground()
        
        customerServiceDialog = CustomerServiceInfoDialog(frame: UIScreen.main.bounds)
        
        // Do any additional setup after loading the view.
    }

    /// 创建顶部的图标和背景图
    func createBtnsAndBackground() -> () {
        let gameHistoryBackground = UIImageView(image: UIImage(named: "邮寄背景"))
        gameHistoryBackground.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        view.addSubview(gameHistoryBackground)
        
        /// 标题
//        let tokenHisoryTitleImage = UIView()
//        tokenHisoryTitleImage.backgroundColor = UIColor(patternImage:  UIImage(named: "代币记录顶部")!)
//        tokenHisoryTitleImage.frame.size = CGSize(width: 220, height: 50)
//        view.addSubview(tokenHisoryTitleImage)
        
        let tokenHisoryTitleImage = UIImageView(image: UIImage(named: "代币记录顶部"))
//        tokenHisoryTitleImage.frame.size = CGSize(width: 200, height: 40)
        tokenHisoryTitleImage.sizeToFit()
        view.addSubview(tokenHisoryTitleImage)
        
        tokenHisoryTitleImage.snp.makeConstraints { (make) in
            make.top.equalTo(view).offset(UIApplication.shared.statusBarFrame.height + 5)
            make.centerX.equalTo(view)
            make.width.equalTo(200)
            make.height.equalTo(50)
        }
        
        backBtn.setImage(UIImage(named: "邮寄返回"), for: .normal)
        backBtn.sizeToFit()
//        backBtn.frame = CGRect(x: 14, y: UIApplication.shared.statusBarFrame.height + 10, width: backBtn.bounds.width, height: backBtn.bounds.height)
        view.addSubview(backBtn)
        
        backBtn.snp.makeConstraints { (make) in
            make.left.equalTo(view).offset(14)
            make.centerY.equalTo(tokenHisoryTitleImage)
        }
        
        backBtn.addTarget(self, action: #selector(closeView), for: .touchUpInside)
        
        /// 客服
        let customerServiceBtn = UIButton(type: UIButtonType.custom)
        customerServiceBtn.setImage(UIImage(named: "代币记录客服"), for: .normal)
        customerServiceBtn.sizeToFit()
        view.addSubview(customerServiceBtn)
        
        customerServiceBtn.addTarget(self, action: #selector(showCSDialog), for: .touchUpInside)
        
        customerServiceBtn.snp.makeConstraints { (make) in
            make.centerY.equalTo(tokenHisoryTitleImage)
            make.right.equalTo(view).offset(-14)
        }
        
        createGameHistoryList(titleImage: tokenHisoryTitleImage)
        
    }
    
    @objc func showCSDialog(){
        customerServiceDialog.createView()
        customerServiceDialog.show()
    }
    
    /// 关掉当前页面
    @objc func closeView() -> () {
        self.navigationController?.popViewController(animated: true)
    }
    
}

// MARK: - 代币记录列表
extension TokenHistoryViewController: UITableViewDelegate, UITableViewDataSource{
    
    /// 创建游戏记录列表
    func createGameHistoryList(titleImage:UIView) -> () {
        let itemImage = UIImage(named: "游戏记录背景框")
        
        tokenHistoryList.backgroundColor = UIColor.clear
        tokenHistoryList.separatorColor = UIColor.clear
//        tokenHistoryList.showsVerticalScrollIndicator = false
        tokenHistoryList.delegate = self
        tokenHistoryList.dataSource = self
        tokenHistoryList.register(TokenHistoryCell.self, forCellReuseIdentifier: "cellId")
        view.addSubview(tokenHistoryList)
        
        tokenHistoryList.snp.makeConstraints { (make) in
            make.top.equalTo(titleImage).offset(10 + titleImage.bounds.height)
            make.centerX.equalTo(view)
            make.bottom.equalTo(view)
            make.width.equalTo(UIScreen.main.bounds.width * 0.98)
        }
        
        getTokenHistoryList()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tokenHistoryDataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath) as? TokenHistoryCell
        
        let item = self.tokenHistoryDataSource[indexPath.row]
        
        cell?.tokenChangeLabel.text = item["mp"].stringValue + " " + item["diamonds"].stringValue + "币"
        cell?.tokenChangeTime.text = item["createTime"].stringValue
        cell?.tokenChangeTitle.text = item["typeName"].stringValue
        
        switch item["type"].intValue {
        case 0:
            cell?.actionImage.image = UIImage(named: "代币记录游戏图标")
            break
        case 1:
            cell?.actionImage.image = UIImage(named: "代币记录支付宝图标")
            break
        case 2:
            cell?.actionImage.image = UIImage(named: "代币记录微信图标")
            break
        case 4:
            cell?.actionImage.image = UIImage(named: "代币记录兑换码图标")
            break
        case 5:
            cell?.actionImage.image = UIImage(named: "代币记录邀请好友图标")
            break
        case 6:
            cell?.actionImage.image = UIImage(named: "代币记录新手登录图标")
            break
        case 7:
            cell?.actionImage.image = UIImage(named: "代币记录分享图标")
            break
        case 8:
            cell?.actionImage.image = UIImage(named: "代币记录签到图标")
            break
        case 9:
            cell?.actionImage.image = UIImage(named: "代币记录送币图标")
            break
        case 10:
            cell?.actionImage.image = UIImage(named: "代币记录退币图标")
            break
        case 11:
            cell?.actionImage.image = UIImage(named: "代币记录邮费图标")
            break
        default:
            break
        }
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let itemImage = UIImage(named: "代币记录背景框")
        return (UIScreen.main.bounds.width * 0.98) * 0.3
    }
}

// MARK: - 从服务器获取代币记录
extension TokenHistoryViewController{
    
    /// 获取代币记录list
    func getTokenHistoryList() -> () {
        var params = NetWorkUtils.createBaseParams()
        params["page"] = "0"
        params["size"] = "10000"
        
        ToastUtils.showLoadingToast(msg: "请稍后……")
        
        Alamofire.request(Constants.Network.User.GET_TOKEN_HISTORY, method: .post, parameters: params).responseJSON { (dataResponse) in
            ToastUtils.hide()
            if NetWorkUtils.checkReponse(response: dataResponse) {
                let resultJson = JSON(data: dataResponse.data!)
                if let resultArray = resultJson["data"]["content"].array {
                    self.tokenHistoryDataSource = self.tokenHistoryDataSource + resultArray
                }
                self.tokenHistoryList.reloadData()
            }
        }
    }
    
}




