//
//  New.swift
//  DIY
//
//  Created by Soul Ai on 9/1/2019.
//  Copyright © 2019 Soul Ai. All rights reserved.
//

import UIKit

class BallProgress: UIView {//圆形进度
    
    
    var progress : CGFloat = 0 {
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
    /** 填充layer */
    lazy var fillLayer = CAShapeLayer()
    /** 边框layer */
    lazy var strokeLayer = CAShapeLayer()
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.clear
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        neiyuan()
    }
    
    
    ///圆边 + 扇形进度圆图:方法一
    func neiyuan() {
        layer.addSublayer(fillLayer)
        layer.addSublayer(strokeLayer)
        ///提示 label
        setLabel()
        
        let center = CGPoint(x: bounds.size.width / 2, y: bounds.size.height / 2)
        let radius = bounds.size.width / 2
        let startAngle = CGFloat(Double.pi / 2) - progress * .pi
        let endAngle = CGFloat(Double.pi / 2) + progress * .pi
        
        //外面圆线
        let path = UIBezierPath(arcCenter: center, radius: radius, startAngle: 0, endAngle: .pi * 2, clockwise: true)
        //外环边框
        strokeLayer.path = path.cgPath
        strokeLayer.fillColor = UIColor.clear.cgColor  //中间去填充色
        strokeLayer.strokeColor = UIColor.red.cgColor
        path.close()
        
        let fillPath = UIBezierPath(arcCenter: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: true)
        fillPath.close()
        
        //中间的圆
        fillLayer.frame = bounds
        fillLayer.path = fillPath.cgPath
        fillLayer.fillColor = UIColor.yellow.cgColor  
        fillLayer.strokeColor = UIColor.clear.cgColor
    }
    
    
    //把角度转换成弧度
    func toRadians(_ degrees:CGFloat) -> CGFloat {
        return .pi*(degrees)/180.0
    }
    
    
    ///圆边 + 扇形进度圆图:方法二
    func hongbianneiyuan() {
        ///提示 label
        setLabel()
        let center = CGPoint(x: bounds.size.width / 2, y: bounds.size.height / 2)
        let radius = bounds.size.width / 2 - 5
        let startAngle = CGFloat(Double.pi / 2) - progress * .pi
        let endAngle = CGFloat(Double.pi / 2) + progress * .pi
//        let startAngle = -CGFloat(Double.pi/2)
//        let endAngle = progress * .pi * 2 + startAngle
        
        
        let excircle = UIBezierPath(arcCenter: center, radius: radius, startAngle: CGFloat(0), endAngle:CGFloat( 2 * Double.pi), clockwise: true)
        excircle.lineCapStyle = CGLineCap.round//设置线样式
        excircle.lineWidth = 2.0
        UIColor.red.set()
        //镂空型
        excircle.stroke()
        excircle.close()
        
        let fillPath = UIBezierPath(arcCenter: center, radius: radius - 2, startAngle: startAngle, endAngle: endAngle, clockwise: true)
        UIColor.green.set()
        //绘制路径
//        fillPath.addLine(to: center)
        //填充
        fillPath.fill() 
        fillPath.close()
    }
    
    ///提示 label
    func setLabel() {
        progressLabel.bounds = bounds
        progressLabel.center = CGPoint(x: bounds.size.width * 0.5, y: bounds.size.height * 0.5)
        progressLabel.textAlignment = .center
        progressLabel.text = String(format: "%.2f%%", progress * 100)
        self.addSubview(progressLabel)
    }
    
    
}


extension BallProgress {
    ///圆边进度条
    func yuanxingtu() {
        setLabel()
        //获取上下文
        let ctx = UIGraphicsGetCurrentContext()
        
        /*
         1.center: CGPoint  中心点坐标
         2.radius: CGFloat  半径
         3.startAngle: CGFloat 起始点所在弧度
         4.endAngle: CGFloat   结束点所在弧度
         5.clockwise: Bool     是否顺时针绘制
         7.画圆时，没有坐标这个概念，根据弧度来定位起始点和结束点位置。M_PI即是圆周率。画半圆即(0,M_PI),代表0到180度。全圆则是(0,M_PI*2)，代表0到360度
         */        
        let center = CGPoint(x: bounds.size.width * 0.5, y: bounds.size.height * 0.5)
        let radiu = bounds.size.width * 0.5 - 10
        let start = -CGFloat(Double.pi / 2)
        let angle = progress * .pi * 2
        let endA = start + angle
        
        //        //画笔颜色
        //        ctx?.setStrokeColor(UIColor.gray.cgColor)
        //        //画笔宽度
        //        ctx?.setLineWidth(5)
        
        let path = UIBezierPath(arcCenter: center, radius: radiu, startAngle: start, endAngle: endA, clockwise: true)
        
        //把路径添加到上下文当中
        ctx?.addPath(path.cgPath)
        //把上下文的内容渲染到 view 的layer上 绘制路径
        ctx?.strokePath()
        path.close()
    }
}
