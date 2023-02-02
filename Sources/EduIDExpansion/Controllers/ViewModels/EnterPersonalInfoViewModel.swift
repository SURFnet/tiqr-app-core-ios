import UIKit

class EnterPersonalInfoViewModel: NSObject {
    
    //MARK: - closures that interact with the view controller
    var setRequestButtonEnabled: ((Bool) -> Void)?
    var makeNextTextFieldFirstResponderClosure: ((Int) -> Void)?
    var textFieldBecameFirstResponderClosure: ((Int) -> Void)?
    
    var validationMap: [Int: Bool] = [1:false, 2:false, 3: false] {
        didSet {
            var isTrue = true
            validationMap.forEach({ (key: Int, value: Bool) in
                if !value {
                    isTrue = false
                }
            })
            setRequestButtonEnabled?(isTrue)
        }
    }
}

//MARK: - textfield delegate
extension EnterPersonalInfoViewModel: ValidatedTextFieldDelegate {
    
    func updateValidation(with value: Bool, from tag: Int) {
        validationMap[tag] = value
    }
    
    func keyBoardDidReturn(tag: Int) {
        makeNextTextFieldFirstResponderClosure?(tag)
    }
    
    func didBecomeFirstResponder(tag: Int) {
        textFieldBecameFirstResponderClosure?(tag)
    }
}
