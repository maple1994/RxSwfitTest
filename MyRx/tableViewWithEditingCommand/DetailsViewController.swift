//
//  DetailsViewController.swift
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

class DetailsViewController: UIViewController {
    
    var user: User!
    let disposeBag = DisposeBag()

    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.makeRoundedCorners(40)
        let url = URL(string: user.imageURL)!
        let request = URLRequest(url: url)
        
        URLSession.shared.rx.data(request: request)
            .map {
                data in
                UIImage(data: data)
        }
        .observeOn(MainScheduler.instance)
        .catchErrorJustReturn(nil)
        .subscribe(imageView.rx.image)
        .disposed(by: disposeBag)
        
        label.text = user.firstName + " " + user.lastName
    }
}
