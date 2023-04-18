import UIKit
import TiqrCoreObjC
import OpenAPIClient
import LocalAuthentication

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

    private let biometricService = BiometricService()
    
    var viewController: BiometricAccessApprovalViewController?
    
    private let defaults = UserDefaults.standard
    
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
    
    //Flipping the boolean value of the 
    func handleUseBiometricAccess() {
        guard enrollmentChallenge != nil else {
            fatalError("you can't setup biometrec access without an enrollment challenge")
            return
        }

        ServiceContainer.sharedInstance().challengeService.complete(enrollmentChallenge!, usingBiometricID: true, withPIN: pinToString(pinArray: secondEnteredPin)) { [weak self] success, error in
            if success {

                //write "existingUserWithSecret" to Userdefaults

                //UI can proceed to next screen
                self?.biometricAccessSuccessClosure?()

            } else {
                self?.biometricAccessFailureClosure?(error)
            }
        }
    }
    
    //run After the second pin
    @MainActor
    func requestTiqrEnroll() {
        Task {
            do{
                let enrollment = try await TiqrControllerAPI.startEnrollment()
                ServiceContainer.sharedInstance().challengeService.startChallenge(fromScanResult: enrollment.url ?? "") { [weak self] type, object, error in
                    ServiceContainer.sharedInstance().challengeService.complete(object as! EnrollmentChallenge, usingBiometricID: false, withPIN: self?.pinToString(pinArray: self?.secondEnteredPin ?? []) ?? "") { [weak self] success, error in
                        if success {

                            //write "existingUserWithSecret" to Userdefaults
                            //UI can proceed to next screen
                            self?.biometricAccessSuccessClosure?()
                            //NEXT STEP

                        } else {
                            self?.biometricAccessFailureClosure?(error)
                        }
                    }
                }
            } catch let error as NSError {
                print("Request Failed Error: \(error)")
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
                self.defaults.setValue(true, forKey: Constants.BiometricDefaults.key)
                Task {
                    await self.requestTiqrEnroll()
                }
            (viewController.biometricApprovaldelegate as? CreateEduIDViewControllerDelegate)?.createEduIDViewControllerShowNextScreen(viewController: viewController)
            } else {
                self.handleBiometric(error)
            }
        }
    }
    
    private func handleBiometric(_ error: LAError?) {
        guard let err = error else { return }
        switch err.code {
        case .userCancel, .biometryNotAvailable:
            self.promptSkipBiometricAccess()
        default:
            break
        }
    }
    
    //MARK: - actions
    @objc func promptSkipBiometricAccess() {
        guard let viewController = self.viewController else { return }
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            let alert = UIAlertController(title: Constants.AlertTiles.skipUsingBiometricsTitle, message: Constants.AlertMessages.skipUsingBiometricsMessage, preferredStyle: .alert)
            alert.addAction(UIAlertAction(
                title: Constants.ButtonTitles.proceed, style: .destructive) { [weak self] _ in
                    guard let self else { return }
                    self.defaults.setValue(false, forKey: Constants.BiometricDefaults.key)
                    (viewController.biometricApprovaldelegate as? CreateEduIDViewControllerDelegate)?.createEduIDViewControllerShowNextScreen(viewController: viewController)
                })
            alert.addAction(UIAlertAction(title: Constants.ButtonTitles.cancel, style: .cancel) { action in
                alert.dismiss(animated: true)
            })
            viewController.present(alert, animated: true)
        }
    }
}
