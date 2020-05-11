//
//  TabVC.swift
//  通讯录
//
//  Created by Soul Ai on 17/2/2019.
//  Copyright © 2019 Soul Ai. All rights reserved.
//

import UIKit

class TabVC: UITableViewController {

    var accountName : String? {
        didSet {
            self.navigationItem.title = String(format: "%@的通讯录", accountName!)
        }
    }
    
    lazy var dataArray = NSMutableArray()
    
    var contactItem : ContactItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    
   //退出登录
    @IBAction func loginOut(_ sender: Any) {
        //第一步:创建控制器
        let alertVC = UIAlertController(title: "确定要退出嘛?", message: nil, preferredStyle: .actionSheet)
        //第二步:创建按钮
        let action = UIAlertAction(title: "取消", style: .cancel) { (_) in
            print("点击了取消")
        }
        
        let action1 = UIAlertAction(title: "确定", style: .destructive) { (_) in
            self.navigationController?.popViewController(animated: true)
        }
        alertVC.addAction(action)
        alertVC.addAction(action1)
        present(alertVC, animated: true, completion: nil)
        
    }
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }

    

}
