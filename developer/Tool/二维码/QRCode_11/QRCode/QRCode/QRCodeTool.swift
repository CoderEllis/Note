import UIKit
import AVFoundation

typealias BrightnessBlock = (CGFloat) -> ()
typealias ScanResultBlock = ([String]) -> ()

class QRCodeTool: NSObject, AVCaptureVideoDataOutputSampleBufferDelegate {
    
    
    static let shareInstance = QRCodeTool()

    /// 懒加载输入对象
    //  输入
    fileprivate lazy var input: AVCaptureDeviceInput? = {
        // 1.1 获取摄像头设备
        guard let device = AVCaptureDevice.default(for: AVMediaType.video) else {
            return nil
        }
        
        // 1.2 把摄像头设备当做输入设备
//        var input: AVCaptureDeviceInput?
        do {
            let input = try AVCaptureDeviceInput(device: device)
            return input
        }catch {
            print(error)
            return nil
        }
    }()
    
    // 输出
    fileprivate lazy var output: AVCaptureMetadataOutput = {
        let output = AVCaptureMetadataOutput()
        // 2.1 设置结果处理的代理
        output.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
        return output
    }()
    
    // 会话
     lazy var session: AVCaptureSession = {
        let session = AVCaptureSession()
            return session
    }()
    
    
    //预览层 可以快速呈现摄像头的原始数据
    fileprivate lazy var layer: AVCaptureVideoPreviewLayer = {
        let layer = AVCaptureVideoPreviewLayer(session: self.session)
        return layer
    }()

    
    fileprivate var brightnessBlock: BrightnessBlock?
    fileprivate var scanResultBlock: ScanResultBlock?
    fileprivate var isDrawFrame: Bool = false
    
    //光线感应器代理
    lazy var videoDataOutput: AVCaptureVideoDataOutput = {
        let videoDataOutput = AVCaptureVideoDataOutput()
        videoDataOutput.setSampleBufferDelegate(self, queue: DispatchQueue.main)
        return videoDataOutput
    }()
    
    func initScanView() {
        if (session.canAddOutput(videoDataOutput)) {
            session.addOutput(videoDataOutput)
        }
    }
    
    //删除光线感应器代理
    func cancelSampleBufferDelegate() {
        videoDataOutput.setSampleBufferDelegate(nil, queue: DispatchQueue.main)
    }
    
    
    // 光线感应器代理 方法
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        let metadataDic = CMCopyDictionaryOfAttachments(allocator: nil, target: sampleBuffer, attachmentMode: kCMAttachmentMode_ShouldPropagate)
        let metadata = NSDictionary.init(dictionary: metadataDic as! [AnyHashable : Any], copyItems: true)
        let exifMetadata:NSDictionary = NSDictionary.init(dictionary: metadata.object(forKey: kCGImagePropertyExifDictionary as String) as! [AnyHashable : Any], copyItems: true)
        let brightnessValue:CGFloat = exifMetadata[kCGImagePropertyExifBrightnessValue] as! CGFloat
        // 你的操作
        print(brightnessValue)
       
