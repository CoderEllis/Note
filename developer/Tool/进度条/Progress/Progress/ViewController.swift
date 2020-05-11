//
//  ViewController.swift
//  Progress
//
//  Created by Soul Ai on 12/1/2019.
//  Copyright © 2019 Soul Ai. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    lazy var sectorProgress = SectorProgress()
    lazy var ballProgress = BallProgress()
    lazy var circleProgress = CircleProgress()
    
    lazy var gradientProgress = GradientProgress()
    
    var wveProgress : WaveProgress!
    
    lazy var temperatureMeter = TemperatureMeter()
    lazy var xProgressView = XProgressView()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
    } 
    
    

    @IBAction func silder(_ sender: UISlider) {
        sectorProgress.progress = CGFloat(sender.value) 
        ballProgress.progress = CGFloat(sender.value) 
        circleProgress.progress = CGFloat(sender.value)
        
        gradientProgress.progress = CGFloat(sender.value)
        wveProgress.progress = CGFloat(sender.value)
        
        temperatureMeter.progress = CGFloat(sender.value)
        xProgressView.setProgress(Int(sender.value * 100), animated: false)
        
    }
    
    
    @IBAction func btn() {
        xProgressView.removeFromSuperview()
    }
    
    
    
    func setUI() {
        view.addSubview(sectorProgress)
        sectorProgress.frame = CGRect(x: 10, y: 120, width: 100, height: 100)
        
        view.addSubview(ballProgress)
        ballProgress.frame = CGRect(x: 150, y: 120, width: 100, height: 100)
        
        view.addSubview(circleProgress)
        circleProgress.frame = CGRect(x: 300, y: 120, width: 100, height: 100)
        
        view.addSubview(gradientProgress)
        gradientProgress.frame = CGRect(x: 10, y: 300, width: 100, height: 100)
        
        wveProgress = WaveProgress(frame: CGRect(x: 200, y: 300, width: 100, height: 100))
        view.addSubview(wveProgress)
        
        
        temperatureMeter.frame = CGRect(x: 10, y: 500, width: 100, height: 100)
        view.addSubview(temperatureMeter)
        
        view.addSubview(xProgressView)
        xProgressView.frame = CGRect(x: 200, y: 500, width: 100, height: 100)
//        xProgressView.image = UIImage(named: "123")
    }
    
    
}

