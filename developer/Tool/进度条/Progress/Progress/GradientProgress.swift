//
//  New.swift
//  DIY
//
//  Created by Soul Ai on 9/1/2019.
//  Copyright © 2019 Soul Ai. All rights reserved.
//

import UIKit

class GradientProgress: UIView {//渐变色圆弧进度
    
    
    var progress : CGFloat = 0 
    {
        didSet { setNeedsDisplay() }
    }
    
    //设置绘图线宽
    let lineWith :CGFloat = 10.0
    let excircleLineWith :CGFloat = 3.0
    
    /** 填充颜色 */
    var fillColor : UIColor?
    
    /** 边框颜色 */
    var strokeColor : UIColor?
    
    
    /** 进度显示 */
    lazy var progressLabel = UILabel()
    /** 顶层显示层 填充layer */
    lazy var fillLayer = CAShapeLayer()
    /** 底层显示层 边框layer */
    lazy var strokeLayer = CAShapeLayer()
    
    lazy var gradientLayer = CALayer()
    lazy var leftGradient = CAGradientLayer()
    lazy var rightGradient = CAGradientLayer()
    
    lazy var path = UIBezierPath()
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.clear
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        setUi()
        
    }
    
    
    // MARK: - /** 渐变色圆弧进度 */
    private func setUi() {
        setLabel()
        
        let center = CGPoint(x: bounds.size.width / 2, y: bounds.size.height / 2)
        let radius = bounds.size.width / 2
        let path = UIBezierPath(arcCenter: center, radius: radius, startAngle: -(.pi/4 * 5), endAngle: .pi / 4, clockwise: true)
        //底层的圆边
        strokeLayer.path = path.cgPath
        fillLayer.path = path.cgPath
        path.close()
        
        strokeLayer.frame = bounds
        strokeLayer.fillColor = UIColor.clear.cgColor  //中间去填充色
        strokeLayer.strokeColor = UIColor.purple.cgColor
        strokeLayer.lineWidth = 10.0
        strokeLayer.lineCap = CAShapeLayerLineCap.round
        layer.addSublayer(strokeLayer)
        
        //顶层
        fillLayer.frame = bounds
        fillLayer.lineWidth = 10.0
        fillLayer.lineCap = CAShapeLayerLineCap.square
        fillLayer.fillColor = UIColor.clear.cgColor
        fillLayer.strokeColor = UIColor.white.cgColor
        fillLayer.strokeStart = 0
        fillLayer.strokeEnd = progress
        layer.addSublayer(fillLayer)
        
        draww()
    }
    
    ///渐变彩色层
    func draww() {
        // 设置渐变层
        leftGradient.frame = CGRect(x: -10/2, y: -10/2, width: bounds.size.width / 2 + 10/2, height: bounds.size.height + 10)
        leftGradient.colors = [UIColor.yellow.cgColor,UIColor.red.cgColor]
        leftGradient.locations = [0.3,0.9,1]
        
        rightGradient.frame = CGRect(x: bounds.size.width / 2, y: -10/2, width: bounds.size.width / 2 + 10/2, height: bounds.size.height + 10)
        rightGradient.colors = [UIColor.yellow.cgColor,UIColor.green.cgColor]
        rightGradient.locations = [0.3,0.9,1]
        
        gradientLayer.addSublayer(leftGradient)
        gradientLayer.addSublayer(rightGradient)
        layer.addSublayer(gradientLayer)
        gradientLayer.mask = fillLayer
    }
    
    ///提示 label
    func setLabel() {
        progressLabel.bounds = bounds
        progressLabel.center = CGPoint(x: bounds.size.width * 0.5, y: bounds.size.height * 0.5)
        progressLabel.textAlignment = .center
        progressLabel.text = String(format: "%.2f%%", self.progress * 100)
        addSubview(progressLabel)
    }
    
}
