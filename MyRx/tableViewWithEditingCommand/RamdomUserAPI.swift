//
//  RamdomUserAPI.swift
//  MyRx
//
//  Created by Maple on 2017/9/19.
//  Copyright © 2017年 Maple. All rights reserved.
//

import Foundation
#if !RX_NO_MODULE
    import RxSwift
    import RxCocoa
#endif

class RandomUserAPI {
    static let shared = RandomUserAPI()
    
    private init() { }
    
    func getExampleUserResultSet() -> Observable<[User]> {
        let url = URL(string: "http://api.randomuser.me/?results=20")!
        return URLSession.shared.rx.json(url: url)
            .map { json in
                guard let json = json as? [String: AnyObject] else {
                    throw exampleError("Casting to dictionary failed")
                }
                return try self.parseJSON(json)
        }
    }
    
    private func parseJSON(_ json: [String: AnyObject]) throws -> [User] {
        guard let results = json["results"] as? [[String: AnyObject]] else {
            throw exampleError("Can't find results")
        }
        
        let userParingError = exampleError("Can't pares user")
        
        let searchResults: [User] = try results.map { user in
            let name = user["name"] as? [String: String]
            let pictures = user["picture"] as? [String: String]
            
            guard let firstName = name?["first"], let lastName = name?["last"], let imageUrl = pictures?["medium"] else {
                throw userParingError
            }
            
            let returnUser = User(firstName: firstName, lastName: lastName, imageURL: imageUrl)
            
            return returnUser
        }
        return searchResults
    }
}

func exampleError(_ error: String, location: String = "\(#file):\(#line)") -> NSError {
    return NSError(domain: "ExampleError", code: -1, userInfo: [NSLocalizedDescriptionKey: "\(location): \(error)"])
}



