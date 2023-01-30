import UIKit
import TinyConstraints

class LandingPageViewController: EduIDBaseViewController {
    
    private var stack: AnimatedVStackView!
    
    //MARK: - lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        stack?.animate(onlyThese: [3, 4, 5])
    }
    
    //MARK: - setupUI
    private func setupUI() {
        
        view.backgroundColor = .white
        
        //MARK: - add logo
        let logo = UIImageView(image: .eduIDLogo)
        logo.height(60)
        logo.width(150)
        
        //MARK: - add label
        let posterLabel = UILabel.posterTextLabel(text: "Personal account\nfor Education and Research", size: 24)
        
        //MARK: add image
        let imageView = UIImageView(image: .landingPageImage)
        imageView.contentMode = .scaleAspectFit
        imageView.height(252)
        imageView.width(141)
        
        //MARK: - space
        let spaceView = UIView()
        spaceView.height(999, priority: .defaultLow)
        
        //MARK: buttons
        let signinButton = EduIDButton(type: .primary, buttonTitle: "Sign in")
        signinButton.addTarget(self, action: #selector(signInTapped), for: .touchUpInside)
        let noEduIDYetButton = EduIDButton(type: .naked, buttonTitle: "I don't have an eduId")
        
        //the action for this button is on EduIDBaseViewController superclass
        noEduIDYetButton.addTarget(self, action: #selector(showNextScreen), for: .touchUpInside)
        
        //MARK: - create the stackview
        stack = AnimatedVStackView(arrangedSubviews: [logo, posterLabel, imageView, spaceView, signinButton, noEduIDYetButton])
        stack.axis = .vertical
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.distribution = .fill
        stack.alignment = .center
        stack.spacing = 32
        view.addSubview(stack)
        
        stack.edgesToSuperview(insets: TinyEdgeInsets(top: 24, left: 24, bottom: 24, right: 24), usingSafeArea: true)
        signinButton.width(to: stack, offset: -24)
        noEduIDYetButton.width(to: stack, offset: -24)
        posterLabel.width(to: stack)
        
        stack.hideAndTriggerAll(onlyThese: [3, 4, 5])
    }
    
    //MARK: - button actions
    
    @objc
    func signInTapped() {
        //not implemented
    }

}
