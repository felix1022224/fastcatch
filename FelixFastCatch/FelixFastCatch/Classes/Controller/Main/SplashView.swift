//
//  SplashView.swift
//  aircleaner
//
//  Created by Kooze on 16/7/7.
//  Copyright © 2016年 purisen. All rights reserved.
//

import UIKit

class SplashView: UIView {
    
    // const
    static let IMG_URL = "splash_img_url"
    static let ACT_URL = "splash_act_url"
    static let IMG_PATH = String(format: "%@/Documents/splash_image.jpg", NSHomeDirectory())
    
    static let OPEN_ADV_SHARE_TITLE = "splash_share_title"
    static let OPEN_ADV_SHARE_INFO = "splash_share_info"
    static let OPEN_ADV_SHARE_THUMBIMAGE = "splash_thumbShareImage"
    
    static let OPEN_ADV_URL_TYPE = "open_adv_url_type"
    static let OPEN_ADV_URL_TITLE = "open_adv_url_title"
    
    // in portrait mode
    let screenWidth = UIScreen.main.bounds.size.width
    let screenHeight = UIScreen.main.bounds.size.height
    let statusHeight = UIApplication.shared.statusBarFrame.height
    
    let buttonSize: CGFloat = 36.0
    let buttonMargin: CGFloat = 16.0
    
    var durationTime: Int = 6 {
        didSet {
            skipButton?.setTitle("跳过\n\(durationTime) s", for: .normal)
        }
    }
    
    // data
    var imageUrl: String?
    var actionUrl: String?
    var timer: Timer?
    
    var tapSplashImageBlock: ((_ actionUrl: String?) -> Void)?
    var splashViewDissmissBlock: ((_ initiativeDismiss: Bool) -> Void)?
    
    // views
    var imageView: UIImageView?
    var skipButton: UIButton?
    
    init() {
        super.init(frame: CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight))
        initComponents()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // call this method at least in viewDidAppear func
    class func showSplashView(duration: Int = 6,
                              defaultImage: UIImage?,
                              tapSplashImageBlock: ((_ actionUrl: String?) -> Void)?,
                              splashViewDismissBlock: ((_ initiativeDismiss: Bool) -> Void)?) {
        if isExistsSplashData() {
            let splashView = SplashView()
            splashView.tapSplashImageBlock = tapSplashImageBlock
            splashView.splashViewDissmissBlock = splashViewDismissBlock
            splashView.durationTime = duration
            UIApplication.shared.delegate?.window!!.addSubview(splashView)
            
            MobClick.event("show_adv_number")
        }
//        else if let _defaultImage = defaultImage {
//            return
//            let splashView = SplashView()
//            splashView.tapSplashImageBlock = tapSplashImageBlock
//            splashView.splashViewDissmissBlock = splashViewDismissBlock
//            splashView.durationTime = duration
//            splashView.imageView?.image = _defaultImage
//            UIApplication.shared.delegate?.window!!.addSubview(splashView)
//        }
    }
    
    class func simpleShowSplashView() {
        showSplashView(defaultImage: nil, tapSplashImageBlock: nil, splashViewDismissBlock: nil)
    }
    
