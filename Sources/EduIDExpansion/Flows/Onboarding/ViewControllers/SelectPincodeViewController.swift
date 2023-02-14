import UIKit

class SelectPincodeViewController: PincodeBaseViewController {
    
    //MARK: - lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        posterLabel.text = "Select a PINcode"
        textLabel.text = "To use the eduID app you need a PIN code."
        verifyButton.buttonTitle = "Next"
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        
    }
}
