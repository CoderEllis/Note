//
//  ProvinceItem.swift
//  UIPickView 使用
//
//  Created by Soul Ai on 15/2/2019.
//  Copyright © 2019 Soul Ai. All rights reserved.
//

import UIKit

class ProvinceItem: NSObject {
    @objc var cities : [String]?
    @objc var name : String?
    
    init(dict: [String: Any]) {
        super.init()
        setValuesForKeys(dict)
    }
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }
    
}
