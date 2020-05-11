import UIKit

@objc protocol XProgressViewDelegate: NSObjectProtocol {
    @objc optional func progressTapped(progressView: XProgressView!)
}

@IBDesignable class XProgressView: UIView {
    
    struct Constant {
        static let lineWidth: CGFloat = 10
        static let trackColor = UIColor(red: 245/255.0, green: 245/255.0, blue: 245/255.0, alpha: 1)
        static let endColor = UIColor.red.withAlphaComponent(0.8)
        static let startColor = UIColor.green.withAlphaComponent(0.2)
    }
    
    let gradientLayer = CAGradientLayer()
    let trackLayer = CAShapeLayer()
    let progressLayer = CAShapeLayer()
    let path = UIBezierPath()
    
    @IBInspectable var progress: Int = 0
    
    @IBInspectable var image: UIImage?
    
    weak var delegate: XProgressViewDelegate?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        backgroundColor = UIColor.clear
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.clear
    }
    
    override func draw(_ rect: CGRect) {
//        path.move(to: CGPoint(x: bounds.midX + Constant.lineWidth/2.0, y: Constant.lineWidth))
        path.addArc(withCenter: CGPoint(x: bounds.midX, y: bounds.midY), radius: bounds.size.width/2 - Constant.lineWidth, startAngle: angleToRadian(angle: -90), endAngle: angleToRadian(angle: 270), clockwise: true)
        
        trackLayer.frame = bounds
        trackLayer.fillColor = UIColor.clear.cgColor
        trackLayer.strokeColor = Constant.trackColor.cgColor
        trackLayer.lineWidth = Constant.lineWidth
        trackLayer.path = path.cgPath
        trackLayer.lineCap = CAShapeLayerLineCap.round
        layer.addSublayer(trackLayer)
        
        progressLayer.frame = bounds
        progressLayer.fillColor = UIColor.clear.cgColor
        progressLayer.strokeColor = UIColor.orange.cgColor
        progressLayer.lineWidth = Constant.lineWidth
        progressLayer.path = path.cgPath
        progressLayer.strokeStart = 0
        progressLayer.lineCap = CAShapeLayerLineCap.square
        progressLayer.strokeEnd = CGFloat(progress)/100.0
        
        gradientLayer.frame = bounds
        gradientLayer.colors = [Constant.startColor.cgColor, Constant.endColor.cgColor]
        gradientLayer.mask = progressLayer
        layer.addSublayer(gradientLayer)
        
        path.addClip()
        image?.draw(in: bounds)
    }
    
    func setProgress(_ pro: Int,animated anim: Bool) {
        setProgress(pro, animated: anim, withDuration: 0.55)
    }
    
    func setProgress(_ pro: Int,animated anim: Bool, withDuration duration: Double) {
        progress = pro
        CATransaction.begin()
        CATransaction.setDisableActions(!anim)
        CATransaction.setAnimationTimingFunction(CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut))
        CATransaction.setAnimationDuration(duration)
        progressLayer.strokeEnd = CGFloat(progress)/100.0
        CATransaction.commit()
    }
    
    
    private func angleToRadian(angle: CGFloat)->CGFloat {
        return angle/180.0 * .pi
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if delegate != nil && delegate!.responds(to: Selector(("progressTapped:"))) {
            delegate?.progressTapped!(progressView: self)
        }
    }
}
