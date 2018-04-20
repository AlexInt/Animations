//
//  KeyFrameViewController.swift
//  Animations
//
//  Created by Jeremy Wang on 2018/4/20.
//  Copyright © 2018 Jeremy Wang. All rights reserved.
//

import UIKit
import QuartzCore

// A delay function
func delay(seconds: Double, completion: @escaping ()-> Void) {
    DispatchQueue.main.asyncAfter(deadline: .now() + seconds, execute: completion)
}
class KeyFrameViewController: UIViewController {
    enum AnimationDirection: Int {
        case positive = 1
        case negative = -1
    }
    
    @IBOutlet var bgImageView: UIImageView!
    
    @IBOutlet var summaryIcon: UIImageView!
    @IBOutlet var summary: UILabel!
    
    @IBOutlet var flightNr: UILabel!
    @IBOutlet var gateNr: UILabel!
    @IBOutlet var departingFrom: UILabel!
    @IBOutlet var arrivingTo: UILabel!
    @IBOutlet var planeImage: UIImageView!
    
    @IBOutlet var flightStatus: UILabel!
    @IBOutlet var statusBanner: UIImageView!
    
    var snowView: SnowView!
    
    //MARK: view controller methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //adjust ui
        summary.addSubview(summaryIcon)
        summaryIcon.center.y = summary.frame.size.height/2
        
        //add the snow effect layer
        snowView = SnowView(frame: CGRect(x: -150, y:-100, width: 300, height: 50))
        let snowClipView = UIView(frame: view.frame.offsetBy(dx: 0, dy: 50))
        snowClipView.clipsToBounds = true
        snowClipView.addSubview(snowView)
        view.addSubview(snowClipView)
        
        //start rotating the flights
        changeFlight(to: londonToParis)
    }
    
}

//MARK: private methods
extension KeyFrameViewController {
    
    private func changeFlight(to data: FlightData, animated: Bool = false) {
        // populate the UI with the next flight's data
        summary.text = data.summary
        flightNr.text = data.flightNr
        gateNr.text = data.gateNr
        departingFrom.text = data.departingFrom
        arrivingTo.text = data.arrivingTo
        flightStatus.text = data.flightStatus
        if animated {
            planeDepart();
            fade(imageView: bgImageView, toImage: UIImage(named: data.weatherImageName)!, showEffects: data.showWeatherEffects);
            
            let direction: AnimationDirection = data.isTakingOff ? .positive : .negative;
            //航班号
            cubeTransition(label: flightNr, text: data.flightNr, direction: direction);
            //登机口
            cubeTransition(label: gateNr, text: data.gateNr, direction: direction);
            
            //For the departure label, create a horizontal movement;
            let offsetDeparting = CGPoint(x: CGFloat(direction.rawValue * 80),
                                          y: 0.0);
            moveLabel(label: departingFrom, text: data.departingFrom, offset: offsetDeparting);
            
            //for the arrival airport, create a vertical movement.
            let offsetArriving = CGPoint(x: 0.0,
                                         y: CGFloat(direction.rawValue * 50));
            moveLabel(label: arrivingTo, text: data.arrivingTo, offset: offsetArriving);
            
            cubeTransition(label: flightStatus, text: data.flightStatus, direction: direction);
            
            summarySwitch(to: data.summary);
            
        } else{
            bgImageView.image = UIImage(named: data.weatherImageName)
            snowView.isHidden = !data.showWeatherEffects
            
            flightNr.text = data.flightNr;
            gateNr.text = data.gateNr;
            
            departingFrom.text = data.departingFrom;  //出发地
            arrivingTo.text = data.arrivingTo;         //目的地
            
            flightStatus.text = data.flightStatus; //航班状态
        }
        
        // schedule next flight
        delay(seconds: 3.0) {
            self.changeFlight(to: data.isTakingOff ? parisToRome : londonToParis, animated: true)
        }
    }
    
    //背景图转换的动画
    private func fade(imageView: UIImageView, toImage: UIImage, showEffects: Bool) {
        UIView.transition(with: imageView, duration: 1.0, options: .transitionCrossDissolve, animations: {
            imageView.image = toImage;
        }, completion: nil);
        
        UIView.animate(withDuration: 1.0, delay: 0.0, options: .curveEaseOut, animations: {
            self.snowView.alpha = showEffects ? 1.0 : 0.0;
        }, completion: nil);
    }
    
