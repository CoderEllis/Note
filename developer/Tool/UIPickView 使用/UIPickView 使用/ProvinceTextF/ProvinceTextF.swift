//
//  ProvinceTextF.swift
//  UIPickView 使用
//
//  Created by Soul Ai on 15/2/2019.
//  Copyright © 2019 Soul Ai. All rights reserved.
//

import UIKit

class ProvinceTextF: UITextField, UIPickerViewDataSource, UIPickerViewDelegate {
    
    lazy var dataArray: Array<ProvinceItem> = { 
        let path = Bundle.main.path(forResource: "provinces", ofType: "plist")!
        let array = NSArray(contentsOfFile: path)
        var tempArray : Array<ProvinceItem> = []
        for dic in array! {
            var item = ProvinceItem(dict: dic as! [String : Any])
            tempArray.append(item)
        }
        return tempArray
        
    }()
    
    /** 当前选中省份的角标 */
    var proIndex = 0
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
        print("123")
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
        return 2
    }
    
    //每一列有多少行
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if (component == 0) {
            return dataArray.count
        } else {
            
            //当前选中的省份决定,当前选中省份下有多少个城市
            //当前选中的省份模型,返回当前选中的省份下的城市数量
            let item = self.dataArray[proIndex]
            return item.cities!.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if (component == 0) {
            let item = dataArray[row] 
            return item.name
        } else {
            let province = self.dataArray[proIndex]
            return province.cities?[row]
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if (component == 0) {
            self.proIndex = row
            pickerView.selectRow(0, inComponent: 1, animated: true)
            pickerView.reloadAllComponents()
        }
        
        //取出当前选中的省份
        let item = dataArray[self.proIndex]
        let provinceName = item.name!
        
        //获取第1列选中的行
        let cityRow = pickerView.selectedRow(inComponent: 1)
        let cityName = item.cities![cityRow]
        self.text = String(format: "%@,%@", provinceName,cityName)
    }
}
