//
//  Protocols.swift
//  MyRx
//
//  Created by Maple on 2017/9/4.
//  Copyright © 2017年 Maple. All rights reserved.
//

#if !RX_NO_MODULE
    import RxSwift
    import RxCocoa
#endif

enum ValidationResult {
    case ok(message: String)
    case empty
    case validating
    case failed(message: String)
}

protocol GitHubAPI {
    func usernameAvailable(_ username: String) -> Observable<Bool>
    func signup(_ username: String, password: String) -> Observable<Bool>
}

protocol GitHubValidationService {
    func validateUsername(_ username: String) -> Observable<ValidationResult>
    func validatePassword(_ password: String) -> ValidationResult
    func validateRepeatedPassword(_ password: String, repeatedPassword: String) -> ValidationResult
}
















