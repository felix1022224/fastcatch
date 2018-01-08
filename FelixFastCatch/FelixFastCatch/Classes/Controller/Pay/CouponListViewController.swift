//
//  CouponListViewController.swift
//  FelixFastCatch
//
//  Created by 卢凡 on 2018/1/4.
//  Copyright © 2018年 felix. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire

/// 优惠券列表
class CouponListViewController: UIViewController {

    /// 是否来选择优惠券
    var isSelectCoupon:Bool = false
    
    /// 优惠券列表
    var couponList:UITableView = UITableView()
    
    // 返回按钮
    fileprivate lazy var backBtn = UIButton(type: UIButtonType.custom)
    
    // 查看历史优惠券
    var viewHistoryCouponListLabel:MainCustomerLabel = MainCustomerLabel()
    
    // 数据
    fileprivate var dataSource:[JSON] = [JSON]()
    
    fileprivate var helpDialog:HelpDialog!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        helpDialog = HelpDialog(frame: UIScreen.main.bounds)
        
        setupUI()
    }
    
    ///  装载UI
    func setupUI() {
        setBackgroundImage(rootView: self.view, imgName: "邮寄背景")
        
        let titleImage = UIImageView(image: UIImage(named: "优惠券标题"))
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
        
        createCouponList(titleImage: titleImage)
    }
    
    @objc func showHelpDialog(){
        helpDialog.createViewByLink(link: Constants.Network.COUPON_HELP_H5_LINK)
        helpDialog.show()
    }
    
    @objc func closeView(){
        self.navigationController?.popViewController(animated: true)
    }

    /// 创建优惠券列表
    func createCouponList(titleImage:UIImageView) {
        couponList.backgroundColor = UIColor.clear
        couponList.separatorColor = UIColor.clear
        couponList.delegate = self
        couponList.dataSource = self
        couponList.rowHeight = (UIScreen.main.bounds.width - 30) * 0.28
        couponList.register(CouponTableViewCell.self, forCellReuseIdentifier: "cellId")
        view.addSubview(couponList)
        
        viewHistoryCouponListLabel.font = UIFont.getCustomeYuanTiFont(fontSize: 16)
        viewHistoryCouponListLabel.outLienTextColor = Constants.UI.OUT_LINE_COLOR
        viewHistoryCouponListLabel.outLineWidth = Constants.UI.OUT_LINE_WIDTH
        viewHistoryCouponListLabel.outTextColor = UIColor.white
        viewHistoryCouponListLabel.text = "查看历史优惠券 > "
        viewHistoryCouponListLabel.sizeToFit()
        view.addSubview(viewHistoryCouponListLabel)
        
        viewHistoryCouponListLabel.center.x = UIScreen.main.bounds.width/2
        viewHistoryCouponListLabel.frame.origin.y = UIScreen.main.bounds.height - viewHistoryCouponListLabel.bounds.height - 30
        
        viewHistoryCouponListLabel.isUserInteractionEnabled = true
        let tapGR = UITapGestureRecognizer(target: self, action: #selector(viewHistoryCouponList))
        viewHistoryCouponListLabel.addGestureRecognizer(tapGR)
        
        couponList.frame = CGRect(x: 15, y: Constants.UI.TITLE_IMAGE_HEIGHT + UIApplication.shared.statusBarFrame.height + 10, width: UIScreen.main.bounds.width - 30, height: UIScreen.main.bounds.height - (Constants.UI.TITLE_IMAGE_HEIGHT + UIApplication.shared.statusBarFrame.height + 10) - viewHistoryCouponListLabel.bounds.height - 40)
        
        getCouponListData()
    }
    
    @objc func viewHistoryCouponList(){
        self.navigationController?.pushViewController(CouponHistoryViewController(), animated: true)
    }
}

/// 优惠券列表
extension CouponListViewController:UITableViewDelegate , UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath) as? CouponTableViewCell
        
        cell?.couponTitle.text = dataSource[indexPath.row]["name"].stringValue
        let date = Date(timeIntervalSince1970: TimeInterval(dataSource[indexPath.row]["expireTime"].intValue/1000))
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "yyyy-MM-dd hh:ss"
        cell?.couponTime.text = "有效期至: " + dateFormat.string(from: date)
        cell?.couponInfo.text = dataSource[indexPath.row]["description"].stringValue
        cell?.discount.text = dataSource[indexPath.row]["discount"].stringValue + "折"
        
        cell?.updateDiscount()
        
        return cell!
    }
    
}

// MARK: - 获取优惠券列表
extension CouponListViewController{
    
    func getCouponListData() {
        ToastUtils.showLoadingToast(msg: "获取优惠券列表")
        
        var params = NetWorkUtils.createBaseParams()
        params["status"] = "0"
        
        Alamofire.request(Constants.Network.User.GET_USER_COUPON_LIST, method: HTTPMethod.post, parameters: params).responseJSON { (dataResponse) in
            if NetWorkUtils.checkReponse(response: dataResponse) {
                let jsonResult = JSON(data: dataResponse.data!)
                
                if jsonResult["data"].arrayValue.count > 0 {
                    self.dataSource.removeAll()
                    self.dataSource = jsonResult["data"].arrayValue
                    self.couponList.reloadData()
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