        brightnessBlock!(brightnessValue)
    }
    

    
    
    //扫一扫
    func scanQRCode(inView: UIView, isDrawFrame: Bool, resultBlock: @escaping (_ resultStrs: [String]) -> (), flashlightBlock: @escaping (_ flashlightValue: CGFloat) -> () ) {
        
        
        initScanView()
        brightnessBlock = flashlightBlock
        
         // 记录闭包
        scanResultBlock = resultBlock
        self.isDrawFrame = isDrawFrame
        
        guard let input = self.input else { return }
        
        if session.canAddInput(input) && session.canAddOutput(output) {
            //将输入、输出对象加入到会话中 AVCaptureVideoDataOutput 
            session.addInput(input)
            session.addOutput(output)
        }else {
            return
        }
        
        // 3.1 设置二维码可以识别的码制
        // 设置识别的类型, 必须要在输出添加到会话之后, 才可以设置, 不然, 崩溃
        // output.availableMetadataObjectTypes //AVMetadataObject.ObjectType.qr
        output.metadataObjectTypes = output.availableMetadataObjectTypes
        guard let scanDevice = AVCaptureDevice.default(for: AVMediaType.video) else {
            return
        }
        
        if (scanDevice.isFocusModeSupported(.autoFocus)) {
            do{
                try input.device.lockForConfiguration()
            }catch {}                             //.autoFocus 自动聚焦
            input.device.focusMode = .continuousAutoFocus // 自动持续聚焦
            input.device.unlockForConfiguration()
        }
        
        // 3.2 添加视频预览图层(让用户可以看到界面) (不是必须添加的)
        if inView.layer.sublayers == nil {
            layer.frame = inView.layer.bounds
            inView.layer.insertSublayer(layer, at: 0)
        }else {
            let subLayers = inView.layer.sublayers!
            if !subLayers.contains(layer) {
                layer.frame = inView.layer.bounds
                inView.layer.insertSublayer(layer, at: 0)
            }
        }
        
        // 4. 启动会话, (让输入开始采集数据, 输出对象,开始处理数据)
        session.startRunning()
        
    }
    
    // 设置扫描 范围区域
    func setRectInterest(orignRect: CGRect)  {
        //  CGRect(0, 0, 1, 1)  0.0 - 1.0  // 0 0. 右上角
        let bounds = UIScreen.main.bounds
        let x: CGFloat = orignRect.origin.x / bounds.size.width
        let y: CGFloat = orignRect.origin.y / bounds.size.height
        let width: CGFloat = orignRect.size.width / bounds.size.width
        let height: CGFloat = orignRect.size.height / bounds.size.height
        output.rectOfInterest = CGRect(x: y, y: x, width: height, height: width)
    }
    
    // 探测图片
    // 参数1: 原始图片
    // 参数2: 是否需要绘制扫描边框
    // 返回值: 元组(结果字符串组成的数组, 绘制好二维码边框的图片(如果不要求绘制, 则返回的是原始图片))
    class func detectorQRCodeImage(image: UIImage, isDrawQRCodeFrame: Bool) -> (resultStrs: [String]?, resultImage: UIImage) {
        
        let imageCI = CIImage(image: image)
        
        // 开始识别
        // 1. 创建一个二维码探测器
        let dector = CIDetector(ofType: CIDetectorTypeQRCode, context: nil, options: [CIDetectorAccuracy: CIDetectorAccuracyHigh])
        
        // 2. 直接探测二维码特征
        let features = dector!.features(in: imageCI!)
        
        var resultImage = image
        
        var result = [String]()
        
        for feature in features {
//            print(feature)
            let qrFeature = feature as! CIQRCodeFeature
            
            //            print(qrFeature.messageString)
            result.append(qrFeature.messageString!)
            //            print(qrFeature.bounds)
            
            if isDrawQRCodeFrame {
                resultImage = drawFrame(image: resultImage, feature: qrFeature)
            }
        }
        return (result,resultImage)
    }

    // 根据给定的字符串, 转换成为二维码图片, 并将结果返回
    // 参数1: 需要转换的字符串
    // 参数2: 二维码中间的自定义图片
    // 返回值: 生成后的结果图片
    // 优化: 可以将自定义图片, 单独写成一个方法也可以, 也可以暴露更多的参数出去, 让方法变得更加灵活, 比如说是中间图片的大小
    static func generatorQRCode(inputStr: String, centerImage: UIImage?) -> UIImage {
        
        // 1. 创建二维码滤镜
        let filter = CIFilter(name: "CIQRCodeGenerator")
        
        // 1.1 恢复滤镜默认设置
        filter?.setDefaults()
        
        // 2. 设置滤镜输入数据  KVC
        let data = inputStr.data(using: String.Encoding.utf8)
        filter?.setValue(data, forKey: "inputMessage")
        
        // 2.2 设置二维码的纠错率
        filter?.setValue("M", forKey: "inputCorrectionLevel")
        
        // 3. 从二维码滤镜里面, 获取结果图片
        var image = filter?.outputImage
        
        // 借助这个方法, 处理成为一个高清图片
        let transform = CGAffineTransform(scaleX: 30, y: 30)
        image = image?.transformed(by: transform)
        
        // 3.1 图片处理  (23.0, 23.0)
        var resultImage = UIImage(ciImage: image!)
//        print(resultImage.size)
        
        // 前景图片
//        let center = UIImage(named: "erha.png")
        if centerImage != nil {
            resultImage = getNewImage(sourceImage: resultImage, center: centerImage!)
        }
        
        // 4. 显示图片
        return resultImage
    }
    
}






/// 私有方法
// 这些方法, 都是工具类内部, 自己使用, 并不是直接暴漏给外界, 这样的话, 最好使用fileprivate关键字修饰我们的方法
extension QRCodeTool {
    
    // 根据一个图片的特征, 以及图片, 来绘制边框
    class fileprivate func drawFrame(image: UIImage, feature: CIQRCodeFeature) -> UIImage {
        
        let size = image.size
        print(size)
        // 1. 开启图形上下文
        UIGraphicsBeginImageContext(size)
        
        // 2. 绘制大图片
        image.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        
        // 转换坐标系(上下颠倒)  x:1 不缩放  Y: -1 颠倒坐标系 -0.5 颠倒一半 Y 的面积   取值-1 ~ 1
        let context = UIGraphicsGetCurrentContext()
        context?.scaleBy(x: 1, y: -1)
        context?.translateBy(x: 0, y: -size.height)  //偏移 取反 因为 颠倒了图片的高度
        
