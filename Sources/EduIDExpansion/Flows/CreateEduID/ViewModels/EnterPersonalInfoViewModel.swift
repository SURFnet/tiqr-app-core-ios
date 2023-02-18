import UIKit
import OpenAPIClient

class EnterPersonalInfoViewModel: NSObject {
    
    
    
    //- closures that interact with the view controller
    var setRequestButtonEnabled: ((Bool) -> Void)?
    var makeNextTextFieldFirstResponderClosure: ((Int) -> Void)?
    var textFieldBecameFirstResponderClosure: ((Int) -> Void)?
    
    var textFieldModels: [TextFieldModelWithTagAndValid] = [
        TextFieldModelWithTagAndValid(tag: CreateEduIDEnterPersonalInfoViewController.emailFieldTag, text: "", isValid: false),
        TextFieldModelWithTagAndValid(tag: CreateEduIDEnterPersonalInfoViewController.firstNameFieldTag, text: "", isValid: false),
        TextFieldModelWithTagAndValid(tag: CreateEduIDEnterPersonalInfoViewController.lastNameFieldTag, text: "", isValid: false)
    ] {
        didSet {
            var isTrue = true
            textFieldModels.forEach({ model in
                if !model.isValid {
                    isTrue = false
                }
            })
            setRequestButtonEnabled?(isTrue)
        }
    }
    
    func apiCallToCreateEduID() {
        
    }
}

//MARK: - textfield delegate
extension EnterPersonalInfoViewModel: ValidatedTextFieldDelegate {
    
    func updateValidation(with value: String, isValid: Bool, from tag: Int) {
        if let index = textFieldModels.firstIndex(where: { $0.tag == tag }) {
            textFieldModels[index] = TextFieldModelWithTagAndValid(tag: tag, text: value, isValid: isValid)
        }
    }
    
    func keyBoardDidReturn(tag: Int) {
        makeNextTextFieldFirstResponderClosure?(tag)
    }
    
    func didBecomeFirstResponder(tag: Int) {
        textFieldBecameFirstResponderClosure?(tag)
    }
}
