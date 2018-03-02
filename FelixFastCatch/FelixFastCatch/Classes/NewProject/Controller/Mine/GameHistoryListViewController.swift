//
//  GameHistoryListViewController.swift
//  FelixFastCatch
//
//  Created by 卢凡 on 2018/1/31.
//  Copyright © 2018年 felix. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire

/// 游戏记录页面
class GameHistoryListViewController: BaseActionBarViewController, UITableViewDelegate, UITableViewDataSource {

    var gameHistoryList = UITableView()
    
    var gameHistoryDataSource = [JSON]()
    
    /// 没有数据的图片
    var noValueImage = UIImageView()
    
    /// 问题
    let exchangeButton = UIButton.init(type: UIButtonType.custom)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        actionTitleLabel.text = "游戏记录"
        
        gameHistoryList.rowHeight = 100
        gameHistoryList.separatorInset = UIEdgeInsets.init(top: 0, left: UIScreen.main.bounds.width * 0.05, bottom: 0, right: UIScreen.main.bounds.width * 0.05)
        gameHistoryList.separatorColor = UIColor.init(red: 245/255.0, green: 245/255.0, blue: 245/255.0, alpha: 1.0)
        gameHistoryList.delegate = self
        gameHistoryList.dataSource = self
        gameHistoryList.register(GameHistoryListTableViewCell.self, forCellReuseIdentifier: "cellId")
        gameHistoryList.frame.size = CGSize.init(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height - headView.bounds.height)
        gameHistoryList.frame.origin = CGPoint.init(x: 0, y: 5 + headView.bounds.height)
        gameHistoryList.tableFooterView = UIView.init(frame: CGRect.zero)
        view.addSubview(gameHistoryList)
        
        noValueImage.image = UIImage.init(named: "游戏记录空")
        noValueImage.sizeToFit()
        view.addSubview(noValueImage)
        
        noValueImage.center = view.center

        gameHistoryList.isHidden = true
        noValueImage.isHidden = false
        
        getGameHistoryList()
        
        exchangeButton.setBackgroundImage(UIImage.init(named: "订单疑问"), for: UIControlState.normal)
        exchangeButton.sizeToFit()
        headView.addSubview(exchangeButton)
        
        exchangeButton.frame.origin = CGPoint.init(x: UIScreen.main.bounds.width - exchangeButton.bounds.width - 15, y: backImageView.frame.origin.y + backImageView.bounds.height/2 - exchangeButton.bounds.height/2)
        
        exchangeButton.addTarget(self, action: #selector(showQADialog), for: UIControlEvents.touchUpInside)
    }
    
    /// 显示帮助的dialog
    @objc func showQADialog() {
        let gameQADialog = GameQADialog.init(frame: UIScreen.main.bounds)
        gameQADialog.createView()
        gameQADialog.show()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return gameHistoryDataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath) as! GameHistoryListTableViewCell
        
        let item = gameHistoryDataSource[indexPath.row]
        cell.productName.text = item["title"].stringValue
        cell.time.text = item["createTime"].stringValue
        if item["gStatus"].intValue == 2 {
            if item["isGiveRedPackets"].boolValue == true {
                /// 可以发红包
                cell.statusImage.image = UIImage.init(named: "已抓中印章")
            }else{
                /// 不可以发红包
                cell.statusImage.image = UIImage.init(named: "已抓中无红包")
            }
        }else{
            cell.statusImage.image = UIImage.init(named: "未抓中印章")
        }
        cell.statusImage.sizeToFit()
        cell.productImage.kf.setImage(with: URL(string: item["img"].stringValue + "&imageView2/1/w/200/h/200"))
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if gameHistoryDataSource[indexPath.row]["isGiveRedPackets"].boolValue == true {
            self.sendRedBag(no: gameHistoryDataSource[indexPath.row]["gTradeNo"].stringValue)
        }
    }
    
    /// 获取游戏记录
    func getGameHistoryList() -> () {
        var params = NetWorkUtils.createBaseParams()
        params["size"] = "10000"
        params["page"] = "0"
        
        ToastUtils.showLoadingToast(msg: "请稍后……")
        
        Alamofire.request(Constants.Network.User.GET_GAME_HISTORY, method: HTTPMethod.post, parameters: params)
            .responseJSON { (dataResponse) in
                ToastUtils.hide()
                if NetWorkUtils.checkReponse(response: dataResponse) {
                    let resultJson = JSON(data: dataResponse.data!)
                    
                    if let resultArray = resultJson["data"]["content"].array {
                        self.gameHistoryDataSource = self.gameHistoryDataSource + resultArray
                    }
                    self.gameHistoryList.reloadData()
                    
                    if self.gameHistoryDataSource.count <= 0 {
                        self.gameHistoryList.isHidden = true
                        self.noValueImage.isHidden = false
                    }else{
                        self.gameHistoryList.isHidden = false
                        self.noValueImage.isHidden = true
                    }
                }
        }
    }
    
    func sendRedBag(no:String) {
        ToastUtils.showLoadingToast(msg: "正在准备红包")
        var params = NetWorkUtils.createBaseParams()
        params["gTradeNo"] = no
        
        Alamofire.request(Constants.Network.User.SEND_RED_BAG, method: HTTPMethod.post, parameters: params).responseJSON { (dataResponse) in
            ToastUtils.hide()
            if NetWorkUtils.checkReponse(response: dataResponse) {
                let resultJson = JSON.init(data: dataResponse.data!)
                
                let shareDialog = SharedViewDialog(frame: UIScreen.main.bounds)
                shareDialog.createView()
                shareDialog.shareTitle = resultJson["data"]["title"].stringValue
                shareDialog.shareInfo = resultJson["data"]["desc"].stringValue
                shareDialog.thumbShareImage = resultJson["data"]["img"].stringValue
                shareDialog.scheme = resultJson["data"]["shareUrl"].stringValue
                shareDialog.show()
            }
        }
    }
    
}
