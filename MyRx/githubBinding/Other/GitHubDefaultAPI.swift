//
//  GitHubDefaultAPI.swift
//  MyRx
//
//  Created by Maple on 2017/9/4.
//  Copyright © 2017年 Maple. All rights reserved.
//

#if !RX_NO_MODULE
    import RxSwift
    import RxCocoa
#endif
import Foundation

class GitHubDefaultValidationService: GitHubValidationService {
    
    let API: GitHubAPI
    let minPasswordCount = 5
    
    static let sharedValidationService = GitHubDefaultValidationService(API: GitHubDefaultAPI.shareAPI)
    
    init(API: GitHubAPI) {
        self.API = API
    }
    
    func validateUsername(_ username: String) -> Observable<ValidationResult> {
        if username.characters.count == 0 {
            return .just(.empty)
        }
        // this obviously won't be
        if username.rangeOfCharacter(from: CharacterSet.alphanumerics.inverted) != nil {
            return .just(.failed(message: "Username can only contain numbers or digits"))
        }
        
        let loadingValue = ValidationResult.validating
        
        return API.usernameAvailable(username)
        .map {
            available in
            if available {
                return .ok(message: "Username availabel")
            }else {
                return .failed(message: "Username already taken")
            }
        }.startWith(loadingValue)
    }
    func validatePassword(_ password: String) -> ValidationResult {
        let count = password.characters.count
        if count == 0 {
            return .empty
        }
        
        if count < minPasswordCount {
            return .failed(message: "Password must be at least \(minPasswordCount) characters")
        }
        
        return .ok(message: "Password acceptable")
    }
    func validateRepeatedPassword(_ password: String, repeatedPassword: String) -> ValidationResult {
        if repeatedPassword.characters.count == 0 {
            return .empty
        }
        
        if repeatedPassword == password {
            return .ok(message: "Password repeated")
        }
        else {
            return .failed(message: "Password different")
        }

    }
}

class GitHubDefaultAPI: GitHubAPI {
    
    static let shareAPI = GitHubDefaultAPI()
    
    /// 验证用户名
    func usernameAvailable(_ username: String) -> Observable<Bool> {
        // username.URLEscaped -> 中文编码化
        let url = URL(string: "https://github.com/\(username.URLEscaped)")!
        let request = URLRequest(url: url)
        return URLSession.shared.rx.response(request: request)
            .map { (response, _) in
                return response.statusCode == 404
            }
            .catchErrorJustReturn(false)
    }
    
    /// 模拟登录验证
    func signup(_ username: String, password: String) -> Observable<Bool> {
        let result = arc4random() % 5 == 0 ? false : true
        return Observable.just(result)
        .delay(1.0, scheduler: MainScheduler.instance)
    }
}

extension String {
    var URLEscaped: String {
        return self.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? ""
    }
}

extension ValidationResult {
    var isValid: Bool {
        switch self {
        case .ok:
            return true
        default:
            return false
        }
    }
}

extension ValidationResult {
    var textColor: UIColor {
        switch self {
        case .ok:
            return ValidationColors.okColor
        case .empty:
            return UIColor.black
        case .validating:
            return UIColor.black
        case .failed:
            return ValidationColors.errorColor
        }
    }
}

extension ValidationResult: CustomStringConvertible {
    var description: String {
        switch self {
        case let .ok(message):
            return message
        case .empty:
            return ""
        case .validating:
            return "validating ..."
        case let .failed(message):
            return message
        }
    }
}

struct ValidationColors {
    static let okColor = UIColor(red: 138.0 / 255.0, green: 221.0 / 255.0, blue: 109.0 / 255.0, alpha: 1.0)
    static let errorColor = UIColor.red
}

