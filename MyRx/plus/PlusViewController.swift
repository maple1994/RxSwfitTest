//
//  PlusViewController.swift
//  MyRx
//
//  Created by Maple on 2017/8/29.
//  Copyright © 2017年 Maple. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class PlusViewController: UIViewController {

    @IBOutlet weak var resultLabel: UILabel!
    @IBOutlet weak var textField3: UITextField!
    @IBOutlet weak var textField2: UITextField!
    @IBOutlet weak var textField1: UITextField!
    let disposeBag = DisposeBag()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "加法"
        
        // 监听三个textField的text变化，然后进行累+
        Observable.combineLatest(textField1.rx.text.orEmpty, textField2.rx.text.orEmpty, textField3.rx.text.orEmpty) { (value1, value2, value3) -> Int in
            return (Int(value1) ?? 0) + (Int(value2) ?? 0) + (Int(value3) ?? 0)
            }.map({$0.description}) // 将Int -> String
            .bind(to: resultLabel.rx.text) // 绑定结果
        .disposed(by: disposeBag)
    }
}
