//
//  GithubSignupViewModel.swift
//  MyRx
//
//  Created by Maple on 2017/9/5.
//  Copyright © 2017年 Maple. All rights reserved.
//

#if !RX_NO_MODULE
    import RxSwift
    import RxCocoa
#endif

class GithubSignupViewModel1 {
    
    // outputs
    let validateUsername: Observable<ValidationResult>
    let validatePassword: Observable<ValidationResult>
    let validatePasswordRepeated: Observable<ValidationResult>
    
    /// 是否可点击登录按钮
    /// Is signup button enabled
    let signupEnabled: Observable<Bool>
    
    /// 是否登录成功
    /// Has user signed in
    let signedIn: Observable<Bool>
    
    /// 是否登录中
    /// Is signing process in progress
    let signingIn: Observable<Bool>
    // end
    
    init(input: (
        username: Observable<String>,
        password: Observable<String>,
        repeatedPassword: Observable<String>,
        loginTaps: Observable<Void>
        ),
         dependency: (
        API: GitHubAPI,
        validationService: GitHubValidationService,
        wireframe: WireFrame
        )
        ) {
        let API = dependency.API
        let validationService = dependency.validationService
        let wireframe = dependency.wireframe
        
        /**
         Notice how no subscribe call is being made.
         Everything is just a definition.
         
         Pure transformation of input sequences to output sequences.
         将input -> outpust
         */
        
        validateUsername = input.username
            .flatMapLatest { username in
                return validationService.validateUsername(username)
                .observeOn(MainScheduler.instance)
                    .catchErrorJustReturn(.failed(message: "Error contacting server"))
        }
        .shareReplay(1)
        
        validatePassword = input.password
            .map { password in
                return validationService.validatePassword(password)
        }
        .shareReplay(1)
        
//        validatePasswordRepeated = Observable.combineLatest(input.password, input.repeatedPassword) { (pwd, repeatPwd) -> ValidationResult in
//            return validationService.validateRepeatedPassword(pwd, repeatedPassword: repeatPwd)
//            }.shareReplay(1)
//      跟 ↓ 等价 resultSelector: 会按pwd, repeatedPwd顺序传入参数
        
        validatePasswordRepeated = Observable.combineLatest(input.password, input.repeatedPassword, resultSelector: validationService.validateRepeatedPassword)
            .shareReplay(1)
        
        
        
        let signingIn = ActivityIndicator()
        self.signingIn = signingIn.asObservable()
        
        let usernameAndPassword = Observable.combineLatest(input.username, input.password) { ($0, $1) }
        
        signupEnabled = Observable.combineLatest(
            validateUsername,
            validatePassword,
            validatePasswordRepeated,
            signingIn.asObservable()
        )   { username, password, repeatPassword, signingIn in
            return username.isValid &&
                password.isValid &&
                repeatPassword.isValid &&
                !signingIn
            }
            .distinctUntilChanged()
            .shareReplay(1)

        // http://reactivex.io/documentation/operators/combinelatest.html
        // loginTaps的事件与usernameAndPassword组合
        signedIn = input.loginTaps.withLatestFrom(usernameAndPassword)
        .flatMapLatest { (username, passwrod) in
            return API.signup(username, password: passwrod)
            .observeOn(MainScheduler.instance)
            .catchErrorJustReturn(false)
            .trackActivity(signingIn)
        }
        .flatMapLatest { (loggedIn) -> Observable<Bool> in
            let message = loggedIn ? "Mock: Signed in to GitHub." : "Mock: Sign in to GitHub failed"
            return wireframe.promptFor(message, cancelAction: "OK", actions: [])
            .map{ _  in
                loggedIn
            }
        }
        .shareReplay(1)
    }
    
}














