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
    
    private let biometricService = BiometricService()
    var viewController: BiometricAccessApprovalViewController?
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
                await requestTiqrEnroll(withBiometrics: false) { [weak self] success in
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
    func requestTiqrEnroll(withBiometrics: Bool, completion: @escaping ((Bool) -> Void)) {
        Task {
            do{
                let enrolment = try await TiqrControllerAPI.startEnrollmentWithRequestBuilder()
                    .addHeader(name: Constants.Headers.authorization, value: keychain.getString(for: Constants.KeyChain.accessToken) ?? "")
                    .execute()
                    .body
                
                ServiceContainer.sharedInstance().challengeService.startChallenge(fromScanResult: enrolment.url ?? "") { [weak self] type, object, error in
                    guard let self else { return }
                    self.secondEnteredPin.removeLast(2)
                    ServiceContainer.sharedInstance().challengeService.complete(object as! EnrollmentChallenge, usingBiometricID: withBiometrics, withPIN: self.pinToString(pinArray: self.secondEnteredPin)) { success, error in
                        if success {
                            self.enrollmentChallenge = (object as? EnrollmentChallenge)
                            completion(true)
                        } else {
                            completion(false)
                        }
                    }
                }
            } catch let error as NSError {
                assertionFailure(error.localizedDescription)
                completion(false)
            }
        }
    }
}

extension CreatePincodeAndBiometricAccessViewModel {
    @objc func requestBiometricAccess() {
        guard let viewController = self.viewController else { return }
        biometricService.useOnDeviceBiometricFeature { [weak self] success, error in
            guard let self else { return }
            if success {
                if let enrolment = self.enrollmentChallenge {
                    if let managedObject = enrolment.identity.managedObjectContext {
                        enrolment.identity.biometricIDEnabled = NSNumber(value: 1)
                        do {
                            try managedObject.save()
                            (viewController.biometricApprovaldelegate as? CreateEduIDViewControllerDelegate)?.createEduIDViewControllerShowNextScreen(viewController: viewController)
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
            guard let viewController = self.viewController else { break }
            (viewController.biometricApprovaldelegate as? CreateEduIDViewControllerDelegate)?.createEduIDViewControllerShowNextScreen(viewController: viewController)
        default:
            break
        }
    }
    
    //MARK: - actions
    @objc func promptSkipBiometricAccess() {
        guard let viewController = self.viewController else { return }
        DispatchQueue.main.async {
            let alert = UIAlertController(title: Constants.AlertTiles.skipUsingBiometricsTitle, message: Constants.AlertMessages.skipUsingBiometricsMessage, preferredStyle: .alert)
            alert.addAction(UIAlertAction(
                title: Constants.ButtonTitles.proceed, style: .destructive) {  _ in
                    (viewController.biometricApprovaldelegate as? CreateEduIDViewControllerDelegate)?.createEduIDViewControllerShowNextScreen(viewController: viewController)
                })
            alert.addAction(UIAlertAction(title: Constants.ButtonTitles.cancel, style: .cancel) { action in
                alert.dismiss(animated: true)
            })
            viewController.present(alert, animated: true)
        }
    }
}
