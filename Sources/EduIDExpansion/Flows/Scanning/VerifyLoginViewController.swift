import UIKit
import TinyConstraints

class VerifyLoginViewController: BaseViewController {

    //MARK: - lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }
    
    //MARK: - setupUI
    func setupUI() {
        //top poster label
        let posterParent = UIView()
        let posterLabel = UILabel.posterTextLabelBicolor(text: "Request to login", primary: "Request to login")
        posterParent.addSubview(posterLabel)
        posterLabel.edges(to: posterParent)
        
        let upperspace = UIView()
        
        // text in middle with organisation name
        let middlePosterParent = UIView()
        let middlePosterLabel = UILabel.requestLoginLabel(organisationName: "eduBadges")
        middlePosterParent.addSubview(middlePosterLabel)
        middlePosterLabel.edges(to: middlePosterParent)
        
        let lowerSpace = UIView()
        
        let cancelButton = EduIDButton(type: .ghost, buttonTitle: "Cancel")
        let loginButton = EduIDButton(type: .primary, buttonTitle: "Log in")
        let animatedHStack = AnimatedHStackView(arrangedSubviews: [cancelButton, loginButton])
        animatedHStack.spacing = 24
        
        // the stackView
        let stack = BasicStackView(arrangedSubviews: [posterParent, upperspace, middlePosterParent, lowerSpace, animatedHStack])
        view.addSubview(stack)
        
        //constraints
        stack.edgesToSuperview(insets: TinyEdgeInsets(top: 24, left: 24, bottom: 24, right: 24), usingSafeArea: true)
        upperspace.height(to: lowerSpace)
        animatedHStack.width(to: stack)
        loginButton.width(to: cancelButton)
        
    }

}
