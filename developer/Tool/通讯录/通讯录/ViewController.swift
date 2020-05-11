//
//  ViewController.swift
//  通讯录
//
//  Created by Soul Ai on 17/2/2019.
//  Copyright © 2019 Soul Ai. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var accountTextF: UITextField!
    @IBOutlet weak var pwdTextF: UITextField!
    
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var remPwdSwitch: UISwitch!
    @IBOutlet weak var autoLoginSwitch: UISwitch!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //监听账号跟密码同时有值的时候,让登录按钮能够点击
        accountTextF.addTarget(self, action: #selector(textChange), for: .editingChanged)
        pwdTextF.addTarget(self, action: #selector(textChange), for: .editingChanged)
        
        //手动判断账号跟密码是否有值
        textChange()
    }
    
    @objc func textChange() {
        loginBtn.isEnabled = accountTextF.text!.count > 0 && pwdTextF.text!.count > 0
    }
    
    /**
     performSegueWithIdentifier底层实现
     1.到StoryBoard当中去查找有没有给定标识的segue.
     2.根据指定的标识,创建一个UIStoryboardSegue对象之后, 把当前的控制器,给它源控制器属性赋值(segue.sourceViewController).
     3.UIStoryboardSegue对象,再去创建它的目标控制器.给UIStoryboardSegue的目标控制器属性(segue.destinationViewController)赋值
     4.调用当前控制器prepareForSegue:方法,告诉用户,当前的线已经准备好了.
     5.[segue perform]
     [segue.sourceViewController.navigationController pushViewController:segue.destinationViewController animated:YES];
     */
    
    //准备跳转前调用
    //做一些传递数据.
    //传递数据(顺数数据)
    //1.数据接收的控制器(XMGContactVC_2)定义一个属性,来接收数据
    //2.数据的来源控制器要拿到数据接收的控制器.
    //3.给接收的控制器的接收数据的属性给它赋值.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        //要跳转的目标控制器
        print("\(segue.destination)")
        //源控制器
        print("\(segue.source)")
        let contactVC = segue.destination as! TabVC
        contactVC.accountName = self.accountTextF.text
        
    }
    
    
    //登录按钮点击
    @IBAction func loginBtnClick(_ sender: UIButton) {
        //如果用户名跟密码正确,跳转到下一个界面
        //提醒用户正在登录
        //延时执行任务
        DispatchQueue.main.asyncAfter(deadline: .now()+0.5) { 
            if (self.accountTextF.text == "xmg" && self.pwdTextF.text == "123") {
                self.performSegue(withIdentifier: "contactVC", sender: nil)
            } else {
                print("用户名或密码错误❌")
            }
        }
        
        
    }
    
    //记住密码开关发生改变
    @IBAction func remPwdChange(_ sender: UISwitch) {
        if remPwdSwitch.isOn == false {
            autoLoginSwitch.setOn(false, animated: true)
        }
    }
    
    //自动登录开关发生改变
    @IBAction func autoLoginChange(_ sender: Any) {
        if autoLoginSwitch.isOn == true {
            remPwdSwitch.setOn(true, animated: true)
        }
    }
    
}

