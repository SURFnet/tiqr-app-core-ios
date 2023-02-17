import UIKit

class PinViewModel: NSObject {
    
    var resignKeyboardFocus: (() -> Void)?
    var enableVerifyButton: ((Bool) -> Void)?
    var focusPinField: ((Int) -> Void)?
    
    var pinValue: [Character] = ["0", "0", "0", "0", "0", "0"]
    
    var pinIsEnteredOnTextFieldIndex: [Int: Bool] = [:] {
        didSet {
            var areAllEntriesEntered = true
            pinIsEnteredOnTextFieldIndex.forEach { (key, value) in
                if !value {
                    areAllEntriesEntered = false
                }
            }
            enableVerifyButton?(areAllEntriesEntered)
        }
    }
}

//MARK: - pin textfield delegate
extension PinViewModel: PinTextFieldDelegate {

    func didEnterPinNumber(tag: Int, value: Character) {
        pinValue[tag] = value
        pinIsEnteredOnTextFieldIndex[tag] = true
        guard tag != 5 else {
            resignKeyboardFocus?()
            return }
            
        focusPinField?(tag)
    }
}
