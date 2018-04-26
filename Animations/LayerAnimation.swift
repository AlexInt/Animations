//
//  LayerAnimation.swift
//  Animations
//
//  Created by Jeremy Wang on 2018/4/26.
//  Copyright © 2018 Jeremy Wang. All rights reserved.
//

import UIKit

extension ViewController {
    //将label和textfield移到左边一个屏幕宽度的动画
    func layerAnimationsForLabelAndTextField() {
        if TargetType.num == 2 {
            //CABasicAnimation is just a data model
            let flyRight = CABasicAnimation(keyPath: "position.x");
            flyRight.fromValue = -view.bounds.size.width/2;
            flyRight.toValue = view.bounds.size.width/2;
            flyRight.duration = 0.5;
            //fillMode属性允许您在其序列的开始和结束时控制动画的行为。
            /*
             kCAFillModeRemoved 这个是默认值,也就是说当动画开始前和动画结束后,动画对layer都没有影响,动画结束后,layer会恢复到之前的状态
             kCAFillModeForwards 当动画结束后,layer会一直保持着动画最后的状态
             kCAFillModeBackwards 这个和kCAFillModeForwards是相对的,就是在动画开始前,你只要将动画加入了一个layer,layer便立即进入动画的初始状态并等待动画开始.你可以这样设定测试代码,将一个动画加入一个layer的时候延迟5秒执行.然后就会发现在动画没有开始的时候,只要动画被加入了layer,layer便处于动画初始状态
             kCAFillModeBoth 理解了上面两个,这个就很好理解了,这个其实就是上面两个的合成.动画加入后开始之前,layer便处于动画初始状态,动画结束后layer保持动画最后的状态.
             */
            
            
            heading.layer.add(flyRight, forKey: nil);
            
            //set delay time for username animation to begin
            flyRight.beginTime = CACurrentMediaTime() + 0.3;
            
            /*
             根据经验法则:动画执行结束之后删除他，不要考虑使用fillMode属性，除非你想要达到的效果是不可能的。
             fillMode使您的UI元素失去它们的交互性，并使屏幕的显示出现失真*/
            //            flyRight.fillMode = kCAFillModeBoth;
            //            flyRight.isRemovedOnCompletion = false;
            username.layer.add(flyRight, forKey: nil);
            
            flyRight.beginTime = CACurrentMediaTime() + 0.4;
            password.layer.add(flyRight, forKey: nil);
            
            /*
             有时，您可能会在最初的动画值和最终的动画值之间得到奇怪的闪光odd flash,所以最好将他们设置一下
             */
            username.layer.position.x = view.bounds.size.width/2;
            password.layer.position.x = view.bounds.size.width/2;
        }
    }
    
    func cloudsLayerAnimation() {
        if TargetType.num == 2 {
            let clouds = [cloud1, cloud2, cloud3, cloud4];
            let fadeIn = CABasicAnimation(keyPath: "opacity");
            fadeIn.fromValue = 0.0;
            fadeIn.toValue = 1.0;
            // hide the clouds when the app starts.
            fadeIn.fillMode = kCAFillModeBackwards;
            
            for (idx, cloud) in clouds.enumerated() {
                fadeIn.beginTime = CACurrentMediaTime() + 0.5 + Double(idx) * 0.2;
                cloud?.layer.add(fadeIn, forKey: nil);
            }
            //        fadeIn.beginTime = CACurrentMediaTime() + 0.5;
            //        cloud1.layer.add(fadeIn, forKey: nil);
            //
            //        fadeIn.beginTime = CACurrentMediaTime() + 0.7;
            //        cloud2.layer.add(fadeIn, forKey: nil);
            //
            //        fadeIn.beginTime = CACurrentMediaTime() + 0.9;
            //        cloud3.layer.add(fadeIn, forKey: nil);
            //
            //        fadeIn.beginTime = CACurrentMediaTime() + 1.1;
            //        cloud4.layer.add(fadeIn, forKey: nil);
        }
    }
    
    func startToggleColorAndShape() {
        if TargetType.num == 2 {
            let tintColor = UIColor(red: 0.85, green: 0.83, blue: 0.45, alpha: 1.0);
            tintBackgroundColor(layer: loginButton.layer, toColor: tintColor);
            
            roundCorners(layer: loginButton.layer, toRadius: 25.0);
        }
    }
    
    func endToggleColorAndShape() {
        if TargetType.num == 2 {
            let tintColor = UIColor(red: 0.63, green: 0.84, blue: 0.35, alpha: 1.0);
            tintBackgroundColor(layer: self.loginButton.layer, toColor: tintColor);
            roundCorners(layer: self.loginButton.layer, toRadius: 10.0);
        }
    }
    
}
