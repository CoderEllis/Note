import UIKit
import AVFoundation

class ScanQRCodeVC: UIViewController {

    ///容器视图
    @IBOutlet weak var scanBackView: UIView!
    
    /// 冲击波视图
    @IBOutlet weak var chongjibo: UIImageView!
    
    /// 冲击波约束
    @IBOutlet weak var toButton: NSLayoutConstraint!
    
    /// 容器视图高度约束
    @IBOutlet weak var containerHeightCons: NSLayoutConstraint!
    
    /// 底部工具条
    @IBOutlet weak var tabBar: UITabBar!
    
    //闪光灯
    var flashlightBtn: UIButton!
//    var scanDevice: AVCaptureDevice?
    
static let shareInstance = ScanQRCodeVC()
    var tools: QRCodeTool = QRCodeTool()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        startScanAnimation()
        
        startAnimation()
        
        
        // 1.设置默认选中底部工具条点击
        tabBar.selectedItem = tabBar.items?.last
        tabBar.delegate = self
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        closeFlashlight(flashlightBtn)
        removeScanAnimation()
        QRCodeTool.shareInstance.cancelSampleBufferDelegate()
        
    }
    override open func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        startScan()
    }
    

    func startScanAnimation() {
        
        if flashlightBtn == nil {
            flashlightBtn = UIButton.init(type: .custom)
            let flashlightBtnX: CGFloat = self.scanBackView.frame.size.width/2
            let flashlightBtnY: CGFloat = self.scanBackView.frame.size.height
            let flashlightBtnW: CGFloat = 30
            let flashlightBtnH: CGFloat = 30
            flashlightBtn.setTitle("轻点照亮", for: .normal)
            flashlightBtn.titleLabel?.font = UIFont.systemFont(ofSize: 10)
            flashlightBtn.imageEdgeInsets = UIEdgeInsets(top: -5, left: 0, bottom: 0, right: -20)
            flashlightBtn.titleEdgeInsets = UIEdgeInsets(top: 0, left: -15, bottom: -45, right: 0)
            flashlightBtn.imageView?.contentMode = .scaleAspectFill
            flashlightBtn.frame = CGRect(x: flashlightBtnX - flashlightBtnW / 2, y: flashlightBtnY - flashlightBtnH * 1.5, width: flashlightBtnW, height: flashlightBtnH)
            flashlightBtn.setBackgroundImage(UIImage(named: "SGQRCodeFlashlightOpenImage"), for: .normal)
            flashlightBtn.setBackgroundImage(UIImage(named: "SGQRCodeFlashlightCloseImage"), for: .selected)

            flashlightBtn.isSelected = false
            flashlightBtn.isHidden = true
            flashlightBtn.addTarget(self, action: #selector(flashlightCilck(_:)), for: .touchUpInside)
            self.scanBackView.addSubview(flashlightBtn)
        }
    }
    
    ///闪光灯点击事件
    @objc func flashlightCilck(_ sender: UIButton) {
         openFlashlight(sender)
    }
    
    
    //关闭闪光灯
    func closeFlashlight(_ flash: UIButton) {
        guard let scanDevice = AVCaptureDevice.default(for: .video) else {
            print("此设备没有 LED")
            return
        }
        if scanDevice.hasTorch {
            do {
                try scanDevice.lockForConfiguration()
                scanDevice.torchMode = .off
                flash.isSelected = false
            }catch {
                print(error)
                return
            }
        }
    }
    
    
    
    ///闪光灯:开关
     func openFlashlight(_ sender: UIButton)  {
        guard let device = AVCaptureDevice.default(for: AVMediaType.video) else {
            print("此设备没有 LED")
            return
        }
        if device.hasTorch && device.isTorchAvailable {
            do {
                //呼叫控制硬件
                try device.lockForConfiguration()
            } catch {
                print(error)
                return
            }
            //开启、关闭闪光灯
            device.torchMode = device.torchMode == .off ? .on : .off
            sender.isSelected = sender.isSelected == false ? true : false
            //控制完毕需要关闭控制硬件
            device.unlockForConfiguration()
        }
        /*
         if scanDevice.hasTorch && scanDevice.isTorchAvailable {
         do {
         try scanDevice.lockForConfiguration()
         }catch {
         print(error)
         return
         }
         if scanDevice.torchMode == .off {
         scanDevice.torchMode = .on
         flashlightBtn.isSelected = true
         }else {
         scanDevice.torchMode = .off
         self.flashlightBtn.isSelected = false
         }
         scanDevice.unlockForConfiguration()
         }
         */
    }
    
    
    
    

 
    @IBAction func chiosePicttureBthClick(_ sender: Any) {
        // 1.判断是否能够打开相册
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.photoLibrary) {
            let pictureVC = UIImagePickerController()
            pictureVC.sourceType = UIImagePickerController.SourceType.savedPhotosAlbum
            pictureVC.delegate = self
            present(pictureVC, animated: true, completion: nil)
        }else {
            print("提示打开相册")
        }

    }
    
    //关闭扫码
    @IBAction func closeBthClick(_ sender: Any) {
        tools.session.stopRunning()
        dismiss(animated: true, completion: nil)
    }
    

}



