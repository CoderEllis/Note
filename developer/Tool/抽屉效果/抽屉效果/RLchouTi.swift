//
//  ViewController.swift
//  抽屉效果
//
//  Created by Soul Ai on 19/2/2019.
//  Copyright © 2019 Soul Ai. All rights reserved.
//

import UIKit

//左右抽屉选择

private let screenWidth = UIScreen.main.bounds.size.width

class RLchouTi: UIViewController {
    
    //只读属性
    private(set) var leftV : UIView!
    private(set) var rightV : UIView!
    private(set) var mainV : UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //添加视图子控件
        setUP()
        
        let pan = UIPanGestureRecognizer(target: self, action: #selector(pan(_:)))
        mainV.addGestureRecognizer(pan)
        
        //给控制器的View添加点按手势
        let tap = UITapGestureRecognizer(target: self, action: #selector(tap(_:)))
        self.view.addGestureRecognizer(tap)
    }
    
    
    @objc func tap(_ tap : UITapGestureRecognizer){
        UIView.animate(withDuration: 0.5) { 
            self.mainV.frame = self.view.bounds
        }
    }
    
    
    
    let targetR: CGFloat = screenWidth * 0.8
    let targetL: CGFloat = -(screenWidth * 0.8)
    @objc func pan(_ pan : UIPanGestureRecognizer) {
        //获取偏移量
        let transP = pan.translation(in: mainV)
        //为什么不使用transform,是因为我们还要去修改高度,使用transform,只能修改,x,y
        //        mainV.transform = CGAffineTransform(translationX: transP.x, y: 0)
        
        mainV.frame = self.frameWithOffsetX(transP.x)
        
        //判断拖动的方向
        if mainV.frame.origin.x > 0 {
            //向右
            rightV.isHidden = true
        } else if mainV.frame.origin.x < 0{
            //向左
            rightV.isHidden = false
        }
        
        //当手指松开时,做自动定位.
        var traget: CGFloat = 0
        if pan.state == UIGestureRecognizer.State.ended {
            
            if mainV.frame.origin.x > screenWidth * 0.5 {
                //1判断在右侧
                //当前View的x有没有大于屏幕宽度的一半,大于就是在右侧
                traget = targetR
                
            } else if mainV.frame.maxX < screenWidth * 0.5{
                //2.判断在左侧
                //当前View的最大的x有没有小于屏幕宽度的一半,小于就是在左侧
                traget = 0//2.判断在左侧
                //当前View的最大的x有没有小于屏幕宽度的一半,小于就是在左侧
            }
            
            //计算当前mainV的frame.
            let offset = traget - mainV.frame.origin.x
            UIView.animate(withDuration: 0.5) { 
                self.mainV.frame = self.frameWithOffsetX(offset)
            }
            
        }
        
        //复位
        pan.setTranslation(CGPoint.zero, in: mainV)
    }
    
    
    let maxY : CGFloat = 100.0
    //根据偏移量计算MainV的frame
    func frameWithOffsetX(_ offsetX : CGFloat) -> CGRect {
        print(offsetX)
        
        var frame = self.mainV.frame
        print(frame.origin.x)
        frame.origin.x += offsetX
        
        //当拖动的View的x值等于屏幕宽度时,maxY为最大,最大为100
        // 375 * 100 / 375 = 100
        
        //对计算的结果取绝对值
        let y = abs(frame.origin.x * maxY / screenWidth)
        frame.origin.y = y
        
        //屏幕的高度减去两倍的Y值
        frame.size.height = UIScreen.main.bounds.size.height - (frame.origin.y * 2)
        
        return frame
        
    }
    
    
    func setUP() {
        leftV = UIView(frame: self.view.bounds)
        leftV.backgroundColor = UIColor.blue
        view.addSubview(leftV)
        
        rightV = UIView(frame: self.view.bounds)
        rightV.backgroundColor = UIColor.green
        view.addSubview(rightV)
        
        mainV = UIView(frame: self.view.bounds)
        mainV.backgroundColor = UIColor.red
        view.addSubview(mainV)
    }
    
}

