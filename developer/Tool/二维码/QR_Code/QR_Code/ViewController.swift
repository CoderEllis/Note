//
//  ViewController.swift
//  QR_Code
//
//  Created by Soul Ai on 14/11/2018.
//  Copyright © 2018 Soul Ai. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    let width = UIScreen.main.bounds.width
    let height = UIScreen.main.bounds.height
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.white
        
        let label = UILabel(frame: CGRect.init(x: 0, y: height/2 - 20, width: width, height: 40))
        
        label.text = "点击屏幕开始扫描"
        label.textAlignment = .center
        label.textColor = UIColor.black
        
        let imageView = UIImageView(frame: CGRect.init(x: width/2 - 30, y: label.frame.origin.y - 80, width: 60, height: 60))
        
        imageView.image = UIImage.init(named: "scanQR.png", in: Bundle(path: Bundle.main.path(forResource: "resource", ofType: "bundle")!), compatibleWith: nil)
        
        
        
        
        
        self.view.addSubview(imageView)
        self.view.addSubview(label)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let scanQRCodeVC = ScanQRCodeVC()
        navigationController?.pushViewController(scanQRCodeVC, animated: true)
        
    }
    
}

