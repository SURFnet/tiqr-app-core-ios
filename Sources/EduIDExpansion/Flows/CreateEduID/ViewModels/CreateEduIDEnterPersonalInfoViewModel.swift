import UIKit
import OpenAPIClient

class CreateEduIDEnterPersonalInfoViewModel: NSObject {
    
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
    
    var createEduIDErrorClosure: ((Error) -> Void)?
    var createEduIDSuccessClosure: (() -> Void)?
    
    override init() {
        super.init()
    }
    
    func createEduID(familiyName: String, givenName: String, email: String) {
        Task {
            do {
                try await UserControllerAPI.createEduIDAccount(createAccount: CreateAccount(email: email, givenName: givenName, familyName: familiyName))
                createEduIDSuccessClosure?()
            } catch {
                createEduIDErrorClosure?(error)
            }
        }
    }
}

//MARK: - textfield delegate
extension CreateEduIDEnterPersonalInfoViewModel: ValidatedTextFieldDelegate {
    
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
