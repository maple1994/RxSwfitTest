//
//  CustomPickerViewController.swift
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

class CustomPickerViewController: UIViewController {

    @IBOutlet weak var pickerView: UIPickerView!
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Observable.just([[1, 2, 3], [5, 8, 13], [21, 34]])
        .bind(to: pickerView.rx.items(adapter: PickerViewViewAdapter()))
            .addDisposableTo(disposeBag)

        pickerView.rx.modelSelected(Int.self)
            .subscribe(onNext: { models in
                print(models)
            })
        .addDisposableTo(disposeBag)
    }
}

final class PickerViewViewAdapter
    : NSObject
    , UIPickerViewDataSource
    , UIPickerViewDelegate
    , RxPickerViewDataSourceType
, SectionedViewDataSourceType{
    
    typealias Element = [[CustomStringConvertible]]
    private var items: [[CustomStringConvertible]] = [[CustomStringConvertible]]()
    
    func model(at indexPath: IndexPath) throws -> Any {
        return items[indexPath.section][indexPath.row]
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return items.count
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return items[component].count
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let label = UILabel()
        label.text = items[component][row].description
        label.textColor = UIColor.orange
        label.font = UIFont.preferredFont(forTextStyle: .headline)
        label.textAlignment = .center
        return label
    }
    
    func pickerView(_ pickerView: UIPickerView, observedEvent: Event<Element>) {
        UIBindingObserver(UIElement: self) { (adapter, items) in
            adapter.items = items
            pickerView.reloadAllComponents()
        }.on(observedEvent)
    }
    
}
