//
//  GitHubSignUpViewModel2.swift
//  MyRx
//
//  Created by Maple on 2017/9/6.
//  Copyright © 2017年 Maple. All rights reserved.
//

#if !RX_NO_MODULE
    import RxSwift
    import RxCocoa
#endif

class GithubSignupViewModel2 {
    // outputs
    let validateUsername: Driver<ValidationResult>
    let validatePassword: Driver<ValidationResult>
    let validatePasswordRepeated: Driver<ValidationResult>
    
    /// 是否可点击登录按钮
    /// Is signup button enabled
    let signupEnabled: Driver<Bool>
    
    /// 是否登录成功
    /// Has user signed in
    let signedIn: Driver<Bool>
    
    /// 是否登录中
    /// Is signing process in progress
    let signingIn: Driver<Bool>
    // end
    
    init(input: (
        username: Driver<String>,
        password: Driver<String>,
        repeatedPassword: Driver<String>,
        loginTaps: Driver<Void>
        ),
         dependency: (
        API: GitHubAPI,
        validationService: GitHubValidationService,
        wireframe: WireFrame
        )
        ){
        let API = dependency.API
        let validationService = dependency.validationService
        let wireframe = dependency.wireframe
        
        /**
         Notice how no subscribe call is being made.
         Everything is just a definition.
         
         Pure transformation of input sequences to output sequences.
         
         When using `Driver`, underlying observable sequence elements are shared because
         driver automagically adds "shareReplay(1)" under the hood.
         
         .observeOn(MainScheduler.instance)
         .catchErrorJustReturn(.Failed(message: "Error contacting server"))
         
         ... are squashed into single `.asDriver(onErrorJustReturn: .Failed(message: "Error contacting server"))`
         也就是使用 'Driver'的话，会自动帮帮我们添加shareReplay(1)，并且 .observeOn(MainScheduler.instance)
         .catchErrorJustReturn(.Failed(message: "Error contacting server")) 等语句，可以简洁的写为
         `.asDriver(onErrorJustReturn: .Failed(message: "Error contacting server"))`
         */
        
        /*
         validateUsername = input.username
         .flatMapLatest { username in
         return validationService.validateUsername(username)
         .observeOn(MainScheduler.instance)
         .catchErrorJustReturn(.failed(message: "Error contacting server"))
         }
         .shareReplay(1)
         对比一下，感受一下上面的注释
         */
        
        validateUsername = input.username
            .flatMapLatest { username in
                return validationService.validateUsername(username)
                .asDriver(onErrorJustReturn: .failed(message: "Error contacting server"))
        }
        
        validatePassword = input.password
            .map { password in
                return validationService.validatePassword(password)
            }
        
        validatePasswordRepeated = Driver.combineLatest(input.password, input.repeatedPassword, resultSelector: validationService.validateRepeatedPassword)
        
        let signingIn = ActivityIndicator()
        self.signingIn = signingIn.asDriver()
        
        let usernameAndPassword = Driver.combineLatest(input.username, input.password) { ($0, $1) }
        
        
        signedIn = input.loginTaps.withLatestFrom(usernameAndPassword)
            .flatMapLatest { (username, passwrod) in
                return API.signup(username, password: passwrod)
                .trackActivity(signingIn)
                .asDriver(onErrorJustReturn: false)
            }
            .flatMapLatest { (loggedIn) -> Driver<Bool> in
                let message = loggedIn ? "Mock: Signed in to GitHub." : "Mock: Sign in to GitHub failed"
                return wireframe.promptFor(message, cancelAction: "OK", actions: [])
                    .map{ _  in
                        loggedIn
                }.asDriver(onErrorJustReturn: false)
            }
        
        signupEnabled = Driver.combineLatest(
            validateUsername,
            validatePassword,
            validatePasswordRepeated,
            signedIn
        )   { username, password, repeatPassword, signingIn in
            return username.isValid &&
                password.isValid &&
                repeatPassword.isValid &&
                !signingIn
            }
            .distinctUntilChanged()
    }

}
