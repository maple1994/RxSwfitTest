//
//  LocationViewController.swift
//  MyRx
//
//  Created by Maple on 2017/8/30.
//  Copyright © 2017年 Maple. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import CoreLocation

private extension Reactive where Base: UILabel {
    var coordinates: UIBindingObserver<Base, CLLocationCoordinate2D> {
        return UIBindingObserver(UIElement: base, binding: { (label, location) in
            label.text = "Lat: \(location.latitude)\nLon: \(location.longitude)"
        })
    }
}

/// 定位器权限监听
class LocationViewController: UIViewController {

    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "位置监听"
        
        noGeolocationView.frame = view.bounds
        view.addSubview(noGeolocationView)
        noGeolocationView.isHidden = true
        
        let service = GeolocationService.instance
        
        service.authorized
        .drive(noGeolocationView.rx.isHidden)
        .addDisposableTo(disposeBag)
        
        service.location
        .drive(showLocationLabel.rx.coordinates)
        .addDisposableTo(disposeBag)
        
        openPreferenceButton1.rx.tap
            .bind { [weak self] in
                self?.openAppPreferences()
        }
        .addDisposableTo(disposeBag)
        
        noGeolocationView.openPreferenceButton2.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.openAppPreferences()
            })
        .addDisposableTo(disposeBag)
    }
    
    private func openAppPreferences() {
        UIApplication.shared.openURL(URL(string: UIApplicationOpenSettingsURLString)!)
    }

    @IBOutlet weak var openPreferenceButton1: UIButton!
    @IBOutlet weak var showLocationLabel: UILabel!
    var noGeolocationView = NoGeolocationView.instance()
}
