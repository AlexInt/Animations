//
//  ViewController.swift
//  Package
//
//  Created by Jeremy Wang on 2018/4/20.
//  Copyright © 2018 Jeremy Wang. All rights reserved.
//

import UIKit

func delay(_ seconds: Double, completion: @escaping ()->Void) {
    DispatchQueue.main.asyncAfter(deadline: .now() + seconds, execute: completion)
}

class ViewController: UIViewController {
    
    //MARK: IB outlets
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var buttonMenu: UIButton!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet weak var menuHeightConstrait: NSLayoutConstraint!
    //MARK: further class variables
    
    var slider: HorizontalItemList!
    var isMenuOpen = false
    var items: [Int] = [5, 6, 7]
    var previousView: UIImageView?;
    
    
    //MARK: class methods
    
    @IBAction func actionToggleMenu(_ sender: AnyObject) {
        isMenuOpen = !isMenuOpen;
        
        //不使用IBOutlets属性进行约束的改变
        titleLabel.superview?.constraints.forEach({ (constraint) in
//            print("-> \(constraint.description)\n");
            /*
             Superview.CenterX = 1.0 * UILabel.CenterX + 0.0
             
             firstItem.firstAttribute = multiplier * secondItem.secondAttribute + constant
             */
            if constraint.firstItem === titleLabel && constraint.firstAttribute == .centerX {
                constraint.constant = isMenuOpen ? -100.0 : 0.0;
                return;
            }
            
            if constraint.identifier == "TitleCenterY" {
                constraint.isActive = false;
                //add new constraint
                //titleLabel.CenterY = titleLabel.superview.CenterY * 1.0 + 0.0
                let newConstraint = NSLayoutConstraint(item: titleLabel,
                                                       attribute: .centerY,
                                                       relatedBy: .equal,
                                                       toItem: titleLabel.superview!,
                                                       attribute: .centerY,
                                                       multiplier: isMenuOpen ? 0.67 : 1,
                                                       constant: 5.0);
                newConstraint.identifier = "TitleCenterY";
                newConstraint.isActive = true;
                
                return;
            }
        })
        
        menuHeightConstrait.constant = isMenuOpen ? 200.0 : 60.0;
        titleLabel.text = isMenuOpen ? "Select Item" : "Packing List";
        
        UIView.animate(withDuration: 1.0, delay: 0.0, usingSpringWithDamping: 0.4, initialSpringVelocity: 10.0, options: .curveEaseIn, animations: {
            self.view.layoutIfNeeded();
            
            let angle: CGFloat = self.isMenuOpen ? .pi/4 : 0.0;
            self.buttonMenu.transform = CGAffineTransform(rotationAngle: angle);
        }, completion: nil);
        
        if isMenuOpen {
            slider = HorizontalItemList(inView: view);
            slider.didSelectItem = { index in
                print("add\(index)");
                self.items.append(index);
                self.tableView.reloadData();
                self.actionToggleMenu(self);
            }
            self.titleLabel.superview!.addSubview(slider);
        } else {
            slider.removeFromSuperview();
        }
    }
    
    func showItem(_ index: Int) {
        print("tapped item \(index)")
        
        let imageView = UIImageView(image: UIImage(named: "summericons_100px_0\(index).png"));
        imageView.backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.5);
        imageView.layer.cornerRadius = 5.0;
        imageView.layer.masksToBounds = true;
        imageView.translatesAutoresizingMaskIntoConstraints = false;
        //if previous view exist, remove it
        if self.previousView != nil {
            self.previousView?.removeFromSuperview();
        }
        view.addSubview(imageView);
        self.previousView = imageView;
        
        //layout for imageView
        var conX:NSLayoutConstraint!;
        var conBottom:NSLayoutConstraint!;
        var conWidth:NSLayoutConstraint!;
        var conHeight:NSLayoutConstraint!;
        if #available(iOS 9.0, *) {
            conX = imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
            conBottom = imageView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: imageView.frame.height);
            conWidth = imageView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.33, constant: -50.0);
            conHeight = imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor);
        } else {
            //version lower than iOS 9.0
            conX = NSLayoutConstraint(item: imageView,
                                      attribute: .centerX,
                                      relatedBy: .equal,
                                      toItem: view,
                                      attribute: .centerX,
                                      multiplier: 1.0,
                                      constant: 0.0);
            conBottom = NSLayoutConstraint(item: imageView,
                                           attribute: .bottom,
                                           relatedBy: .equal,
                                           toItem: view,
                                           attribute: .bottom,
                                           multiplier: 1.0,
                                           constant: imageView.frame.height);
            conWidth = NSLayoutConstraint(item: imageView,
                                          attribute: .width,
                                          relatedBy: .equal,
                                          toItem: view,
                                          attribute: .width,
                                          multiplier: 0.33,
                                          constant: -50.0);
            conHeight = NSLayoutConstraint(item: imageView,
                                           attribute: .height,
                                           relatedBy: .equal,
                                           toItem: imageView,
                                           attribute: .height,
                                           multiplier: 1.0,
                                           constant: 0.0);
        };
        NSLayoutConstraint.activate([conX,conBottom,conWidth,conHeight]);
        
        //if don't do this outside of animation closure, animation will be drop from left top.
        view.layoutIfNeeded();
        UIView.animate(withDuration: 0.8, delay: 0.0, usingSpringWithDamping: 0.4, initialSpringVelocity: 0.0, options: [], animations: {
            conBottom.constant = -imageView.frame.size.height/2;
            conWidth.constant = 0.0;
        }, completion: nil);
        
        delay(1.0) {
            UIView.animate(withDuration: 0.3, animations: {
                imageView.alpha = 0.0;
                imageView.removeFromSuperview();
            });
        }
    }
}


let itemTitles = ["Icecream money", "Great weather", "Beach ball", "Swim suit for him", "Swim suit for her", "Beach games", "Ironing board", "Cocktail mood", "Sunglasses", "Flip flops"]

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    // MARK: View Controller methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView?.rowHeight = 54.0
    }
    
    // MARK: Table View methods
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1;
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as UITableViewCell;
        cell.accessoryType = .none;
        cell.textLabel?.text = itemTitles[items[indexPath.row]];
        cell.imageView?.image = UIImage(named: "summericons_100px_0\(items[indexPath.row]).png");
        return cell;
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true);
        showItem(items[indexPath.row]);
    }
}

