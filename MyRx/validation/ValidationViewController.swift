//
//  ValidationViewController.swift
//  MyRx
//
//  Created by Maple on 2017/8/30.
//  Copyright © 2017年 Maple. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

let minimalUsernameLength = 5
let minimalPasswordLength = 5

/// 校验
class ValidationViewController: UIViewController {
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var usernameTipsLabel: UILabel!

    @IBOutlet weak var confirmButton: UIButton!
    @IBOutlet weak var pwdTipsLabel: UILabel!
    @IBOutlet weak var pwdTextField: UITextField!
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "检验"
        
        usernameTipsLabel.text = "Username has to be at least \(minimalUsernameLength) characters"
        pwdTipsLabel.text = "Password has to be at least \(minimalPasswordLength) characters"
        
        let usernameValid = usernameTextField.rx.text.orEmpty
        .map { (text) -> Bool in
            text.characters.count > minimalUsernameLength
        }.shareReplay(1)
        let pwdValid = pwdTextField.rx.text.orEmpty
            .map({ $0.characters.count > minimalPasswordLength })
        .shareReplay(1)
        let everyThingValid = Observable.combineLatest(usernameValid, pwdValid) { (bool1, bool2) -> Bool in
            return bool1 && bool2
        }.shareReplay(1)
        
        // 绑定
        usernameValid.bind(to: pwdTextField.rx.isEnabled)
        .addDisposableTo(disposeBag)
        usernameValid.bind(to: usernameTipsLabel.rx.isHidden)
        .addDisposableTo(disposeBag)
        pwdValid.bind(to: pwdTipsLabel.rx.isHidden)
        .addDisposableTo(disposeBag)
        everyThingValid.bind(to: confirmButton.rx.isEnabled)
        .addDisposableTo(disposeBag)

        // 监听点击
        confirmButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.showAlert()
            })
        .addDisposableTo(disposeBag)
    }
    
    func showAlert() {
        let alertView = UIAlertView(
            title: "弹窗",
            message: "测试",
            delegate: nil,
            cancelButtonTitle: "取消"
        )
        
        alertView.show()
    }
   

}
