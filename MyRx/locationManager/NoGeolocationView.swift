//
//  NoGeolocationView.swift
//  MyRx
//
//  Created by Maple on 2017/8/30.
//  Copyright © 2017年 Maple. All rights reserved.
//

import UIKit

class NoGeolocationView: UIView {
    
    class func instance() -> NoGeolocationView {
        return Bundle.main.loadNibNamed("NoGeolocationView", owner: nil, options: nil)?.last as! NoGeolocationView
    }
 
    @IBOutlet weak var openPreferenceButton2: UIButton!

}
