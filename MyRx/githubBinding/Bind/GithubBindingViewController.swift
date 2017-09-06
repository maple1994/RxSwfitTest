//
//  GithubBindingViewController.swift
//  MyRx
//
//  Created by Maple on 2017/9/3.
//  Copyright © 2017年 Maple. All rights reserved.
//

import UIKit
#if !RX_NO_MODULE
import RxCocoa
import RxSwift
#endif

class GithubBindingViewController: UIViewController {
    
    @IBOutlet weak var usernameOutlet: UITextField!
    @IBOutlet weak var usernameValidationOutlet: UILabel!
    
    @IBOutlet weak var passwordOutlet: UITextField!
    @IBOutlet weak var passwordValidationOutlet: UILabel!
    
    @IBOutlet weak var repeatedPasswordOutlet: UITextField!
    @IBOutlet weak var repeatedPasswordValidationOutlet: UILabel!
    
    @IBOutlet weak var signupOutlet: UIButton!
    @IBOutlet weak var signingUpOulet: UIActivityIndicatorView!

    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let viewModel = GithubSignupViewModel1(
            input: (
            username: usernameOutlet.rx.text.orEmpty.asObservable(),
            password: passwordOutlet.rx.text.orEmpty.asObservable(),
            repeatedPassword: repeatedPasswordOutlet.rx.text.orEmpty.asObservable(),
            loginTaps: signupOutlet.rx.tap.asObservable()),
            dependency: (
                API: GitHubDefaultAPI.shareAPI,
                validationService: GitHubDefaultValidationService.sharedValidationService,
                wireframe: DefaultWireframe.shared
        ))
        
        viewModel.signupEnabled
            .subscribe(onNext: { [weak self] valid in
                self?.signupOutlet.isEnabled = valid
                self?.signupOutlet.alpha = valid ? 1.0 : 0.5
            })
        .disposed(by: disposeBag)
        
        viewModel.validateUsername
        .bind(to: usernameValidationOutlet.rx.validationResult)
        .disposed(by: disposeBag)
        
        viewModel.validatePassword
        .bind(to: passwordValidationOutlet.rx.validationResult)
        .disposed(by: disposeBag)
        
        viewModel.validatePasswordRepeated
        .bind(to: repeatedPasswordValidationOutlet.rx.validationResult)
        .disposed(by: disposeBag)
        
        viewModel.signedIn
            .subscribe(onNext: { signedIn in
                print("User signed in \(signedIn)")
            })
        .disposed(by: disposeBag)
        
        viewModel.signingIn
        .bind(to: signingUpOulet.rx.isAnimating)
        .disposed(by: disposeBag)
        
        let tapBackground = UITapGestureRecognizer()
        tapBackground.rx.event
            .subscribe(onNext: { [weak self] _ in
                self?.view.endEditing(true)
            })
        .disposed(by: disposeBag)
        view.addGestureRecognizer(tapBackground)
    }

}

extension Reactive where Base: UILabel {
    var validationResult: UIBindingObserver<Base, ValidationResult> {
        return UIBindingObserver(UIElement: base, binding: { (label, result) in
            label.textColor = result.textColor
            label.text = result.description
        })
    }
}












