//
//  ToastUtils.swift
//  FelixFastCatch
//
//  Created by 卢凡 on 2017/7/26.
//  Copyright © 2017年 felix. All rights reserved.
//

import UIKit
import SVProgressHUD

class ToastUtils: NSObject {
    
    /// 显示错误信息
    ///
    /// - Parameter msg: 错误信息
    class func showErrorToast(msg:String) {
        SVProgressHUD.dismiss()
        SVProgressHUD.showError(withStatus: msg)
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            SVProgressHUD.dismiss()
        }
    }
    
    
    /// 显示成功信息
    ///
    /// - Parameter msg: 成功信息
    class func showSuccessToast(msg:String) {
        SVProgressHUD.dismiss()
        SVProgressHUD.showSuccess(withStatus: msg)
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            SVProgressHUD.dismiss()
        }
    }
    
    
    /// 显示info
    ///
    /// - Parameter msg: info msg
    class func showInfoToast(msg:String) {
        SVProgressHUD.dismiss()
        SVProgressHUD.showInfo(withStatus: msg)
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            SVProgressHUD.dismiss()
        }
    }
    
}
