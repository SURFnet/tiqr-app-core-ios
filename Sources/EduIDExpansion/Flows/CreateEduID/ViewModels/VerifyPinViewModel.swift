import Foundation
import TiqrCoreObjC

class VerifyPinViewModel: NSObject {
    
    var userPin: String = ""
    private let keyChain = KeyChainService()
    
    init(challenge: AuthenticationChallenge) {
        if challenge.identity != nil {
            if let pinCode = keyChain.getString(for: Constants.KeyChain.userPin) {
                userPin = pinCode
            }
        }
    }
}