    //航班和登机口号码的翻转动画
    private func cubeTransition(label: UILabel, text: String, direction: AnimationDirection) {
        let auxLabel = UILabel(frame: label.frame);
        auxLabel.text = text;
        auxLabel.font = label.font;
        auxLabel.textAlignment = label.textAlignment;
        auxLabel.textColor = label.textColor;
        auxLabel.backgroundColor = label.backgroundColor;
        
        /*
         首先计算辅助标签的垂直偏移量。方向的原始值为1或-1，这将为您提供适当的垂直偏移量来定位临时标签。
         接下来，您要调整辅助标签的转换(transform)，以创建一个假透视效果。当你把文本放在y轴上的时候，
         它看起来就像你正在看文本的平面一样。
         */
        let auxLabelOffset = CGFloat(direction.rawValue) * label.frame.size.height/2.0;
        auxLabel.transform = CGAffineTransform(translationX: 0.0, y: auxLabelOffset).scaledBy(x: 1.0, y: 0.1);
        //把辅助label添加在label同一层级的父视图上
        label.superview?.addSubview(auxLabel);
        
        UIView.animate(withDuration: 0.5, delay: 0.0, options: [], animations: {
            auxLabel.transform = .identity;
            label.transform = CGAffineTransform(translationX: 0.0, y: -auxLabelOffset).scaledBy(x: 1.0, y: 0.1);
        }) { _ in
            label.text = auxLabel.text;
            label.transform = .identity;
            
            auxLabel.removeFromSuperview();
        };
    }
    
    //出发和到达机场地点展示的动画
    private func moveLabel(label: UILabel, text: String, offset: CGPoint) {
        let auxLabel = UILabel(frame: label.frame);
        auxLabel.text = text;
        auxLabel.font = label.font;
        auxLabel.textAlignment = label.textAlignment;
        auxLabel.textColor = label.textColor;
        auxLabel.backgroundColor = .clear;
        
        auxLabel.transform = CGAffineTransform(translationX: offset.x, y: offset.y);
        auxLabel.alpha = 0;
        view.addSubview(auxLabel);
        
        UIView.animate(withDuration: 0.5, delay: 0.0, options: .curveEaseIn, animations: {
            label.transform = CGAffineTransform(translationX: offset.x, y: offset.y);
            label.alpha = 0.0;
        }, completion: nil);
        
        UIView.animate(withDuration: 0.25, delay: 0.0, options: .curveEaseIn, animations: {
            auxLabel.transform = .identity;
            auxLabel.alpha = 1.0;
        }) { _ in
            //clean up
            auxLabel.removeFromSuperview();
            label.text = text;
            label.alpha = 1.0;
            label.transform = .identity;
        };
    }
    
    //飞机离开->回来的动画
    private func planeDepart() {
        let originalCenter = planeImage.center;
        UIView.animateKeyframes(withDuration: 1.5, delay: 0.0, options: [], animations: {
            //add key frame
            /*
             RelativeStartTime  相对开始时间，相对上面的duration : 1.5; 10%就是0.1，100%就是1.0
             relativeDuration   相对持续时间，相对上面的duration : 1.5; 25%就是0.25，100%就是1.0
             */
            //向右上方
            UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 0.25, animations: {
                self.planeImage.center.x += 80.0;
                self.planeImage.center.y -= 10.0;
            });
            //旋转
            UIView.addKeyframe(withRelativeStartTime: 0.1, relativeDuration: 0.4, animations: {
                self.planeImage.transform = CGAffineTransform(rotationAngle: -.pi/8);
            });
            //隐藏
            UIView.addKeyframe(withRelativeStartTime: 0.25, relativeDuration: 0.25, animations: {
                self.planeImage.center.x += 100.0;
                self.planeImage.center.y -= 50.0;
                self.planeImage.alpha = 0.0;
            });
            //将飞机的位置放置在左边，但隐身
            UIView.addKeyframe(withRelativeStartTime: 0.51, relativeDuration: 0.01, animations: {
                self.planeImage.transform = .identity;
                self.planeImage.center = CGPoint(x: 0.0,
                                                 y: originalCenter.y);
            });
            //逐渐出现
            UIView.addKeyframe(withRelativeStartTime: 0.55, relativeDuration: 0.45, animations: {
                self.planeImage.alpha = 1.0;
                self.planeImage.center = originalCenter;
            });
        }, completion: nil);
    }
    
    //处理顶部日期的上升和下降动画
    private func summarySwitch(to text: String) {
        let summaryCenter = summary.center;
        UIView.animateKeyframes(withDuration: 1.0, delay: 0.0, options: [], animations: {
            
            UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 0.45, animations: {
                self.summary.center.y -= 100.0;
            });
            
            UIView.addKeyframe(withRelativeStartTime: 0.5, relativeDuration: 0.45, animations: {
                self.summary.center = summaryCenter;
            });
        }, completion: nil);
        
        delay(0.5) {
            self.summary.text = text;
        }
    }
    
}

