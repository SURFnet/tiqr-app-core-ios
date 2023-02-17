import UIKit

class CreatePincodeFirstEntryViewController: PincodeBaseViewController {
    
    let createPincodeViewModel: CreatePincodeViewModel
    
    //MARK: - init
    init(viewModel: CreatePincodeViewModel) {
        self.createPincodeViewModel = viewModel
        super.init(viewModel: PinViewModel(), isSecure: true)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        screenType = .createPincodefirstEntryScreen
        
        posterLabel.text = "Select a PIN code"
        textLabel.text = "To use the eduID app you need a PIN code."
        verifyButton.buttonTitle = "Next"
        
    }
    
    override func showNextScreen() {
        createPincodeViewModel.firstEnteredPin = viewModel.pinValue
        (delegate as? CreateEduIDViewControllerDelegate)?.createEduIDViewControllerShowConfirmPincodeScreen(viewController: self, viewModel: createPincodeViewModel)
    }
}