        // 3. 绘制路径
        let bounds = feature.bounds
        let path = UIBezierPath(rect: bounds)
        UIColor.red.setStroke()
        path.lineWidth = 6
        path.stroke()
        
        // 4. 取出结果图片
        let resultImage = UIGraphicsGetImageFromCurrentImageContext()
        
        // 5. 关闭上下文
        UIGraphicsEndImageContext()
        
        // 6. 返回结果
        return resultImage!
        
    }
    
    // 根据给定的两个图片, 生成合成后的图片, 返回给外界
    class fileprivate func getNewImage(sourceImage: UIImage,center: UIImage) -> UIImage {
        
        let size = sourceImage.size
        //1.开始上下文
        UIGraphicsBeginImageContext(size)
        
        //2.绘制大图片
        sourceImage.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        
        //3.绘制小图
        let width: CGFloat = 100
        let height: CGFloat = 100
        let x: CGFloat = (size.width - width) * 0.5
        let y: CGFloat = (size.height - height) * 0.5
        center.draw(in: CGRect(x: x, y: y, width: width, height: height))
        
        //4.取出结果图片
        let resultImage = UIGraphicsGetImageFromCurrentImageContext()
        
        //5.关闭上下文
        UIGraphicsEndImageContext()
        
        //6.返回结果
        return resultImage!
    }
    
}


// MARK: - AVCaptureMetadataOutputObjectsDelegate
extension QRCodeTool: AVCaptureMetadataOutputObjectsDelegate {
    
    // 扫描到结果之后调用
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        
        if isDrawFrame {
            //移除动画
            removeFrameLayer()
        }
        scanSound()
        //session?.stopRunning()
        
        //print(metadataObjects)
        
        var resultStrs = [String]()
        for obj in metadataObjects {
            
            if obj is AVMetadataMachineReadableCodeObject {
                
                // 转换成为, 二维码, 在预览图层上的真正坐标
                // qrCodeObj.corners 代表二维码的四个角, 但是, 需要借助视频预览 图层,转换成为,我们需要的可以用的坐标
                let qrCodeObj = self.layer.transformedMetadataObject(for: obj) as! AVMetadataMachineReadableCodeObject
                
//                print(qrCodeObj.stringValue as Any)
                //Optional("http://weixin.qq.com/r/1zoeBh3EVEArrVll92-F")
//                print(qrCodeObj.corners)
                
                resultStrs.append(qrCodeObj.stringValue!)
                if isDrawFrame {
                    drawFrame(qrCodeObj)
                }
                
            }
        }
        if scanResultBlock != nil {
            scanResultBlock!(resultStrs)
        }
    }
    
    
    func drawFrame(_ qrCodeObj: AVMetadataMachineReadableCodeObject) {
        
        if qrCodeObj.corners.isEmpty { //corners 四个角是否为空
            return
        }
        
        // 1. 借助一个图形层, 来绘制
        let shapLayer = CAShapeLayer()
        shapLayer.fillColor = UIColor.clear.cgColor
        shapLayer.strokeColor = UIColor.green.cgColor
        shapLayer.lineWidth = 3
        
        // 2.创建贝塞尔路径 根据四个点, 创建一个路径
        let path = UIBezierPath()
        guard let firstPoint = qrCodeObj.corners.first else {
            return
        }
        path.move(to: firstPoint)
        qrCodeObj.corners.forEach { (p) in
            path.addLine(to: p)
        }
        
        path.close()
        
        // 3. 给图形图层的路径赋值, 代表, 图层展示怎样的形状
        shapLayer.path = path.cgPath
        
        // 4. 直接添加图形图层到需要展示的图层
        layer.addSublayer(shapLayer)
    }
    
    
    func removeFrameLayer() -> () {
        guard let subLayers = layer.sublayers else {
            return
        }
        for subLayer in subLayers {
            if subLayer.isKind(of: CAShapeLayer.self) {
                subLayer.removeFromSuperlayer()
            }
        }
    }
    
    //MARK: -------提示音机震动------
    func scanSound() {
        var soundID : SystemSoundID = 0
        let soundFile = Bundle.main.path(forResource: "scanSound", ofType: "wav")
        AudioServicesCreateSystemSoundID(NSURL.fileURL(withPath: soundFile!) as CFURL, &soundID)
        
        //播放提示音 带有震动
        //        AudioServicesPlayAlertSound(soundID)
        //播放系统提示音
        AudioServicesPlaySystemSound(soundID)
    }
    
    
}


