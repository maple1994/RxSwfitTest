//
//  SimpleTableViewController.swift
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

class SimpleTableViewController: UIViewController, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let items = Observable.just(
            (0..<20).map { "\($0)" }
        )
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        items
            .bind(to: tableView.rx.items(cellIdentifier: "Cell", cellType: UITableViewCell.self)) {
                (row, element, cell) in
                cell.textLabel?.text = "\(element) @ row \(row)"
        }
        .disposed(by: disposeBag)
        
        tableView.rx
        .modelSelected(String.self)
            .subscribe(onNext: { value in
                DefaultWireframe.presentAlert("Tapped \(value)")
            })
        .disposed(by: disposeBag)
        
        tableView.rx
        .itemAccessoryButtonTapped
            .subscribe(onNext: { indexPath in
                DefaultWireframe.presentAlert("section-\(indexPath.section), row-\(indexPath.row)")
            })
        .disposed(by: disposeBag)
    }

}
