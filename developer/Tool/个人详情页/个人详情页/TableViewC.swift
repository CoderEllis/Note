//
//  TableViewC.swift
//  个人详情页
//
//  Created by Soul Ai on 18/2/2019.
//  Copyright © 2019 Soul Ai. All rights reserved.
//

import UIKit

private let ID = "cell"

class TableViewC: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(UITableViewCell.self, forCellReuseIdentifier: ID)
        
        //1.凡是在导航条下面的scrollView.默认会设置偏移量.UIEdgeInsetsMake(64, 0, 0, 0)
//        tableView.contentInset = UIEdgeInsets(top: 64, left: 0, bottom: 0, right: 0)
//        tableView.scrollIndicatorInsets = tableView.contentInset
        
        //不要自动设置偏移量
//        if #available(iOS 11.0, *) {
//            self.tableView.contentInsetAdjustmentBehavior = .never
//        } else {
//            automaticallyAdjustsScrollViewInsets = false
//        }
        
        
        //让导航条隐藏
//        self.navigationController?.navigationBar.isHidden = true
        
        //导航条或者是导航条上的控件设置透明度是没有效果.
        self.navigationController?.navigationBar.alpha = 0
        
        //设置导航条背景(必须得要使用默认的模式UIBarMetricsDefault)
        //当背景图片设置为Nil,系统会自动生成一张半透明的图片,设置为导航条背景
        
        //设置空图片让导航条隐藏
        self.navigationController?.navigationBar.setBackgroundImage(UIImage.init(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage.init()
        
        let header = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 200))
        header.backgroundColor = UIColor.red
        self.tableView.tableHeaderView = header
        
        print(tableView.frame)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 40
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ID, for: indexPath)
        cell.backgroundColor = indexPath.item % 2 == 0 ? UIColor.green : UIColor.blue
        cell.textLabel?.text = "WLL"
        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
