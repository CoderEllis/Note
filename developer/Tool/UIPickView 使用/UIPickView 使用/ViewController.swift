//
//  ViewController.swift
//  UIPickView 使用
//
//  Created by Soul Ai on 15/2/2019.
//  Copyright © 2019 Soul Ai. All rights reserved.
//


import UIKit

class ViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var countryTextF: UITextField!
    @IBOutlet weak var birthDayTextF: UITextField!
    @IBOutlet weak var cityTextF: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        countryTextF.delegate = self
        birthDayTextF.delegate = self
        cityTextF.delegate = self
    }

    //是否允许开始编辑
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return true
    }
    
    //开始编辑时调用(成为第一响应者)
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
    }

    //是否允许结束编辑
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        return true
    }
    
    //当结束编辑时调用
    func textFieldDidEndEditing(_ textField: UITextField) {
        print("%s")
    }
    
    //是否允许改变文本框内容(拦截用户输入)
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return false
    }
}

