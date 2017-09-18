//
//  SimplePickerViewController.swift
//  MyRx
//
//  Created by Maple on 2017/9/18.
//  Copyright © 2017年 Maple. All rights reserved.
//

import UIKit
#if !RX_NO_MODULE
    import RxSwift
    import RxCocoa
#endif

class SimplePickerViewController: UIViewController {

    @IBOutlet weak var pickerView3: UIPickerView!
    @IBOutlet weak var pickerView2: UIPickerView!
    @IBOutlet weak var pickerView1: UIPickerView!
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Observable.just([1, 2, 3])
            .bind(to: pickerView1.rx.itemTitles) { _, item in
                return "\(item)"
        }
        .addDisposableTo(disposeBag)
        
        pickerView1.rx.modelSelected(Int.self)
            .subscribe(onNext: { models in
                print("models selected 1: \(models)")
            })
        .addDisposableTo(disposeBag)
        
        Observable.just([1, 2, 3])
            .bind(to: pickerView2.rx.itemAttributedTitles) { _, item in
                return NSAttributedString(string: "\(item)", attributes: [
                    NSForegroundColorAttributeName: UIColor.cyan,
                    NSUnderlineStyleAttributeName: NSUnderlineStyle.styleDouble.rawValue
                    ])
        }
        .addDisposableTo(disposeBag)
        
        pickerView2.rx.modelSelected(Int.self)
            .subscribe(onNext: { models in
                print("models selected 2: \(models)")
            })
            .addDisposableTo(disposeBag)
        
        Observable.just([UIColor.red, UIColor.green, UIColor.blue])
            .bind(to: pickerView3.rx.items) { _, item, _ in
                let view = UIView()
                view.backgroundColor = item
                return view
        }
        .addDisposableTo(disposeBag)
        
        pickerView3.rx.modelSelected(UIColor.self)
            .subscribe(onNext: { models in
                print(models)
            })
        .addDisposableTo(disposeBag)
        
      /*
         Observable.just([UIColor.red, UIColor.green, UIColor.blue])
         .bind(to: pickerView3.rx.items) { _, item, _ in
         let view = UIView()
         view.backgroundColor = item
         return view
         }
         .disposed(by: disposeBag)
         
         pickerView3.rx.modelSelected(Int.self)
         .subscribe(onNext: { models in
         print("models selected 3: \(models)")
         })
         .disposed(by: disposeBag)

         */
    }


}