    func initComponents() {
        // init data
        imageUrl = UserDefaults.standard.value(forKey: SplashView.IMG_URL) as? String
        actionUrl = UserDefaults.standard.value(forKey: SplashView.ACT_URL) as? String
        
        // initViews
        self.backgroundColor = UIColor.white
        
        imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight))
        imageView?.isUserInteractionEnabled = true
        let recognize = UITapGestureRecognizer(target: self, action: #selector(tapImageAction))
        imageView?.addGestureRecognizer(recognize)
        imageView?.image = UIImage(contentsOfFile: SplashView.IMG_PATH)
        self.addSubview(imageView!)
        
        skipButton = UIButton(frame: CGRect(x: screenWidth - buttonSize - buttonMargin, y: buttonMargin + statusHeight, width: buttonSize, height: buttonSize))
        skipButton?.layer.cornerRadius = buttonSize / 2
        skipButton?.clipsToBounds = true
        skipButton?.backgroundColor = UIColor(red: 0.3, green: 0.3, blue: 0.3, alpha: 0.3)
        skipButton?.setTitleColor(UIColor.white, for: .normal)
        skipButton?.titleLabel?.font = UIFont.systemFont(ofSize: 10)
        skipButton?.titleLabel?.textAlignment = .center
        skipButton?.titleLabel?.numberOfLines = 2
        skipButton?.setTitle("跳过\n\(durationTime) s", for: .normal)
        skipButton?.addTarget(self, action: #selector(skipAction), for: .touchUpInside)
        self.addSubview(skipButton!)
        
        setupTimer()
    }
    
    @objc func tapImageAction() {
        if let _tapSplashImageBlock = self.tapSplashImageBlock {
            if self.actionUrl != "" {
                self.skipAction()
                _tapSplashImageBlock(self.actionUrl)
            }
        }
        MobClick.event("open_adv_number")
    }
    
    
    @objc func skipAction() {
        dismissSplashView(initiativeDismiss: true)
        MobClick.event("skip_adv_number")
    }
    
    func setupTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1.0,
                                                       target: self,
                                                       selector: #selector(timerCycleAction),
                                                       userInfo: nil,
                                                       repeats: true)
    }
    
    func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    @objc func timerCycleAction() {
        if 0 == durationTime {
            dismissSplashView(initiativeDismiss: false)
        } else {
            durationTime -= 1
        }
    }
    
    func dismissSplashView(initiativeDismiss: Bool) {
        
        stopTimer()
        UIView.animate(withDuration: 0.6,
                                   animations: {
                                    self.alpha = 0.0
                                    self.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
            },
                                   completion: {(finished) -> Void in
                                    self.removeFromSuperview()
                                    if let _splashViewDissmissBlock = self.splashViewDissmissBlock {
                                        _splashViewDissmissBlock(initiativeDismiss)
                                    }
        })
    }
    
    class func isExistsSplashData() -> Bool{
        let latestImgUrl = UserDefaults.standard.value(forKey: IMG_URL) as? String
        let isFileExists = FileManager.default.fileExists(atPath: IMG_PATH)
        
        return nil != latestImgUrl && isFileExists
    }
    
    class func updateSplashData(imgUrl: String?, actUrl: String?, shareTitle:String?, shareInfo:String?, shareImage:String?, urlType:Int, title:String?) {
        if nil == imgUrl {
            // no data
            return
        }
        
        UserDefaults.standard.setValue(imgUrl, forKey: IMG_URL)
        UserDefaults.standard.setValue(actUrl, forKey: ACT_URL)
        
        UserDefaults.standard.setValue(shareTitle, forKey: OPEN_ADV_SHARE_TITLE)
        UserDefaults.standard.setValue(shareInfo, forKey: OPEN_ADV_SHARE_INFO)
        UserDefaults.standard.setValue(shareImage, forKey: OPEN_ADV_SHARE_THUMBIMAGE)
        UserDefaults.standard.setValue(urlType, forKey: OPEN_ADV_URL_TYPE)
        UserDefaults.standard.setValue(title, forKey: OPEN_ADV_URL_TITLE)
        
        UserDefaults.standard.synchronize()
        
        DispatchQueue.global(qos: DispatchQoS.QoSClass.background).async {
            DispatchQueue.main.async {
                let imageURL = URL(string: imgUrl!)
                if let _imageURL = imageURL {
                    let data = NSData(contentsOf: _imageURL)
                    if let _data = data {
                        let image = UIImage(data: _data as Data)
                        if let _image = image {
                            if let imageNSData = UIImagePNGRepresentation(_image) as NSData? {
                                imageNSData.write(toFile: IMG_PATH, atomically: true)
                            }
                        }
                    }
                    
                }
            }
        }
    }
}
