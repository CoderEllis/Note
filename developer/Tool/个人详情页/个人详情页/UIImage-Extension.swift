//
//  UIImage(extension).swift
//  个人详情页
//
//  Created by Soul Ai on 18/2/2019.
//  Copyright © 2019 Soul Ai. All rights reserved.
//

import UIKit

extension UIImage {
    convenience init(color: UIColor) {
        self.init()
        let rect = CGRect(x: 0, y: 0, width: 1, height: 1)
        // 开启位图上下文
        UIGraphicsBeginImageContext(rect.size)
        
        // 获取位图上下文
        let context = UIGraphicsGetCurrentContext()
    
        // 使用color演示填充上下文
        context?.setFillColor(color.cgColor)
        
        // 渲染上下文
        context?.fill(rect)
        
        // 从上下文中获取图片
        _ = UIGraphicsGetImageFromCurrentImageContext()
        
        // 结束上下文
        UIGraphicsEndImageContext()
        
    }
    
    
}

