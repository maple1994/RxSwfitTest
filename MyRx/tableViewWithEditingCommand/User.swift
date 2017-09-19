//
//  User.swift
//  MyRx
//
//  Created by Maple on 2017/9/19.
//  Copyright © 2017年 Maple. All rights reserved.
//

import UIKit

struct User: Equatable, CustomDebugStringConvertible {
    
    var firstName: String
    var lastName: String
    var imageURL: String
    
    init(firstName: String, lastName: String, imageURL: String) {
        self.firstName = firstName
        self.lastName = lastName
        self.imageURL = imageURL
    }
    
    var debugDescription: String {
        return firstName + " " + lastName
    }
    
    static func == (lhs: User, rhs: User) -> Bool {
        return lhs.firstName == rhs.firstName &&
        lhs.lastName == rhs.lastName
    }
}










