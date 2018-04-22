//
//  ViewController.swift
//  Animations
//
//  Created by Jeremy Wang on 2018/4/16.
//  Copyright © 2018 Jeremy Wang. All rights reserved.
//

import UIKit

// A delay function
func delay(_ seconds: Double, completion: @escaping ()->Void) {
    DispatchQueue.main.asyncAfter(deadline: .now() + seconds, execute: completion)
}

class ViewController: UIViewController {
    
    // MARK: IB outlets
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var heading: UILabel!
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    
    @IBOutlet weak var cloud1: UIImageView!
    @IBOutlet weak var cloud2: UIImageView!
    @IBOutlet weak var cloud3: UIImageView!
    @IBOutlet weak var cloud4: UIImageView!
    
    // MARK: other variable
    let spinner = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
    let status = UIImageView(image: UIImage(named: "banner"))
    let label = UILabel()
    let messages = ["Connecting ...", "Authorizing ...", "Sending credentials ...", "Failed"]
    
    var statusPosition = CGPoint.zero
    
    
    
}


//MARK: viewcontroller  lifecycle methods
extension ViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //set up the UI
        loginButton.layer.cornerRadius = 8.0
        loginButton.layer.masksToBounds = true
        loginButton.isEnabled = true;
        
        spinner.frame = CGRect(x: -20.0, y: 6.0, width: 20.0, height: 20.0)
        spinner.startAnimating()
        spinner.alpha = 0.0
        loginButton.addSubview(spinner)
        
        status.isHidden = true
        status.center = loginButton.center
        view.addSubview(status)
        
        label.frame = CGRect(x: 0.0, y: 0.0, width: status.frame.size.width, height: status.frame.size.height)
        label.font = UIFont(name: "HelveticaNeue", size: 18.0)
        label.textColor = UIColor(red: 0.89, green: 0.38, blue: 0.0, alpha: 1.0)
        label.textAlignment = .center
        status.addSubview(label)
        
        //save the banner's initial position
        statusPosition = status.center;
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //将label和textfield移到左边一个屏幕宽度
        heading.center.x -= view.bounds.width;
        username.center.x -= view.bounds.width;
        password.center.x -= view.bounds.width;
        
        //对云形的图片---设置动画初始值
        cloud1.alpha = 0.0;
        cloud2.alpha = 0.0;
        cloud3.alpha = 0.0;
        cloud4.alpha = 0.0;
        
        //对button的处理--设置动画初始值
        loginButton.center.y += 30.0;
        loginButton.alpha = 0.0;
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //添加一个移动复位的动画
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
        
        /*
         usingSpringWithDamping: 弹簧的硬度或粘度(可以立即为阻力) 0.0 - 1.0
         initialSpringVelocity:  弹簧的初始速度 0.0 - 1，0
         */
        UIView.animate(withDuration: 0.5, delay: 0.5, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.0, options: [], animations: {
            self.loginButton.center.y -= 30.0;
            self.loginButton.alpha = 1.0;
        }, completion: nil);
        
        animateCloud(cloud: cloud1);
        animateCloud(cloud: cloud2);
        animateCloud(cloud: cloud3);
        animateCloud(cloud: cloud4);
    }
}

//MARK: IBAction method
extension ViewController {
    
    //Spring 动画
    @IBAction func login() {
        view.endEditing(true)
        
        UIView.animate(withDuration: 1.5, delay: 0.0, usingSpringWithDamping: 0.2, initialSpringVelocity: 0.0, options: [], animations: {
            self.loginButton.bounds.size.width += 90.0;
        }) { _ in
            self.loginButton.isEnabled = false;
        };
        
        UIView.animate(withDuration: 0.3, delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.0, options: [], animations: {
            self.loginButton.center.y += 60.0;
            self.loginButton.backgroundColor = UIColor(red: 0.85, green: 0.83, blue: 0.45, alpha: 1.0);
            self.spinner.center = CGPoint(
                x: 40.0,
                y: self.loginButton.frame.size.height/2);
            self.spinner.alpha = 1.0;
        }){_ in
            self.showMessage(index: 0);  //首次展示给一个初始值0;
        };
    }
}

//MARK: private methods
extension ViewController {
    
    //过渡动画
    private func showMessage(index: Int) {
        label.text = messages[index];
        
        /*
         • .transitionFlipFromLeft     //从左向右翻转
         • .transitionFlipFromRight    //从右向左翻转
         • .transitionFlipFromTop      //从顶部向下翻转
         • .transitionFlipFromBottom   //从底部向上翻转
         • .transitionCurlUp           //向日历一样的翻页-向上翻转
         • .transitionCurlDown         //向日历一样的翻页-向下翻转
         • .transitionCrossDissolve    //由透明到不透明改变
         */
        UIView.transition(with: status, duration: 0.33, options: [.curveEaseOut, .transitionCurlDown], animations: {
            self.status.isHidden = false
        }){_ in
            //transiton complete
            delay(2.0, completion: {
                if index < self.messages.count-1 {
                    self.removeMessage(index: index);
                } else {
                    //reset form
                    self.resetForm();
                }
            });
        };
    }
    
   private func removeMessage(index: Int) {
        UIView.animate(withDuration: 0.33, delay: 0.0, options: [], animations: {
            self.status.center.x += self.view.frame.size.width;
        }) { _ in
            self.status.isHidden = true;
            self.status.center = self.statusPosition;
            
            self.showMessage(index: index+1);  //对index每次加1，进行数组遍历，知道展示出所有数据
        };
    }
    
    private func resetForm() {
        //banner 复位
        UIView.animate(withDuration: 0.2, delay: 0.0, options: [.curveEaseOut, .transitionCurlUp], animations: {
            self.status.isHidden = true;
            self.status.center = self.statusPosition;
        }, completion:nil );
        
        //spinner 和 button 复位
        UIView.animate(withDuration: 0.2, delay: 0.0, options: [], animations: {
            self.spinner.center = CGPoint(x: -20.0, y: 16.0);
            self.spinner.alpha = 0.0;
            self.loginButton.backgroundColor = UIColor(red: 0.63, green: 0.84, blue: 0.35, alpha: 1.0);
            self.loginButton.bounds.size.width -= 80.0;
            self.loginButton.bounds.origin.y -= 60.0;
        }, completion: nil);
    }
    
    private func animateCloud(cloud: UIImageView) {
        let cloudSpeed = (60.0 / view.frame.size.width);
        let cloudAnimationDuration = (view.frame.size.width - cloud.frame.origin.x) * cloudSpeed;
        UIView.animate(withDuration: TimeInterval(cloudAnimationDuration), delay: 0.0, options: .curveLinear, animations: {
            cloud.frame.origin.x = self.view.frame.size.width;
        }) { _ in
            cloud.frame.origin.x = -cloud.frame.size.width;
            self.animateCloud(cloud: cloud);
        };
    }
    
}

// MARK: UITextFieldDelegate
extension ViewController {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let nextField = (textField === username) ? password : username
        nextField?.becomeFirstResponder()
        return true
    }
}
