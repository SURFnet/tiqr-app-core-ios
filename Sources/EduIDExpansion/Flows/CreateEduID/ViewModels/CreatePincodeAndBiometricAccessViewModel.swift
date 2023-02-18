import UIKit
import TiqrCoreObjC

final class CreatePincodeAndBiometricAccessViewModel: NSObject {
    
    // - enrollment challenge object
    let enrollmentChallenge: EnrollmentChallenge?
    
    // - entered pincodes
    var firstEnteredPin: [Character] = []
    var secondEnteredPin: [Character] = []
    
    var showUseBiometricScreen: (() -> Void)?
    var proceedWithoutBiometric: (() -> Void)?
    var redoCreatePincode: (() -> Void)?
   
    //MARK: - init
    init(enrollmentChallenge: EnrollmentChallenge? = nil) {
        self.enrollmentChallenge = enrollmentChallenge
        super.init()
    }
    
    func verifyPinSimilarity() {
        if firstEnteredPin == secondEnteredPin {
            
            // succes
            showUseBiometricScreen?()
        } else {
            
            // failure
            redoCreatePincode?()
        }
    }
    
    func handleCreatePincodeSucces() {
        if ServiceContainer.sharedInstance().secretService.biometricIDAvailable {
            showUseBiometricScreen?()
        } else {
            proceedWithoutBiometric?()
        }
    }
    
    func pinToString(pinArray: [Character]) -> String {
        return pinArray.map { String($0) }.joined() as String
    }
    
    @objc
    func setupBiometricAccess() {
        if ServiceContainer.sharedInstance().secretService.biometricIDAvailable {
            ServiceContainer.sharedInstance().challengeService.complete(enrollmentChallenge!, usingBiometricID: true, withPIN: pinToString(pinArray: secondEnteredPin)) { succes, error in
                print(succes)
            }
        } else {
            
        }
    }
}
