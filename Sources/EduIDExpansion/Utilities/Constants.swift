//
//  Constants.swift
//  
//
//  Created by Yasser Farahi on 06/04/2023.
//

import Foundation

enum Constants {
    
    enum RegEx {
        static let emailRegex = #"^(?=.{6,})[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$"#
        static let nameRegex = #"^[a-zA-Z' ]+$"#
        static let passwordRegex = #"(?=.*[A-Z])(?=.*[0-9])(?=.*[!@#$%^&*()_+\-=[\]{};':"\\|,.<>/?]).{8,}"#
        static let phoneRegex = #"^(?=[+0])[+\d\s]*(?:\d\s*){10,}$"#
    }
    
    enum InvalidInput {
        static let revise = ". Please revise your input"
        static let email = "Invalid email format\(revise)"
        static let name = "Invalid name format\(revise)"
        static let password = "A password must be 8 characters, contain an uppercase letter, and a special character."
        static let phone = "Invalid phone format\(revise)"
    }
    
}
