//
//  APIWrappersViewController.swift
//  MyRx
//
//  Created by Maple on 2017/9/6.
//  Copyright © 2017年 Maple. All rights reserved.
//

import UIKit
import CoreLocation
#if !RX_NO_MODULE
    import RxSwift
    import RxCocoa
#endif

class APIWrappersViewController: UIViewController {
    
    @IBOutlet weak var debugLabel: UILabel!
    
    @IBOutlet weak var openActionSheet: UIButton!
    
    @IBOutlet weak var openAlertView: UIButton!
    
    var bbitem: UIBarButtonItem!
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    @IBOutlet weak var switcher: UISwitch!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var button: UIButton!
    
    @IBOutlet weak var slider: UISlider!
    
    @IBOutlet weak var textField: UITextField!
    
    @IBOutlet weak var datePicker: UIDatePicker!
    
    var mypan: UIPanGestureRecognizer!
    @IBOutlet weak var testPanView: UIView!
    
    @IBOutlet weak var textView: UITextView!
    
    let disposeBag = DisposeBag()
    let manager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bbitem = UIBarButtonItem(title: "Tap", style: .plain, target: nil, action: nil)
        navigationItem.rightBarButtonItem = bbitem
        
        mypan = UIPanGestureRecognizer()
        testPanView.addGestureRecognizer(mypan)
        
        datePicker.date = Date(timeIntervalSince1970: 0)
        // MARK: UIBarButtonItem
        bbitem.rx.tap
            .subscribe(onNext: { [weak self] x in
                self?.debug("UIBarButtonItem tapped")
            })
        .addDisposableTo(disposeBag)
        
        // MARK: UISegmentedControl
        // 这里的 <-> 是自定义的操作符，作用是将 segmentedControl.rx.value 绑定在 segmentedValue上
        let segmentedValue = Variable(0)
        _ = segmentedControl.rx.value <-> segmentedValue
        
        /*
         segmentedControl.rx.value
         .subscribe(onNext: { [weak self] x in
         self?.debug("segmentedControl value \(x)")
         })
         .addDisposableTo(disposeBag)  等价
         */
        segmentedValue.asObservable()
            .subscribe(onNext: { [weak self] x in
                self?.debug("segmentedControl value \(x)")
            })
        .addDisposableTo(disposeBag)
        
        // MARK: UISwitch
        switcher.rx.value
            .subscribe(onNext: { [weak self] x in
                self?.debug("UISwitch value \(x)")
            })
            .addDisposableTo(disposeBag)
        
        // MARK: UIActivityIndicatorView
         switcher.rx.value
            .bind(to: activityIndicator.rx.isAnimating)
        .addDisposableTo(disposeBag)
        
        // MARK: UIButton
        button.rx.tap
            .subscribe(onNext: { [weak self] x in
                self?.debug("UIButton tapped")
            })
        .addDisposableTo(disposeBag)
        
        // MARK: UISlider
        slider.rx.value
            .subscribe(onNext: { [weak self] x in
                self?.debug("UISlider value \(x)")
            })
            .addDisposableTo(disposeBag)
        
        // MARK: UIDatePicker
        datePicker.rx.value
            .subscribe(onNext: { [weak self] x in
                self?.debug("UIDatePicker date \(x)")
            })
            .addDisposableTo(disposeBag)
        
        // MARK: UITextField
        textField.rx.text.orEmpty.asObservable()
            .subscribe(onNext: { [weak self] x in
                self?.debug("UITextField text \(x)")
            })
            .addDisposableTo(disposeBag)
        
        // MARK: UIGestureRecognizer
        mypan.rx.event
            .subscribe(onNext: { [weak self] x in
                self?.debug("UIGestureRecognizer event \(x.state)")
            })
        .addDisposableTo(disposeBag)
        
        // MARK: UITextView
        textView.rx.text.orEmpty.asObservable()
            .subscribe(onNext: { [weak self] x in
                self?.debug("UITextView text \(x)")
            })
            .addDisposableTo(disposeBag)
    }
    
    func debug(_ string: String) {
        print(string)
        debugLabel.text = string
    }


}

















