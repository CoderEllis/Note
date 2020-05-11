import UIKit

class TemperatureMeter: UIView {
    
    //进度条所在圆的直径
    let progressDiameter:CGFloat = 80
    
    //进度条线条宽度
    let progressWidth:CGFloat = 4
    
    var progress : CGFloat = 0 
    {
        didSet { setNeedsDisplay() }
    }
    
    //进度条轨道颜色
    let trackColor = UIColor.lightGray
    
    //渐变进度条
    lazy var progressLayer = CAShapeLayer()
    
    //绘制进度条背景轨道
    lazy var trackLayer = CAShapeLayer()
    
    lazy var gradientLayer = CALayer()
    lazy var gradientLayer1 = CAGradientLayer()
    lazy var gradientLayer2 = CAGradientLayer()
    
    /** 进度显示 */
    lazy var progressLabel = UILabel()
    
    let path = UIBezierPath()
    //设置圆形中图片
    var image: UIImage?
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.clear 
    }
    
    override func draw(_ rect: CGRect) {
        //创建进度文本标签
        progressLabel.frame = CGRect(x:0, y:0, width:bounds.width,
                                     height:progressDiameter)
        progressLabel.textAlignment = .center
        progressLabel.text = String(format: "%.2f%%", progress * 100)
        addSubview(progressLabel)
        
        //轨道以及上面进度条的路径（在组件内部水平居中） 获取整个进度条圆圈路径
        let path = UIBezierPath(arcCenter: CGPoint(x: bounds.midX, y: 40),
                                radius: (progressDiameter-progressWidth)/2,
                                startAngle: angleToRadian(-210),
                                endAngle: angleToRadian(30),
                                clockwise: true)
        
        //绘制进度条背景轨道
        trackLayer.frame = bounds
        trackLayer.fillColor = UIColor.clear.cgColor
        //设置轨道颜色
        trackLayer.strokeColor = trackColor.cgColor
        //轨道使用圆角线条
        trackLayer.lineCap = CAShapeLayerLineCap.round
        //轨道线条的宽度
        trackLayer.lineWidth = progressWidth
        //设置轨道路径
        trackLayer.path = path.cgPath
        //设置轨道透明度
        trackLayer.opacity = 0.25
        //将轨道添加到视图层中
        layer.addSublayer(trackLayer)
        
        //绘制进度条
        progressLayer.frame = bounds
        progressLayer.fillColor = UIColor.clear.cgColor
        progressLayer.strokeColor = UIColor.black.cgColor
        progressLayer.lineCap = CAShapeLayerLineCap.square
        progressLayer.lineWidth = progressWidth
        progressLayer.path = path.cgPath
        progressLayer.strokeStart = 0
        //进度条默认结束位置是0
        progressLayer.strokeEnd = progress
        //将进度条添加到视图层中
        layer.addSublayer(progressLayer)
        
        
        //绘制左侧的渐变层（从上往下是：由黄变蓝）
        gradientLayer1.frame = CGRect(x:0, y:0, width:self.frame.width/2,
                                      height:progressDiameter/4 * 3 + progressWidth)
        gradientLayer1.colors = [UIColor.yellow.cgColor,
                                 UIColor.green.cgColor,
                                 UIColor.cyan.cgColor,
                                 UIColor.blue.cgColor]
        gradientLayer1.locations = [0.1,0.4,0.6,1]
        
        //绘制右侧的渐变层（从上往下是：由黄变红）
        gradientLayer2.frame = CGRect(x:self.frame.width/2, y:0, width:self.frame.width/2,
                                      height:progressDiameter/4 * 3 + progressWidth)
        gradientLayer2.colors = [UIColor.yellow.cgColor,
                                 UIColor.red.cgColor]
        gradientLayer2.locations = [0.1,0.8]
        
        //用于存放左右两侧的渐变层，并统一添加到视图层中
        
        gradientLayer.addSublayer(gradientLayer1)
        gradientLayer.addSublayer(gradientLayer2)
        layer.addSublayer(gradientLayer)
        
        //将渐变层的遮罩设置为进度条
        gradientLayer.mask = progressLayer
        
        //在圆形中画上头像
        path.addClip()
        image?.draw(in: bounds)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    //设置进度（可以设置是否播放动画，以及动画时间）
//    func setPercent(_ percent:CGFloat, animated:Bool = true) {
//        //改变进度条终点，并带有动画效果（如果需要的话）
//        CATransaction.begin()
//        CATransaction.setDisableActions(!animated)
//        CATransaction.setAnimationTimingFunction(CAMediaTimingFunction(name:
//            CAMediaTimingFunctionName.easeInEaseOut))
//        //        CATransaction.setAnimationDuration(duration) withDuration duration: Double
//        progressLayer.strokeEnd = percent//100.0
//        CATransaction.commit()
//        
//        
//        //设置文本标签值
//        //        label.text = "\(Int(percent))℃"
//        progressLabel.text = String(format: "%.2f%%", percent * 100)
//    }
    
    //把角度转换成弧度
    private func angleToRadian(_ angle:CGFloat) -> CGFloat {
        return .pi*(angle)/180.0
    }
}
