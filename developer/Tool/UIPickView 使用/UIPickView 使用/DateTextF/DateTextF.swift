
//
//  DateTextF.swift
//  UIPickView 使用
//
//  Created by Soul Ai on 15/2/2019.
//  Copyright © 2019 Soul Ai. All rights reserved.
//

import UIKit

class DateTextF: UITextField {

    var datePick : UIDatePicker?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setUp()
    }
    
    
    func setUp() {
        let datePick = UIDatePicker()
        //修改datePick日期模式
        datePick.datePickerMode = .date
        datePick.locale = Locale(identifier: "zh_CN")
        
        datePick.addTarget(self, action: #selector(dateChange(_:)), for: .valueChanged)
        
        self.inputView = datePick
        self.datePick = datePick
    }
    
    @objc func dateChange(_ datePick : UIDatePicker) {
        let fmt = DateFormatter()
        fmt.dateFormat = "yyyy-MM-dd"
        self.text = fmt.string(from: datePick.date)
        
    }}
