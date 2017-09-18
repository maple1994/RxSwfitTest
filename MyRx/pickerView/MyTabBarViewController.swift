//
//  MyTabBarViewController.swift
//  MyRx
//
//  Created by Maple on 2017/9/18.
//  Copyright © 2017年 Maple. All rights reserved.
//

import UIKit

class MyTabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let vc1 = SimplePickerViewController()
        let vc2 = CustomPickerViewController()
        
        vc1.tabBarItem.title = "Simple"
        vc2.tabBarItem.title = "Custom"
        addChildViewController(vc1)
        addChildViewController(vc2)
    }



}
