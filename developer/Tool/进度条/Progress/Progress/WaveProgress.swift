//
//  WaveProgress.swift
//  DIY
//
//  Created by Soul Ai on 10/1/2019.
//  Copyright © 2019 Soul Ai. All rights reserved.
//

import UIKit

class WaveProgress: UIView { //波浪进度
    
    /** 进度 */
    var progress : CGFloat = 0 {
        didSet {
            setNeedsDisplay()
        }
    }
    
    //A:振幅，就是波峰的高度
    var waveA : CGFloat = 0 //0%时 振幅为0
    
    /** 角速度 */
    var waveP : CGFloat = 0.03
    
    /** 初相位 φ (x轴移动距离) */
    var waveX : CGFloat = 0
    
    /** 波浪高度 k (y轴移动距离) */
    var waveY : CGFloat = 0
    
    /** 水纹速度 */
    var waveSpeed : CGFloat = 0.08
    
    /** 水纹宽度 */
    var waveWidth : CGFloat = 0.0
    
    /** 波浪 */
    lazy var waveLayer = CAShapeLayer()
    
    /** 边框 */
    lazy var borderLayer = CAShapeLayer()
    
    /** 定时器 */
    lazy var disPlayLink = CADisplayLink()
    
    /** 进度显示 */
    lazy var progressLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setUI()
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        setLabel()
        waveY = (1 - progress) * bounds.size.height
        if (progress == 0.0 || progress == 1.0) {
            waveA = 0
        } else {
            waveA = 10
        }
        drawPath()
    }
    
    func setUI() {
        backgroundColor = UIColor.clear
        waveY = bounds.size.height //0%时 无
        waveWidth = bounds.size.width
        
        let center = CGPoint(x: bounds.size.width / 2, y: bounds.size.height / 2)
        let radius = bounds.size.width / 2
        let borderPath = UIBezierPath(arcCenter: center, radius: radius, startAngle: 0, endAngle: .pi * 2, clockwise: true)
        
        borderLayer.path = borderPath.cgPath
        borderLayer.fillColor = UIColor.clear.cgColor
        borderLayer.strokeColor = UIColor.black.cgColor
        layer.addSublayer(borderLayer)
        
        let maskLayer = CAShapeLayer()
        maskLayer.path = borderPath.cgPath
        layer.mask = maskLayer
        
        disPlayLink = CADisplayLink(target: self, selector: #selector(getCurrentWave))
        disPlayLink.add(to: RunLoop.main, forMode: .common)
        
        waveLayer.fillColor = UIColor(red: 41/255.0, green: 240/255.0, blue: 253/255.0, alpha: 0.8).cgColor
        waveLayer.strokeColor = UIColor.clear.cgColor
        layer.addSublayer(waveLayer)
    }
    
    @objc func getCurrentWave() {
        waveX +=  waveSpeed
        if (waveX > bounds.size.width * 2) {
            waveX = 0
        }
        drawPath()
    }
    
    func drawPath() {
        var y = waveY
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 0, y: y))
        // y=Asin(ωx+φ)+B，正弦函数
        for x in 0...Int(waveWidth) {
            y = waveA * sin(waveP * CGFloat(x) + waveX + 0.5) + waveY
            path.addLine(to: CGPoint(x: CGFloat(x), y: y))
            
        }
        
        path.addLine(to: CGPoint(x: waveWidth, y: bounds.size.height))
        path.addLine(to: CGPoint(x: 0, y: bounds.size.height))
        path.close()
        waveLayer.path = path.cgPath
    }
    
    ///提示 label
    func setLabel() {
        progressLabel.bounds = bounds
        progressLabel.center = CGPoint(x: bounds.size.width * 0.5, y: bounds.size.height * 0.5)
        progressLabel.textAlignment = .center
        progressLabel.text = String(format: "%.2f%%", progress * 100)
        self.addSubview(progressLabel)
    }
    
    deinit {
        disPlayLink.invalidate()
    }
    
}
