import UIKit

class EnterPinViewModel: NSObject {
    
    var resignKeyboardFocus: (() -> Void)?
    var enableVerifyButton: ((Bool) -> Void)?
    var focusPinField: ((Int) -> Void)?
    
    var pinIsEnteredOn: [Int: Bool] = [:] {
        didSet {
            var areAllEntriesEntered = true
            pinIsEnteredOn.forEach { (key, value) in
                if !value {
                    areAllEntriesEntered = false
                }
            }
            enableVerifyButton?(areAllEntriesEntered)
        }
    }
}

//MARK: - pin textfield delegate
extension EnterPinViewModel: PinTextFieldDelegate {

    func didEnterPinNumber(tag: Int) {
        pinIsEnteredOn[tag] = true
        guard tag != 5 else {
            resignKeyboardFocus?()
            return }
            
        focusPinField?(tag)
    }
}
