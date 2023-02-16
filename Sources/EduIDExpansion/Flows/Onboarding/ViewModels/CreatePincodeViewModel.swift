import UIKit
import TiqrCoreObjC

final class CreatePincodeViewModel: NSObject {
    
    //MARK: - entered pincodes
    var firstEnteredPin: [Character] = []
    var secondEnteredPin: [Character] = []
    
    var showUseBiometricScreen: (() -> Void)?
    var proceedWithoutBiometric: (() -> Void)?
    var redoCreatePincode: (() -> Void)?
    
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
            let enrollment = (try? EnrollmentChallenge(challenge: ServiceContainer.sharedInstance().challengeService., allowFiles: true))!
            ServiceContainer.sharedInstance().challengeService.complete(enrollment, usingBiometricID: true, withPIN: pinToString(pinArray: secondEnteredPin)) { succes, error in
                print(succes, error)
            }
        } else {
            
        }
    }
}
