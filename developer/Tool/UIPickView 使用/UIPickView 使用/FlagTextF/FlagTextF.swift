//
//  ProvinceTextF.swift
//  UIPickView 使用
//
//  Created by Soul Ai on 15/2/2019.
//  Copyright © 2019 Soul Ai. All rights reserved.
//

import UIKit

class FlagTextF: UITextField, UIPickerViewDataSource, UIPickerViewDelegate {
    
    lazy var dataArray: Array<FlagItem> = { 
        let path = Bundle.main.path(forResource: "flags", ofType: "plist")!
        let array = NSArray(contentsOfFile: path)
        var tempArray : Array<FlagItem> = []
        for dic in array! {
            var item = FlagItem(dict: dic as! [String : Any])
            tempArray.append(item)
        }
        return tempArray
        
    }()
    
    var pick: UIPickerView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
    }
    
    required init?(coder aDecoder: NSCoder) { //xib构建控件时 这个一般做添加子控件
        super.init(coder: aDecoder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setUp()
    }
    
    func initwithText() {
        self.pickerView(self.pick!, didSelectRow: 0, inComponent: 0)
    }
    
    //初始化文本框
    func setUp() { 
        //创建UIPickView
        let pick = UIPickerView()
        pick.delegate = self
        pick.dataSource = self
        //修改文本框弹出键盘类型
        self.inputView = pick
        self.pick = pick
    }
    
    //总共有多少列
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    //每一列有多少行
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return dataArray.count
    }
    
    
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let flagView = FlagView.flagView()
        let item = dataArray[row]
        
        return flagView
    }
    
    
    //返回pickView的行高
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 80
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let item = dataArray[row]
        self.text = item.name
    }
    
}
