//
//  File.swift
//  
//
//  Created by Yasser Farahi on 13/04/2023.
//

import LocalAuthentication

class BiometricService {
    
    private let laContext = LAContext()
    
    func useOnDeviceBiometricFeature(completion: @escaping((Bool) -> Void)) {
        var error: NSError?
        if laContext.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            laContext.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: "Authenticate to access the app") { success, error in
                guard error == nil else {
                    completion(false)
                    return
                }
                DispatchQueue.main.async {
                    if success {
                        completion(true)
                    } else {
                        completion(false)
                    }
                }
            }
        } else {
            completion(false)
        }
    }
    
}
