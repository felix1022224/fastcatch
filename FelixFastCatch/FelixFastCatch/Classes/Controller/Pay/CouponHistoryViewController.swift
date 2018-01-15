//
//  CouponHistoryViewController.swift
//  FelixFastCatch
//
//  Created by 卢凡 on 2018/1/4.
//  Copyright © 2018年 felix. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire

/// 历史优惠券
class CouponHistoryViewController: UIViewController {

    /// 历史优惠券列表
    var historyCouponList:UITableView = UITableView()
    
    // 返回按钮
    fileprivate lazy var backBtn = UIButton(type: UIButtonType.custom)
    
    // 数据
    fileprivate var dataSource:[JSON] = [JSON]()
    
    fileprivate var helpDialog:HelpDialog!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        helpDialog = HelpDialog(frame: UIScreen.main.bounds)
        
        setupUI()
    }
    
    func setupUI() {
        setBackgroundImage(rootView: self.view, imgName: "邮寄背景")
        
        let titleImage = UIImageView(image: UIImage(named: "历史优惠券标题"))
        titleImage.sizeToFit()
        view.addSubview(titleImage)
        
        titleImage.snp.makeConstraints { (make) in
            make.top.equalTo(view).offset(UIApplication.shared.statusBarFrame.height)
            make.centerX.equalTo(view)
            make.width.equalTo(Constants.UI.TITLE_IMAGE_WIDTH)
            make.height.equalTo(Constants.UI.TITLE_IMAGE_HEIGHT)
        }
        
        backBtn.setImage(UIImage(named: "邮寄返回"), for: .normal)
        backBtn.sizeToFit()
        view.addSubview(backBtn)
        
        backBtn.snp.makeConstraints { (make) in
            make.centerY.equalTo(titleImage)
            make.left.equalTo(view).offset(14)
        }
        
        backBtn.addTarget(self, action: #selector(closeView), for: .touchUpInside)
        
        /// 问号
        let customerServiceBtn = UIButton(type: UIButtonType.custom)
        customerServiceBtn.setImage(UIImage(named: "优惠券问号"), for: .normal)
        customerServiceBtn.sizeToFit()
        view.addSubview(customerServiceBtn)
        
        customerServiceBtn.addTarget(self, action: #selector(showHelpDialog), for: .touchUpInside)
        
        customerServiceBtn.snp.makeConstraints { (make) in
            make.centerY.equalTo(titleImage)
            make.right.equalTo(view).offset(-14)
        }
        
        createHistoryCouponList(titleImage: titleImage)
    }
    
    @objc func showHelpDialog(){
        helpDialog.createViewByLink(link: Constants.Network.COUPON_HELP_H5_LINK)
        helpDialog.show()
    }
    
    @objc func closeView(){
        self.navigationController?.popViewController(animated: true)
    }
    
    /// 创建历史优惠券列表
    func createHistoryCouponList(titleImage:UIImageView) {
        historyCouponList.backgroundColor = UIColor.clear
        historyCouponList.separatorColor = UIColor.clear
        historyCouponList.delegate = self
        historyCouponList.dataSource = self
        historyCouponList.rowHeight = (UIScreen.main.bounds.width - 30) * 0.28
        historyCouponList.register(CouponHistoryTableViewCell.self, forCellReuseIdentifier: "cellId")
        view.addSubview(historyCouponList)
        
        historyCouponList.frame = CGRect(x: 15, y: Constants.UI.TITLE_IMAGE_HEIGHT + UIApplication.shared.statusBarFrame.height + 10, width: UIScreen.main.bounds.width - 30, height: UIScreen.main.bounds.height - (Constants.UI.TITLE_IMAGE_HEIGHT + UIApplication.shared.statusBarFrame.height + 10))
        
        getCouponListData()
    }

}

/// 优惠券列表
extension CouponHistoryViewController:UITableViewDelegate , UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath) as? CouponHistoryTableViewCell
        
        if dataSource[indexPath.row]["status"].intValue == 2 {
            // 已使用
            cell?.backgroundImage.image = UIImage(named: "优惠券已使用item")?.stretchableImage(withLeftCapWidth: 0, topCapHeight: 0)
        }else if dataSource[indexPath.row]["status"].intValue == 3 {
            // 已过期
            cell?.backgroundImage.image = UIImage(named: "优惠券已过期item")?.stretchableImage(withLeftCapWidth: 0, topCapHeight: 0)
        }
        
        cell?.couponTitle.text = dataSource[indexPath.row]["name"].stringValue
        let date = Date(timeIntervalSince1970: TimeInterval(dataSource[indexPath.row]["expireTime"].intValue/1000))
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "yyyy-MM-dd HH:mm"
        cell?.couponTime.text = "有效期至: " + dateFormat.string(from: date)
        cell?.couponInfo.text = dataSource[indexPath.row]["description"].stringValue
        cell?.discount.text = dataSource[indexPath.row]["discount"].stringValue + "折"
        
        cell?.updateDiscount()
        
        return cell!
    }
    
}

// MARK: - 获取优惠券列表
extension CouponHistoryViewController{
    
    func getCouponListData() {
        ToastUtils.showLoadingToast(msg: "获取优惠券列表")
        
        var params = NetWorkUtils.createBaseParams()
        params["status"] = "1"
        
        Alamofire.request(Constants.Network.User.GET_USER_COUPON_LIST, method: HTTPMethod.post, parameters: params).responseJSON { (dataResponse) in
            if NetWorkUtils.checkReponse(response: dataResponse) {
                let jsonResult = JSON(data: dataResponse.data!)
                
                if jsonResult["data"].arrayValue.count > 0 {
                    self.dataSource.removeAll()
                    self.dataSource = jsonResult["data"].arrayValue
                    self.historyCouponList.reloadData()
                    ToastUtils.hide()
                }else{
                    ToastUtils.showInfoToast(msg: "暂无数据")
                }
            }else{
                ToastUtils.showInfoToast(msg: "暂无数据")
            }
        }
    }
    
}



