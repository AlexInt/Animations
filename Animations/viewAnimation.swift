//
//  ViewAnimation.swift
//  Animations
//
//  Created by Jeremy Wang on 2018/4/26.
//  Copyright © 2018 Jeremy Wang. All rights reserved.
//

import UIKit

extension ViewController {
    //将label和textfield移到左边一个屏幕宽度的动画
    func viewAnimationInitialValueSet() {
        if TargetType.num == 1 {
            heading.center.x -= view.bounds.width;
            username.center.x -= view.bounds.width;
            password.center.x -= view.bounds.width;
            
            //对云形的图片---设置动画初始值
            cloud1.alpha = 0.0;
            cloud2.alpha = 0.0;
            cloud3.alpha = 0.0;
            cloud4.alpha = 0.0;
        }
    }
    
    func showViewAnimation() {
        if TargetType.num == 1 { //UIViewAnimation excute
            //添加一个移动复位的动画(view animation时)
            UIView.animate(withDuration: 0.5) {
                self.heading.center.x += self.view.bounds.width;
            };
            //[] means no special options
            //[] 空数组意味着没有需要指定的动画定制选项。
            UIView.animate(withDuration: 0.5, delay: 0.3, options: [], animations: {
                self.username.center.x += self.view.bounds.width;
            }, completion: nil);
            /*
             UIViewAnimationOptions
             .repeat : 重复执行animations闭包中的代码
             .autoreverse : 对动画的轨迹进行反向运动
             两个一起可以构成一种来回不断移动的动画效果
             options参数的数组中有一个元素是可以直接写一个元素，而不必写[]包围这个元素
             */
            //.repeat, .autoreverse, .curveEaseIn
            UIView.animate(withDuration: 0.5, delay: 0.4, options: [], animations: {
                self.password.center.x += self.view.bounds.width;
            }, completion: nil);
            
            UIView.animate(withDuration: 0.5, delay: 0.5, options: [], animations: {
                self.cloud1.alpha = 1;
            }, completion: nil);
            UIView.animate(withDuration: 0.5, delay: 0.7, options: [], animations: {
                self.cloud2.alpha = 1;
            }, completion: nil);
            UIView.animate(withDuration: 0.5, delay: 0.9, options: [], animations: {
                self.cloud3.alpha = 1;
            }, completion: nil);
            UIView.animate(withDuration: 0.5, delay: 1.1, options: [], animations: {
                self.cloud4.alpha = 1;
            }, completion: nil);
        }
    }
    
    //button 颜色的改变
    func toggleColorForButton(login before: Bool) {
        if TargetType.num == 1 {
            if before {
                self.loginButton.backgroundColor = UIColor(red: 0.85, green: 0.83, blue: 0.45, alpha: 1.0);
            } else {
                self.loginButton.backgroundColor = UIColor(red: 0.63, green: 0.84, blue: 0.35, alpha: 1.0);
            }
        }
    }
}
