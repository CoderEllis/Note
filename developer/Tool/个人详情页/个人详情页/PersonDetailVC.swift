//
//  PersonDetailVC.swift
//  个人详情页
//
//  Created by Soul Ai on 18/2/2019.
//  Copyright © 2019 Soul Ai. All rights reserved.
//

import UIKit

private let ID = "cell"

let oriOfftY: CGFloat = -244
let oriHeight : CGFloat = 200
let navHei : CGFloat = 88 //88导航栏+导航条高度

class PersonDetailVC: UIViewController , UITableViewDelegate, UITableViewDataSource{
   
    

    @IBOutlet weak var heightConstr: NSLayoutConstraint!
    @IBOutlet weak var tableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(UITableViewCell.self, forCellReuseIdentifier: ID)
        tableView.delegate = self
        tableView.dataSource = self
        
        //1.凡是在导航条下面的scrollView.默认会设置偏移量.UIEdgeInsetsMake(64, 0, 0, 0)
        //        tableView.contentInset = UIEdgeInsets(top: 64, left: 0, bottom: 0, right: 0)
        //        tableView.scrollIndicatorInsets = tableView.contentInset
        
        //不要自动设置偏移量
        if #available(iOS 11.0, *) {
            self.tableView.contentInsetAdjustmentBehavior = .never
        } else {
            automaticallyAdjustsScrollViewInsets = false
        }
        
        
        //让导航条隐藏
//        navigationController?.navigationBar.isHidden = true
        
        //导航条或者是导航条上的控件设置透明度是没有效果.
//        navigationController?.navigationBar.alpha = 0
        
        //设置导航条背景(必须得要使用默认的模式UIBarMetricsDefault)
        //当背景图片设置为Nil,系统会自动生成一张半透明的图片,设置为导航条背景
        
        //设置空图片让导航条隐藏
        navigationController?.navigationBar.setBackgroundImage(UIImage.init(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage.init()
        tableView.contentInset = UIEdgeInsets(top: 244, left: 0, bottom: 0, right: 0)
        tableView.scrollIndicatorInsets = tableView.contentInset
        
        //设置标题
        let title = UILabel()
        title.text = "个人详情页"
        title.sizeToFit()
        title.textColor = UIColor(white: 0, alpha: 0)
        navigationItem.titleView = title
        
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        //求偏移量
        //当前点 - 最原始的点
//        print(scrollView.contentOffset.y)
        let offset = scrollView.contentOffset.y - oriOfftY
        print(offset)
        
        //设置背景图片 缩小跟随的时候裁剪掉 saperct fill  clip to bounds
        var h = oriHeight - offset
        
        if h < navHei {
            h = navHei
        }
        self.heightConstr.constant = h
        
        //根据透明度来生成图片
        //找最大值/
        
        var alpha: CGFloat = offset * 1 / (200 - navHei)
        if alpha >= 1 {
            alpha = 0.99
        }
        
        if let titleL = navigationItem.titleView as? UILabel {
            
            titleL.textColor = UIColor(white: 0, alpha: alpha)
        }
        
        let alphaColor = UIColor(white: 1, alpha: alpha)
        let alphaImage = self.imageWithColor(alphaColor)
        
        navigationController?.navigationBar.setBackgroundImage(alphaImage, for: .default)
        
    }
    
    //生成一张白色的图片//final关键字的作用是这个类或方法不希望被继承和重写
func imageWithColor(_ color: UIColor) -> UIImage? {
        
        let rect = CGRect(x: 0, y: 0, width: 1, height: 1)
        // 开启位图上下文
        UIGraphicsBeginImageContext(rect.size)
        
        // 获取位图上下文
        let context = UIGraphicsGetCurrentContext()
        
        // 使用color演示填充上下文
        context?.setFillColor(color.cgColor)
        
        // 渲染上下文
        context?.fill(rect)
        
        // 从上下文中获取图片
        let image = UIGraphicsGetImageFromCurrentImageContext()
        
        // 结束上下文
        UIGraphicsEndImageContext()
        return image
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 40
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ID, for: indexPath)    
        cell.textLabel?.text = "xxx??"
        cell.backgroundColor = indexPath.item % 2 == 0 ? UIColor.yellow : UIColor.cyan
        return  cell
    }

}
