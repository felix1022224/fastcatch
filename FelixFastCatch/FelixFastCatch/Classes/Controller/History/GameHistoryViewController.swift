//
//  GameHistoryViewController.swift
//  FelixFastCatch
//
//  Created by 卢凡 on 2017/10/10.
//  Copyright © 2017年 felix. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

/// 游戏记录
class GameHistoryViewController: UIViewController {

    // 返回按钮
    fileprivate lazy var backBtn = UIButton(type: UIButtonType.custom)
    
    // 游戏记录列表
    fileprivate lazy var gameHistoryList = UITableView()
    
    // 游戏记录的数据
    fileprivate var gameHistoryDataSource = [JSON]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        createBtnsAndBackground()
        
    }

    /// 创建顶部的图标和背景图
    func createBtnsAndBackground() -> () {
        let gameHistoryBackground = UIImageView(image: UIImage(named: "邮寄背景"))
        gameHistoryBackground.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        view.addSubview(gameHistoryBackground)
        
        let gameHisoryTitleImage = UIImageView(image: UIImage(named: "游戏记录顶部"))
        gameHisoryTitleImage.sizeToFit()
        view.addSubview(gameHisoryTitleImage)
        
        gameHisoryTitleImage.snp.makeConstraints { (make) in
            make.top.equalTo(view).offset(UIApplication.shared.statusBarFrame.height + 5)
            make.centerX.equalTo(view)
        }
        
        backBtn.setImage(UIImage(named: "邮寄返回"), for: .normal)
        backBtn.sizeToFit()
//        backBtn.frame = CGRect(x: 14, y: UIApplication.shared.statusBarFrame.height + 10, width: backBtn.bounds.width, height: backBtn.bounds.height)
        view.addSubview(backBtn)
        
        backBtn.snp.makeConstraints { (make) in
            make.centerY.equalTo(gameHisoryTitleImage)
            make.left.equalTo(view).offset(14)
        }
        
        backBtn.addTarget(self, action: #selector(closeView), for: .touchUpInside)
        
        
        
        createGameHistoryList(titilImage: gameHisoryTitleImage)
        
    }
    
    /// 关掉当前页面
    @objc func closeView() -> () {
        self.navigationController?.popViewController(animated: true)
    }

}

// MARK: - 游戏记录列表
extension GameHistoryViewController: UITableViewDelegate, UITableViewDataSource{
    
    /// 创建游戏记录列表
    func createGameHistoryList(titilImage:UIImageView) -> () {
        let itemImage = UIImage(named: "游戏记录背景框")
        
        gameHistoryList.backgroundColor = UIColor.clear
        gameHistoryList.separatorColor = UIColor.clear
        gameHistoryList.showsVerticalScrollIndicator = false
        gameHistoryList.delegate = self
        gameHistoryList.dataSource = self
        gameHistoryList.register(GameHistoryCell.self, forCellReuseIdentifier: "cellId")
        view.addSubview(gameHistoryList)
        
        gameHistoryList.snp.makeConstraints { (make) in
            make.top.equalTo(titilImage).offset(10 + titilImage.bounds.height)
            make.centerX.equalTo(view)
            make.bottom.equalTo(view)
            make.width.equalTo((itemImage?.size.width)!)
        }
        
        getGameHistoryList()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return gameHistoryDataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath) as? GameHistoryCell
        
        let item = gameHistoryDataSource[indexPath.row]
        
        cell?.productTitleLabel.text = item["title"].stringValue
        cell?.productTimeLabel.text = item["createTime"].stringValue
        
        cell?.changeGameStatus(gameStatus: item["gStatus"].intValue)
        
        cell?.productImage.kf.setImage(with: URL(string: item["img"].stringValue))
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let itemImage = UIImage(named: "游戏记录背景框")
        return (itemImage?.size.height)! + 10
    }
}

// MARK: - 获取游戏记录
extension GameHistoryViewController{
    
    /// 获取游戏记录
    func getGameHistoryList() -> () {
        var params = NetWorkUtils.createBaseParams()
        params["size"] = "1000"
        params["page"] = "0"
        
        ToastUtils.showLoadingToast(msg: "请稍后……")
        
        Alamofire.request(Constants.Network.User.GET_GAME_HISTORY, method: HTTPMethod.post, parameters: params).responseJSON { (dataResponse) in
//            print("GameHistoryList:\(dataResponse.result.value!)")
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





