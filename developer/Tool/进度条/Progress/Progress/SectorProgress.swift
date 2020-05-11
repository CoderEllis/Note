//
//  New.swift
//  DIY
//
//  Created by Soul Ai on 9/1/2019.
//  Copyright © 2019 Soul Ai. All rights reserved.
//

import UIKit

class SectorProgress: UIView {//扇形进度
    
    
    var progress : CGFloat = 0 {
        didSet { setNeedsDisplay() }
    }
    
    
    //进度文本标签
    lazy var label = UILabel()
    
    /** 进度显示 */
    lazy var progressLabel = UILabel()
    /** 填充layer */
    lazy var fillLayer = CAShapeLayer()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.clear
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        ///提示 label
        label.bounds = bounds
        label.center = CGPoint(x: frame.size.width * 0.5, y: frame.size.height * 0.5)
        label.textAlignment = .center
        label.text = String(format: "%.2f%%", progress * 100)
        self.addSubview(label)
        
        
        let center = CGPoint(x: bounds.size.width / 2, y: bounds.size.height / 2)
        let radius = bounds.size.width / 2
        let startAngle = -CGFloat(Double.pi / 2)
        let angle = progress * .pi * 2
        let endAngle = startAngle + angle
        
        let path = UIBezierPath(arcCenter: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: true)
        
        path.addLine(to: center)
        
        path.lineCapStyle = CGLineCap.round//设置线样式
        UIColor.green.set()
        //填充
        path.fill() 
        
        //填充色
//        fillLayer.path = path.cgPath
//        fillLayer.fillColor = UIColor.yellow.cgColor
//        layer.addSublayer(fillLayer)
        
        //关闭路径
        path.close()
    }
    
    //把角度转换成弧度
    func toRadians(_ degrees:CGFloat) -> CGFloat {
        return .pi*(degrees)/180.0
    }
}
