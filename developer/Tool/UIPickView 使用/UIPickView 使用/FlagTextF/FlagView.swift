//
//  FlagView.swift
//  UIPickView 使用
//
//  Created by Soul Ai on 15/2/2019.
//  Copyright © 2019 Soul Ai. All rights reserved.
//

import UIKit

class FlagView: UIView {

    @IBOutlet weak var nameL: UITextField!
    @IBOutlet weak var iconImageV: UIImageView!
    
    var item : FlagItem!
    
    class func flagView() -> UIView{
        return Bundle.main.loadNibNamed("FlagView", owner: nil, options: nil)?.last as! FlagView
    }
    
    
}
