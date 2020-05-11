//
//  ProvinceTextF.swift
//  UIPickView 使用
//
//  Created by Soul Ai on 15/2/2019.
//  Copyright © 2019 Soul Ai. All rights reserved.
//

import UIKit

class test: UITextField, UIPickerViewDataSource, UIPickerViewDelegate {
    
    
    
    //所以地址数据集合
    var addressArray = [[String: AnyObject]]()
    
    //选择的省索引
    var provinceIndex = 0
    //选择的市索引
    var cityIndex = 0
    //选择的县索引
    var areaIndex = 0
    
    //选择器
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
    
    //初始化文本框
    func setUp() { 
        //创建UIPickView
        pick = UIPickerView()
        pick.delegate = self
        pick.dataSource = self
        //修改文本框弹出键盘类型
        self.inputView = pick
        dataA()
    }
    
    func dataA() {
        let plistPath = Bundle.main.path(forResource: "address", ofType: "plist")
        self.addressArray = NSArray(contentsOfFile: plistPath!) as! Array
        
        
    }
    
    
    //总共有多少列
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 3
    }
    
    //每一列有多少行
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch component {
        case 0:
            return addressArray.count
        case 1:
            let province = addressArray[provinceIndex]
            return province["cities"]!.count
        case 2:
            let province = self.addressArray[provinceIndex]
            let city = (province["cities"] as! NSArray)[cityIndex] as! [String: AnyObject]
            return city["areas"]!.count
        default:
            return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch component {
        case 0:
            return addressArray[row]["state"] as? String
        case 1:
            let province = addressArray[provinceIndex]
            let city = (province["cities"] as! NSArray)[row] as! [String: AnyObject]
            return city["city"] as? String
        case 2:
            let province = addressArray[provinceIndex]
            let city = (province["cities"] as! NSArray)[cityIndex] as! [String: AnyObject]
            return (city["areas"] as! NSArray)[row] as? String
        default:
            return ""
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        switch component {
        case 0:
            provinceIndex = row
            cityIndex = 0
            areaIndex = 0
            pickerView.selectRow(0, inComponent: 1, animated: false)
            pickerView.selectRow(0, inComponent: 2, animated: false)
            pickerView.reloadComponent(1)
            pickerView.reloadComponent(2)
        case 1:
            cityIndex = row
            areaIndex = 0
            pickerView.selectRow(0, inComponent: 2, animated: false)
            pickerView.reloadComponent(2)
        case 2:
            areaIndex = row    
        default:
            break
        }
        
        //获取选中的省
        let p = addressArray[provinceIndex]
        let province = p["state"] as! String
        
        //获取选中的市
        let c = (p["cities"] as! NSArray)[cityIndex] as! [String: AnyObject]
        let city = c["city"] as! String
        
        //获取选中的县（地区）
        var area = ""
        if (c["areas"] as! [String]).count > 0 {
            area = (c["areas"] as! [String])[areaIndex]
        }
        
        self.text = String(format: "%@,%@,%@", province,city,area)
        
    }
}
