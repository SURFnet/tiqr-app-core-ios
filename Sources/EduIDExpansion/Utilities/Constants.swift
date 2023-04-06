//
<<<<<<< HEAD
//  File.swift
//  
//
//  Created by Yasser Farahi on 04/04/2023.
//

import Foundation
=======
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
    
}
>>>>>>> 7946759 (EDURED-54: The input doesn't follow regex)
