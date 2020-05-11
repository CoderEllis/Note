//
//  ProvinceTextF.swift
//  UIPickView 使用
//
//  Created by Soul Ai on 15/2/2019.
//  Copyright © 2019 Soul Ai. All rights reserved.
//

import UIKit

class guandonmgsheng: UITextField, UIPickerViewDataSource, UIPickerViewDelegate {
    
    
//    lazy var dataArray: [[String: AnyObject]] = { 
//        let path = Bundle.main.path(forResource: "provinces", ofType: "plist")!
//        let array = NSArray(contentsOfFile: path)
//        return array as! [[String : AnyObject]]
//    }()
    
    
    var pickerData : NSDictionary! //全部数据
    var pickerProvincesData : Array<Any>! //省数据
    var pickerCitiesData : Array<Any>! //市数据
    
    var pick: UIPickerView?
    
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
        let pick = UIPickerView()
        pick.delegate = self
        pick.dataSource = self
        //修改文本框弹出键盘类型
        self.inputView = pick
        dataA()
    }
    
    func dataA() {
        let plistPath = Bundle.main.path(forResource: "provinces", ofType: "plist")
        let dict = NSDictionary(contentsOfFile: plistPath!)
        self.pickerData = dict
        self.pickerProvincesData = self.pickerData.allKeys 
        
        let seleteProvince = self.pickerProvincesData[0] as! NSString
        self.pickerCitiesData = self.pickerData[seleteProvince] as? Array<Any>
        
    }
    
    
    //总共有多少列
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    //每一列有多少行
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if (component == 0) {
            return self.pickerProvincesData.count
        } else {
            return self.pickerCitiesData.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if (component == 0) {
            return self.pickerProvincesData[row] as? String
        } else {
            return self.pickerCitiesData[row] as? String
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if (component == 0) {
            let seletedProvince = self.pickerProvincesData[row] as! String
            self.pickerCitiesData = self.pickerData[seletedProvince] as? Array<Any>
            self.pick?.reloadComponent(1)
        }
        let row1 = self.pick?.selectedRow(inComponent: 0)
        let row2 = self.pick?.selectedRow(inComponent: 1)
        let selected1 = self.pickerProvincesData[row1!] as! String
        let selected2 = self.pickerProvincesData[row2!] as! String
        self.text = String(format: "%@,%@", selected1,selected2)
        
    }
}
