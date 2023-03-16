import UIKit
import TiqrCoreObjC
import OpenAPIClient

final class CreatePincodeAndBiometricAccessViewModel: NSObject {
    
    // - enrollment challenge object
    let enrollmentChallenge: EnrollmentChallenge?
    // - authentication challenge object
    let authenticationChallenge: AuthenticationChallenge?
    
    // - entered pincodes
    var firstEnteredPin: [Character] = []
    var secondEnteredPin: [Character] = []
    
    var showUseBiometricScreenClosure: (() -> Void)?
    var proceedWithoutBiometricClosure: (() -> Void)?
    var redoCreatePincodeClosure: (() -> Void)?
    
    // - show prompt for biometric access
    var showBiometricNotAvailableClosure: (() -> Void)?
    var showPromptUseBiometricAccessClosure: (() -> Void)?
    var biometricAccessSuccessClosure: (() -> Void)?
    var biometricAccessFailureClosure: ((Error) -> Void)?
   
    //MARK: - init
    init(enrollmentChallenge: EnrollmentChallenge? = nil, authenticationChallenge: AuthenticationChallenge? = nil) {
        self.enrollmentChallenge = enrollmentChallenge
        self.authenticationChallenge = authenticationChallenge
        super.init()
    }
    
    func verifyPinSimilarity() {
        if firstEnteredPin == secondEnteredPin {
            // succes
            showUseBiometricScreenClosure?()
        } else {
            // failure
            redoCreatePincodeClosure?()
        }
    }
    
    //MARK: - biometric access related methods
    
    func handleCreatePincodeSucces() {
        if ServiceContainer.sharedInstance().secretService.biometricIDAvailable {
            showUseBiometricScreenClosure?()
        } else {
            proceedWithoutBiometricClosure?()
        }
    }
    
    func pinToString(pinArray: [Character]) -> String {
        return pinArray.map { String($0) }.joined() as String
    }
    
    @objc
    func promptSetupBiometricAccess() {
        if ServiceContainer.sharedInstance().secretService.biometricIDAvailable {
            showPromptUseBiometricAccessClosure?()
        } else {
            showBiometricNotAvailableClosure?()
        }
    }
    
    func handleUseBiometricAccess() {
        guard enrollmentChallenge != nil else {
            fatalError("you can't setup biometrec access without an enrollment challenge")
            return
        }
        
        ServiceContainer.sharedInstance().challengeService.complete(enrollmentChallenge!, usingBiometricID: true, withPIN: pinToString(pinArray: secondEnteredPin)) { [weak self] success, error in
            if success {
                self?.biometricAccessSuccessClosure?()
            } else {
                self?.biometricAccessFailureClosure?(error)
            }
        }
    }
    
    @MainActor
    func requestTiqrEnroll() {
        Task {
            do{
                let enrollment = try await TiqrControllerAPI.startEnrollment()
                ServiceContainer.sharedInstance().challengeService.startChallenge(fromScanResult: enrollment.url ?? "") { [weak self] type, object, error in
                    ServiceContainer.sharedInstance().challengeService.complete(object as! EnrollmentChallenge, usingBiometricID: true, withPIN: self?.pinToString(pinArray: self?.secondEnteredPin ?? []) ?? "") { [weak self] success, error in
                        if success {
                            self?.biometricAccessSuccessClosure?()
                        } else {
                            self?.biometricAccessFailureClosure?(error)
                        }
                    }
                }
            }
        }
    }
}
