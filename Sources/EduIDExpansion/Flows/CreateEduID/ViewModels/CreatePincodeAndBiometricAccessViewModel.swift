import UIKit
import TiqrCoreObjC
import OpenAPIClient
import LocalAuthentication

final class CreatePincodeAndBiometricAccessViewModel: NSObject {
    
    // - enrollment challenge object
    var enrollmentChallenge: EnrollmentChallenge?
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
    
    var nextScreenDelegate: ShowNextScreenDelegate?
    private let biometricService = BiometricService()
    private let keychain = KeyChainService()

    //MARK: - init
    init(enrollmentChallenge: EnrollmentChallenge? = nil, authenticationChallenge: AuthenticationChallenge? = nil) {
        self.enrollmentChallenge = enrollmentChallenge
        self.authenticationChallenge = authenticationChallenge
        super.init()
    }
    
    func verifyPinSimilarity() {
        if firstEnteredPin == secondEnteredPin {
            Task {
                await requestTiqrEnroll() { [weak self] success in
                    guard let self else { return }
                    if success {
                        self.showUseBiometricScreenClosure?()
                    }
                }
            }
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
    
    @objc func promptSetupBiometricAccess() {
        if ServiceContainer.sharedInstance().secretService.biometricIDAvailable {
            showPromptUseBiometricAccessClosure?()
        } else {
            showBiometricNotAvailableClosure?()
        }
    }
    
    //run After the second pin
    @MainActor
    func requestTiqrEnroll(completion: @escaping ((Bool) -> Void)) {
        if enrollmentChallenge == nil {
            Task {
                do{
                    let enrolment = try await TiqrControllerAPI.startEnrollmentWithRequestBuilder()
                        .addHeader(name: Constants.Headers.authorization, value: keychain.getString(for: Constants.KeyChain.accessToken) ?? "")
                        .execute()
                        .body
                    
                    ServiceContainer.sharedInstance().challengeService.startChallenge(fromScanResult: enrolment.url ?? "") { [weak self] type, object, error in
                        guard let self else { return }
                        self.secondEnteredPin.removeLast(2)
                        self.createIdentity(for: object as? EnrollmentChallenge, completion: completion)
                    }
                } catch let error as NSError {
                    dump(error)
                    completion(false)
                }
            }
        } else {
            self.createIdentity(for: self.enrollmentChallenge, completion: completion)
        }
    }
    
    private func createIdentity(for challange: EnrollmentChallenge?, completion: @escaping ((Bool) -> Void)) {
        if let enrolChallange = challange {
            self.secondEnteredPin.removeLast(2)
            ServiceContainer.sharedInstance().challengeService.complete(enrolChallange, usingBiometricID: false, withPIN: self.pinToString(pinArray: self.secondEnteredPin)) { success, error in
                if success {
                    completion(true)
                } else {
                    completion(false)
                }
            }
        }
    }

}

extension CreatePincodeAndBiometricAccessViewModel {
    @objc func requestBiometricAccess() {
        biometricService.useOnDeviceBiometricFeature { [weak self] success, error in
            guard let self else { return }
            if success {
                if let enrolment = self.enrollmentChallenge {
                    if let managedObject = enrolment.identity.managedObjectContext {
                        enrolment.identity.biometricIDEnabled = NSNumber(value: 1)
                        do {
                            try managedObject.save()
                            self.nextScreenDelegate?.nextScreen()
                        } catch let error {
                            assertionFailure(error.localizedDescription)
                        }
                    }
                }
            } else {
                self.handleBiometric(error)
            }
        }
    }
    
    private func handleBiometric(_ error: LAError?) {
        guard let err = error else { return }
        switch err.code {
        case .userCancel, .biometryNotAvailable:
            nextScreenDelegate?.nextScreen()
        default:
            break
        }
    }
}

