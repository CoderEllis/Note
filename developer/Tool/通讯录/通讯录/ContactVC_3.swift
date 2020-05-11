//
//  ContactVC_3.swift
//  通讯录
//
//  Created by Soul Ai on 17/2/2019.
//  Copyright © 2019 Soul Ai. All rights reserved.
//

import UIKit

class ContactVC_3: UIViewController {

    @IBOutlet weak var nameText: UITextField!
    @IBOutlet weak var phoneText: UITextField!
    @IBOutlet weak var addBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //监听账号跟密码同时有值的时候,让登录按钮能够点击
        nameText.addTarget(self, action: #selector(textChange), for: .editingChanged)
        phoneText.addTarget(self, action: #selector(textChange), for: .editingChanged)
        
        textChange()
    }
    

    @objc func textChange() {
        addBtn.isEnabled = nameText.text!.count > 0 && phoneText.text!.count > 0
    }
    
    
    @IBAction func addBtnClick(_ sender: UIButton) {
        
        let contactItem = ContactItem()
        contactItem.name = self.nameText.text
        contactItem.phone = self.phoneText.text
        
        navigationController?.popViewController(animated: true)
    }
    
    //-(void)dealloc
    deinit {
        print("释放内存了")
    }
}

     

