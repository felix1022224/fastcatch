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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        actionTitleLabel.text = "游戏记录"
        
        gameHistoryList.rowHeight = 100
        gameHistoryList.separatorInset = UIEdgeInsets.init(top: 0, left: UIScreen.main.bounds.width * 0.05, bottom: 0, right: UIScreen.main.bounds.width * 0.05)
        gameHistoryList.delegate = self
        gameHistoryList.dataSource = self
        gameHistoryList.register(GameHistoryListTableViewCell.self, forCellReuseIdentifier: "cellId")
        gameHistoryList.frame.size = CGSize.init(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height - headView.bounds.height)
        gameHistoryList.frame.origin = CGPoint.init(x: 0, y: 5 + headView.bounds.height)
        gameHistoryList.tableFooterView = UIView.init(frame: CGRect.zero)
        view.addSubview(gameHistoryList)
        
        getGameHistoryList()
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
            cell.statusImage.image = UIImage.init(named: "已抓中印章")
        }else{
            cell.statusImage.image = UIImage.init(named: "未抓中印章")
        }
        cell.productImage.kf.setImage(with: URL(string: item["img"].stringValue))
        
        return cell
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
                }
        }
    }
    
}
