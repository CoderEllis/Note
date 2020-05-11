//
//  easyDome.swift
//  UIPickView 使用
//
//  Created by Soul Ai on 16/2/2019.
//  Copyright © 2019 Soul Ai. All rights reserved.
//

import UIKit

class easyDome: UIViewController, UIPickerViewDataSource,UIPickerViewDelegate {
    
    @IBOutlet weak var labe: UILabel!
    @IBOutlet weak var pickView: UIPickerView!
    
    lazy var dataArray : NSArray = {
        let path = Bundle.main.path(forResource: "foods", ofType: "plist")
        let array = NSArray(contentsOfFile: path!)
        return array!
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        pickView.delegate = self
        pickView.dataSource = self
        pickerView(pickView, didSelectRow: 0, inComponent: 0)
    }
    

    //展示多少列
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return dataArray.count
    }
    
    //每一列展示多少行
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        let array = dataArray[component] as! NSArray
        return array.count
    }
    
    //每一列的每一行展示什么内容
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let array = dataArray[component] as! NSArray
        return array[row] as? String
    }
    
    //当前选中的是哪一列的哪一行
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let title = dataArray[component] as! NSArray
        self.labe.text = title[row] as? String
    }

}
