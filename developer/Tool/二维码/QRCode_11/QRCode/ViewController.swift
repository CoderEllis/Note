//
//  ViewController.swift
//  QRCode
//
//  Created by Soul Ai on 4/11/2018.
//  Copyright © 2018 Soul Ai. All rights reserved.sourceImageView
//

import UIKit

class ViewController: UIViewController {

    @IBAction func qrCODE(_ sender: Any) {
        let sb = UIStoryboard(name: "QRCode", bundle: nil)
        let vc = sb.instantiateInitialViewController()
        present(vc!, animated: true, completion: nil)
    }
    
    
    @IBOutlet weak var sourceImageView: UIImageView!
    
    
    @IBAction func detecotorRQCode() {
        
        // .1 获取需要识别的图片
        guard let image = sourceImageView.image else {return}
        
        let result = QRCodeTool.detectorQRCodeImage(image: image, isDrawQRCodeFrame: true)
        
        // 结果字符串
        let strs = result.resultStrs
        
        // 描绘好边框的图片
        sourceImageView.image = result.resultImage
        
        let alertVC = UIAlertController(title: "结果", message: strs?.description, preferredStyle: UIAlertController.Style.alert)
        // 添加关闭行为
        let action = UIAlertAction(title: "关闭", style: UIAlertAction.Style.default) { (action: UIAlertAction) in
            self.dismiss(animated: true, completion: nil)
        }
        alertVC.addAction(action)
        
        present(alertVC, animated: true, completion: nil)
    }



}

