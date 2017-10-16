//
//  InviteListDialog.swift
//  FelixFastCatch
//
//  Created by 卢凡 on 2017/8/13.
//  Copyright © 2017年 felix. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class InviteListDialog: BaseDialog {

    /// 好友列表
    var firendsList:UITableView!
    
    /// 数据列表
    var dataSource = [JSON]()
    
    /// 已邀请的人数
    lazy var inviteMember:MainCustomerLabel = MainCustomerLabel()
    
    /// 获取到的代币数量
    lazy var inviteGemNumber:MainCustomerLabel = MainCustomerLabel()
    
    /// 没有数据的view
    var noValueView:UIView!
    
    override func createView() {
        createBackgroundImage(imageName: "好友背景")
        
        backgroundImage.frame.size = CGSize(width: 290, height: 400)
        backgroundImage.center = self.center
        
        createCloseBtn()
        
        firendsList = UITableView()
        firendsList.backgroundColor = UIColor.clear
        firendsList.delegate = self
        firendsList.dataSource = self
        firendsList.separatorColor = UIColor.clear
        firendsList.showsVerticalScrollIndicator = false
        firendsList.register(InviteFirendsCell.self, forCellReuseIdentifier: "cellId")
        addSubview(firendsList)
        
        inviteMember.outLineWidth = Constants.UI.OUT_LINE_WIDTH
        inviteMember.outTextColor = UIColor.white
        inviteMember.outLienTextColor = Constants.UI.OUT_LINE_COLOR
        inviteMember.font = UIFont(name: "FZY4K--GBK1-0", size: CGFloat(12))
        inviteMember.text = "已邀请0人"
        inviteMember.sizeToFit()
        addSubview(inviteMember)
        
        inviteMember.snp.makeConstraints { (make) in
            make.left.equalTo(backgroundImage).offset(20)
            make.top.equalTo(backgroundImage).offset(60)
        }
        
        inviteGemNumber.outLineWidth = Constants.UI.OUT_LINE_WIDTH
        inviteGemNumber.outTextColor = UIColor.white
        inviteGemNumber.outLienTextColor = Constants.UI.OUT_LINE_COLOR
        inviteGemNumber.font = UIFont(name: "FZY4K--GBK1-0", size: CGFloat(12))
        inviteGemNumber.text = "共获得0代币"
        inviteGemNumber.sizeToFit()
        addSubview(inviteGemNumber)
        
        inviteGemNumber.snp.makeConstraints { (make) in
            make.right.equalTo(backgroundImage).offset(-20)
            make.centerY.equalTo(inviteMember)
        }
        
        firendsList.snp.makeConstraints { (make) in
            make.width.equalTo((UIImage(named: "内容块")?.size.width)!)
            make.centerX.equalTo(backgroundImage)
            make.top.equalTo(backgroundImage).offset(60 + inviteMember.bounds.height + 10)
            make.bottom.equalTo(backgroundImage).offset(-25)
        }
        
        noValueView = UIView()
        noValueView.frame.size = firendsList.frame.size
        addSubview(noValueView)
        
        noValueView.backgroundColor = UIColor.red
        
        let noValueImage = UIImageView(image: UIImage(named: "没好友"))
        noValueImage.sizeToFit()
        noValueView.addSubview(noValueImage)
        
        noValueImage.center = noValueView.center
        
        noValueView.isHidden = false
        firendsList.isHidden = true
        
        noValueView.center = backgroundImage.center
        
        getInviteListData()
        
        addDialogToWindow()
    }
}

extension InviteListDialog:UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath) as? InviteFirendsCell
        
        let itemData = dataSource[indexPath.row]
        
        cell?.userFaceImage.kf.setImage(with: URL(string: itemData["avatar"].stringValue), placeholder: UIImage(named: "default_user_face"), options: nil, progressBlock: nil, completionHandler: nil)
        
        cell?.userName.text = itemData["nick"].stringValue
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let contentImage = UIImage(named: "内容块")
        return (contentImage?.size.height)! + 10
    }
}

// MARK: - 获取数据
extension InviteListDialog{

    func getInviteListData() -> () {
        var params = NetWorkUtils.createBaseParams()
        params["size"] = "100"
        params["page"] = "0"
        
        Alamofire.request(Constants.Network.User.GET_INVITE_LIST, method: .post, parameters: params).responseJSON { (response) in
            if NetWorkUtils.checkReponse(response: response) {
                let json = JSON(data: response.data!)
                self.dataSource = json["data"]["content"].arrayValue
                self.firendsList.reloadData()
                self.inviteMember.text = "已邀请" + String(self.dataSource.count) + "人"
                self.inviteGemNumber.text = "共获得" + String(self.dataSource.count * 25) + "代币"
                
                if self.dataSource.count > 0 {
                    self.noValueView.isHidden = true
                    self.firendsList.isHidden = false
                }else{
                    self.noValueView.isHidden = false
                    self.firendsList.isHidden = true
                }
            }else{
                self.noValueView.isHidden = false
                self.firendsList.isHidden = true
            }
        }
    }
    
}





