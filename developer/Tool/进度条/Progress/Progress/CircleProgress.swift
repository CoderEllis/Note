//
//  New.swift
//  DIY
//
//  Created by Soul Ai on 9/1/2019.
//  Copyright © 2019 Soul Ai. All rights reserved.
//

import UIKit

class CircleProgress: UIView {//环形圆弧进度
    
    
    var progress : CGFloat = 0 {
        didSet { setNeedsDisplay() }
    }
    
    //设置绘图线宽
    let lineWith :CGFloat = 10.0
    let excircleLineWith :CGFloat = 3.0
    
    
    /** 进度显示 */
    lazy var progressLabel = UILabel()
    /** 顶层填充layer */
    lazy var topLayer = CAShapeLayer()
    /** 底层边框layer */
    lazy var bottomLayer = CAShapeLayer()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.clear
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        layer.addSublayer(bottomLayer)
        layer.addSublayer(topLayer)
        setLabel()
        
        let center = CGPoint(x: bounds.size.width / 2, y: bounds.size.height / 2)
        let radius = bounds.size.width / 2
        
        let start = -CGFloat(Double.pi / 2)
        let angle = progress * .pi * 2
        let endA = start + angle
        
        //底层的圆边
        bottomLayer.path = UIBezierPath(arcCenter: center, radius: radius, startAngle: 0, endAngle: .pi * 2, clockwise: true).cgPath
        bottomLayer.fillColor = UIColor.clear.cgColor  //中间去填充色
        bottomLayer.strokeColor = UIColor.blue.cgColor
        bottomLayer.lineWidth = 10.0
        
        topLayer.path = UIBezierPath(arcCenter: center, radius: radius, startAngle: start, endAngle: endA, clockwise: true).cgPath
        topLayer.fillColor = UIColor.clear.cgColor  //中间去填充色
        topLayer.strokeColor = UIColor.red.cgColor
        topLayer.lineWidth = 10.0
    }
    
    ///提示 label
    func setLabel() {
        progressLabel.bounds = bounds
        progressLabel.center = CGPoint(x: bounds.size.width * 0.5, y: bounds.size.height * 0.5)
        progressLabel.textAlignment = .center
        progressLabel.text = String(format: "%.2f%%", progress * 100)
        addSubview(progressLabel)
    }
    
    //把角度转换成弧度
    func toRadians(_ degrees:CGFloat) -> CGFloat {
        return .pi*(degrees)/180.0
    }
}
