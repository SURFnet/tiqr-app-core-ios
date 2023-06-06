import UIKit
import TinyConstraints

final class VerifyPinCodeViewController: PincodeBaseViewController {
    
    private let verifyPinCodeViewModel: VerifyPinViewModel
    private var callBack: (() -> Void)?
    
    //MARK: - init
    init(viewModel: VerifyPinViewModel, completion: (() -> Void)?) {
        self.verifyPinCodeViewModel = viewModel
        super.init(viewModel: PinViewModel(), isSecure: true)
        verifyButton.isHidden = true
        screenType = .pincodeScreen
        callBack = completion
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupAppearance()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    private func setupAppearance() {
        posterLabel.text = "Enter your edulD PIN"
        textLabel.text = "Enter the PIN and press OK:"
        
        let approveButton = EduIDButton(type: .primary, buttonTitle: "OK")
        let cancelButton = EduIDButton(type: .ghost, buttonTitle: "Cancel")
        approveButton.addTarget(self, action: #selector(approveAction), for: .touchUpInside)
        cancelButton.addTarget(self, action: #selector(cancelAction), for: .touchUpInside)
        let buttonsStack = AnimatedHStackView(arrangedSubviews: [cancelButton, approveButton])
        buttonsStack.spacing = 24
        buttonsStack.distribution = .fillEqually
        mainStack.insertArrangedSubview(buttonsStack, at: 5)
        buttonsStack.width(to: mainStack)
    }
    
    @objc func cancelAction() {
        dismiss(animated: true)
    }
    
    @objc func approveAction() {
        if verifyPinCodeViewModel.userPin == enteredPinValue() {
            self.dismiss(animated: true) { [weak self] in
                guard let self else { return }
                self.callBack?()
            }
        }
    }
    
    private func enteredPinValue() -> String {
        return viewModel.pinValue.dropLast(2).map { String($0) }.joined()
    }
 
}
