//
//  SimpleSectionViewController.swift
//  MyRx
//
//  Created by Maple on 2017/9/19.
//  Copyright © 2017年 Maple. All rights reserved.
//

import UIKit
#if !RX_NO_MODULE
    import RxSwift
    import RxCocoa
#endif

class SimpleSectionViewController: UIViewController, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    let disposeBag = DisposeBag()
    let dataSource = RxTableViewSectionedReloadDataSource<SectionModel<String, Double>>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let dataSource = self.dataSource
        
        let items = Observable.just([
            SectionModel(model: "First Section", items: [
                1.0,
                2.0,
                3.0]),
            SectionModel(model: "Second Section", items: [
                1.0,
                2.0,
                3.0]),
            SectionModel(model: "Third Section", items: [
                1.0,
                2.0,
                3.0])
            ])
        dataSource.configureCell = { _, tv, indexPath, element in
            var cell = tv.dequeueReusableCell(withIdentifier: "Cell")
            if cell == nil {
                cell = UITableViewCell(style: .default, reuseIdentifier: "Cell")
            }
            cell?.textLabel?.text = "\(element) @ row \(indexPath.row)"
            return cell!
        }
        
        dataSource.titleForHeaderInSection = { dataSource, sectionIndex in
            return dataSource[sectionIndex].model
        }
        
        items
        .bind(to: tableView.rx.items(dataSource: dataSource))
        .disposed(by: disposeBag)
        
        tableView
        .rx
        .itemSelected
            .map { indexPath in
                return (indexPath, dataSource[indexPath])
        }
            .subscribe(onNext: { indexPath, model in
                DefaultWireframe.presentAlert("Tapped `\(model)` @ \(indexPath)")
            })
        .disposed(by: disposeBag)
        
        tableView.rx
        .setDelegate(self)
        .disposed(by: disposeBag)
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        return .none
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }

}
