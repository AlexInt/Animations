//
//  ViewControllerExtension.swift
//  Animations
//
//  Created by Jeremy Wang on 2018/4/25.
//  Copyright © 2018 Jeremy Wang. All rights reserved.
//

import UIKit

extension ViewController {
    //将label和textfield移到左边一个屏幕宽度的动画
    func toggleAnimations(byType type: Int) {
        if type == 1 {
            heading.center.x -= view.bounds.width;
            username.center.x -= view.bounds.width;
            password.center.x -= view.bounds.width;
        }else if type == 2 {
            let flyRight = CABasicAnimation(keyPath: "position.x");
            flyRight.fromValue = -view.bounds.size.width/2;
            flyRight.toValue = view.bounds.size.width/2;
            flyRight.duration = 0.5;
            heading.layer.add(flyRight, forKey: nil);
            
            username.center.x -= view.bounds.width;
            password.center.x -= view.bounds.width;
        }
    }
    
     func showViewAnimation(byType type: Int) {
        if type == 1 {
            //添加一个移动复位的动画(view animation时)
            UIView.animate(withDuration: 0.5) {
                self.heading.center.x += self.view.bounds.width;
            };
        }else if type == 2 {
            //layer animation 不需要
            
        }
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
    }
}
