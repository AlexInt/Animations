//
//  AnimationNavigationVC.swift
//  Animations
//
//  Created by Jeremy Wang on 2018/4/19.
//  Copyright © 2018 Jeremy Wang. All rights reserved.
//

import UIKit

class AnimationNavigationVC: UINavigationController {
    
    lazy var leftBarButton : UIButton = {
        let leftButton = UIButton(type: UIButtonType.custom);
        leftButton.frame = CGRect(x: 0, y: 0, width: 55, height: 26);
        leftButton.addTarget(self, action: #selector(popSelf), for: UIControlEvents.touchUpInside);
        
        let imgView = UIImageView(image: #imageLiteral(resourceName: "title_button_back"));
        leftButton.addSubview(imgView);
        imgView.frame = CGRect(x: 0, y: 5, width: 20, height: 22);
        return leftButton;
    }();
    
    override func viewDidLoad() {
        super.viewDidLoad();
        //导航栏背景色
        self.navigationBar.barTintColor = kMainThemeColor;        //标题颜色
        let dict:Dictionary = [kCTForegroundColorAttributeName: UIColor.red, kCTFontAttributeName : UIFont.systemFont(ofSize: 18)];
        self.navigationBar.titleTextAttributes = dict as [NSAttributedStringKey : Any];
        
        self.setNeedsStatusBarAppearanceUpdate();
    }
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        super.pushViewController(viewController, animated: animated);
        
        if (viewController.navigationController?.responds(to: #selector(getter: interactivePopGestureRecognizer)))! {
            viewController.navigationController?.interactivePopGestureRecognizer?.isEnabled = true;
            viewController.navigationController?.interactivePopGestureRecognizer?.delegate = nil;
        }
        
        //当控制器不是第一个子控制器
        if viewController != self.childViewControllers.first {
            viewController.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: self.leftBarButton);
            viewController.navigationItem.leftBarButtonItem?.imageInsets = UIEdgeInsetsMake(0, 0, 0, 0);
            //push 进来隐藏tabbar
            UIView.animate(withDuration: 0.2) {
                viewController.tabBarController?.tabBar.isHidden = true;
            };
        }
    }
    
}

//MARK: private methods
extension AnimationNavigationVC {
    private func setShadowLayer(view: UIView) {
        let layer = view.layer;
        layer.shadowOffset = CGSize(width: 0, height: 2);
        layer.shadowRadius = 3.0;
        layer.shadowColor = UIColor.black.cgColor;
        layer.shadowOpacity = 1.0;
    }
    
    @objc func popSelf() {
        self.popViewController(animated: true);
    }
}











