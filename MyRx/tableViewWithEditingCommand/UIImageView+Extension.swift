//
//  UIImageView+Extension.swift
//  MyRx
//
//  Created by Maple on 2017/9/19.
//  Copyright © 2017年 Maple. All rights reserved.
//

import UIKit

extension UIImageView {
    
    func makeRoundedCorners(_ radius: CGFloat) {
        self.layer.cornerRadius = radius
        self.layer.masksToBounds = true
    }
    
    func makeRoundedCorners() {
        self.makeRoundedCorners(self.frame.size.width / 2)
    }
}
