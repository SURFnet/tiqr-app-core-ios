import UIKit
import TinyConstraints

class BiometricApprovalViewController: CreateEduIDBaseViewController {
    
    weak var biometricApprovaldelegate: BiometricApprovalViewControllerDelegate?
    let createPincodeViewModel: CreatePincodeAndBiometricAccessViewModel
    
    //MARK: - init
    init(viewModel: CreatePincodeAndBiometricAccessViewModel) {
        self.createPincodeViewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        
        viewModel.showBiometricNotAvailableClosure = { [weak self] in
            let alert = UIAlertController(title: "Biometrics not available", message: "Please skip this step", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default) { action in
                alert.dismiss(animated: true)
            })
            self?.present(alert, animated: true)
        }
        
        viewModel.showPromptUseBiometricAccessClosure = { [weak self] in
            let alert = UIAlertController(title: "Use biometric access?", message: "Would you like to use biometric access in stead of using a PINcode", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default) { action in
                self?.createPincodeViewModel.handleUseBiometricAccess()
            })
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel) { action in
                alert.dismiss(animated: true)
            })
            self?.present(alert, animated: true)
        }
        
        viewModel.proceedWithoutBiometricClosure = { [weak self] in
            guard let self = self else { return }
            
            self.biometricApprovaldelegate?.biometricApprovalViewControllerSkipBiometricAccess(viewController: self)
        }
        
        viewModel.biometricAccessFailureClosure = { [weak self] error in
            let alert = UIAlertController(title: "Error", message: "Biometric access request failed (\(error.localizedDescription), please try again or skip this step.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default))
            self?.present(alert, animated: true)
        }
        
        viewModel.biometricAccessSuccessClosure = { [weak self] in
            guard let self = self else { return }
            
            self.biometricApprovaldelegate?.biometricApprovalViewControllerSkipBiometricAccess(viewController: self)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - setup lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        screenType = .biometricApprovalScreen
        setupUI()
    }
    
    //MARK: - setup ui
    func setupUI() {
        
        //poster label
        let posterParent = UIView()
        let posterLabel = UILabel.posterTextLabel(text: "Biometric approval")
        posterParent.addSubview(posterLabel)
        posterLabel.edges(to: posterParent)
        
        // text label
        let textParent = UIView()
        let textLabel = UILabel.plainTextLabelPartlyBold(text: """
Do you want to use your biometrics to access the eduID app more easily?
"""
                                                         , partBold: "biometrics")
        textParent.addSubview(textLabel)
        textLabel.edges(to: textParent)
        
        // image
        let imageParent = UIView()
        let imageView = UIImageView(image: .biometric)
        imageView.aspectRatio(1 / 0.727564102564103)
        imageParent.addSubview(imageView)
        imageView.center(in: imageParent)
        
        // buttons
        let setupButton = EduIDButton(type: .primary, buttonTitle: "Set up biometric access")
        let skipButton = EduIDButton(type: .ghost, buttonTitle: "Skip this")
        
        // stack
        let stack = BasicStackView(arrangedSubviews: [posterParent, textParent, imageParent, setupButton, skipButton])
        view.addSubview(stack)
        
        // constraints
        stack.edgesToSuperview(insets: TinyEdgeInsets(top: 24, left: 24, bottom: 24, right: 24), usingSafeArea: true)
        imageView.width(to: view)
        imageParent.width(to: stack)
        imageView.width(to: view)
        posterParent.width(to: stack)
        setupButton.width(to: stack, offset: -24)
        skipButton.width(to: stack, offset: -24)
        
        // actions
        setupButton.addTarget(createPincodeViewModel, action: #selector(createPincodeViewModel.promptSetupBiometricAccess), for: .touchUpInside)
        skipButton.addTarget(createPincodeViewModel, action: #selector(createPincodeViewModel.setupWithoutBiometricAccess), for: .touchUpInside)
    }
}