// MARK: - 设置UI界面
extension ScanQRCodeVC {
    
    ///扫码时的冲击波动画
    fileprivate func startAnimation() {
        toButton.constant = scanBackView.frame.size.height
        view.layoutIfNeeded()
        
        toButton.constant = -scanBackView.frame.size.height
        
        // 执行扫描动画
        UIView.animate(withDuration: 2.5) {
            UIView.setAnimationRepeatCount(MAXFLOAT)
            self.view.layoutIfNeeded()
        }
    }
    
    //移除动画
    func removeScanAnimation() {
        
        chongjibo.layer.removeAllAnimations()
    }
    
    /// 扫描二维码
    fileprivate func startScan() {
        
        QRCodeTool.shareInstance.setRectInterest(orignRect: scanBackView.frame)
        QRCodeTool.shareInstance.scanQRCode(inView: view, isDrawFrame: true, resultBlock: { (resultStrs) in
            print(resultStrs)
            
        }) { (resultValue) in
            self.showTorchView(resultValue)
        }
        
    }
    
    
    func showTorchView(_ brightnessValue: CGFloat) {
        if flashlightBtn.isSelected {
            return
        }
        if AVCaptureDevice.default(for: .video)?.hasTorch == true {
            flashlightBtn.isHidden = brightnessValue > 0
        }
    }
    
    
}


//相册代理
extension ScanQRCodeVC : UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        // 1.取出选中的图片
        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {
            return
        }
        picker.dismiss(animated: true) {
            
            guard let ciImage = CIImage(image: image) else {
                return
            }
            
            // 2.从选中的图片中读取二维码数据
            // 2.1创建一个探测器
            let detector = CIDetector(ofType: CIDetectorTypeQRCode, context: nil, options: [CIDetectorAccuracy: CIDetectorAccuracyHigh])
            // 2.2利用探测器探测数据
            let results = detector!.features(in: ciImage)
            
            var url: String?
            // 2.3取出探测到的数据
            for result in results {
                
                let qrFeature = result as! CIQRCodeFeature
                
                url = qrFeature.messageString
            }
            guard let urls = URL(string: url!) else {
                return
            }
            
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(urls, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(urls)
            }
        }
        

    }
}

extension ScanQRCodeVC: UITabBarDelegate {
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        // 根据当前选中的按钮重新设置二维码容器高度
        containerHeightCons.constant = (item.tag == 1) ? 200 : 100
        view.layoutIfNeeded()
        // 移除动画
        chongjibo.layer.removeAllAnimations()
        // 重新开启动画
        startAnimation()

        
    }
}
