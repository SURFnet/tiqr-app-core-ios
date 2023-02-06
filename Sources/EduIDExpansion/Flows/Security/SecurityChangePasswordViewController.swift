import UIKit
import TinyConstraints

class SecurityChangePasswordViewController: UIViewController {
    
    //MARK: delegate
    weak var delegate: SecurityNavigationDelegate?
    
    //MARK: scrollView
    let scrollView = UIScrollView()

    //MARK: - lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }
    
    //MARK: - setup UI
    private func setupUI() {
        // scrollView
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        scrollView.edges(to: view)
        
        // poster label
        let posterParent = UIView()
        let posterLabel = UILabel.posterTextLabelBicolor(text: "Change password", primary: "Change password")
        posterParent.addSubview(posterLabel)
        posterLabel.edges(to: posterParent)
        
        // old password textfield
        let oldPasswordTextField = TextFieldViewWithValidationAndTitle(title: "Your old password", placeholder: "********", keyboardType: .default)
        
        // text
        let textParent = UIView()
        let textLabel = UILabel.plainTextLabelPartlyBold(text:
                                                            """
Make sure your new password is at least 15 characters OR at least 8 characters including a number and a uppercase letter.
"""
                                                         , partBold: "Make sure your new password")
        textParent.addSubview(textLabel)
        textLabel.edges(to: textParent)
        
        // new password field
        let newPasswordField = TextFieldViewWithValidationAndTitle(title: "Your new password", placeholder: "********", keyboardType: .default)
         
        // repeat password
        let repeatPasswordField = TextFieldViewWithValidationAndTitle(title: "Repeat new password", placeholder: "********", keyboardType: .default)
        
        // stackview
        let stack = BasicStackView(arrangedSubviews: [posterParent, oldPasswordTextField, textParent, newPasswordField, repeatPasswordField])
        
        scrollView.addSubview(stack)
        
        // constraints
        stack.edges(to: scrollView, insets: TinyEdgeInsets(top: 24, left: 24, bottom: -24, right: -24))
        stack.width(to: scrollView, offset: -48)
        posterLabel.width(to: stack)
        oldPasswordTextField.width(to: stack)
        textParent.width(to: stack)
        newPasswordField.width(to: stack)
        repeatPasswordField.width(to: stack)
        
    }


}
