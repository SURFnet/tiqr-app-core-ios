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
    
    func setupBiometricAccess() {
        if ServiceContainer.sharedInstance().secretService.biometricIDAvailable {
            
        }
    }
}
