//
//  Wireframe.swift
//  MyRx
//
//  Created by Maple on 2017/9/5.
//  Copyright © 2017年 Maple. All rights reserved.
//

#if !RX_NO_MODULE
import RxSwift
#endif
import UIKit

enum RetryResult {
    case retry
    case cancel
}

protocol WireFrame {
    func open(url: URL)
    func promptFor<Action: CustomStringConvertible>(_ message: String, cancelAction: Action, actions: [Action]) -> Observable<Action>
}

class DefaultWireframe: WireFrame {
    
    static let shared = DefaultWireframe()
    
    func open(url: URL) {
        UIApplication.shared.openURL(url)
    }
    
    private static func rootViewController() -> UIViewController {
        // cheating, I know
        return UIApplication.shared.keyWindow!.rootViewController!
    }
    
    static func presentAlert(_ message: String) {
        let alertView = UIAlertController(title: "RxExample", message: message, preferredStyle: .alert)
        alertView.addAction(UIAlertAction(title: "OK", style: .cancel) { _ in
        })
        rootViewController().present(alertView, animated: true, completion: nil)
    }
    
    func promptFor<Action: CustomStringConvertible>(_ message: String, cancelAction: Action, actions: [Action]) -> Observable<Action> {
        return Observable.create { (observer) -> Disposable in
            let alertView = UIAlertController(title: "RxExample", message: message, preferredStyle: .alert)
            alertView.addAction(UIAlertAction(title: cancelAction.description, style: .cancel) { _ in
                observer.on(.next(cancelAction))
            })
            for action in actions {
                alertView.addAction(UIAlertAction(title: action.description, style: .default) { _ in
                    observer.on(.next(action))
                })
            }
            DefaultWireframe.rootViewController().present(alertView, animated: true, completion: nil)
            return Disposables.create {
                alertView.dismiss(animated:false, completion: nil)
            }
        }
    }

}











