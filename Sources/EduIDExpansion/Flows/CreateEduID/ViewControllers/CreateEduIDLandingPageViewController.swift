import UIKit
import TinyConstraints

class CreateEduIDLandingPageViewController: CreateEduIDBaseViewController {
    
    private var stack: AnimatedVStackView!
    
    //MARK: - lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        screenType = .landingScreen
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        stack?.animate(onlyThese: [3, 4, 5])
        screenType.configureNavigationItem(item: navigationItem, target: self, action: #selector(showScanScreen))
        
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        
    }
    
    //MARK: - setupUI
    private func setupUI() {
        
        view.backgroundColor = .white
        
        //MARK: - add logo
        let logo = UIImageView(image: .eduIDLogo)
        logo.height(60)
        logo.width(150)
        
        //MARK: - add label
        let posterLabel = UILabel.posterTextLabel(text: "Personal account\nfor Education and Research", size: 24, alignment: .center)
        
        //MARK: add image
        let imageView = UIImageView(image: .landingPageImage)
        imageView.contentMode = .scaleAspectFit
        imageView.height(252, priority: .defaultLow)
        imageView.width(141)
        
        //MARK: - space
        let spaceView = UIView()
        
        //MARK: buttons
        let signinButton = EduIDButton(type: .primary, buttonTitle: "Sign in")
        signinButton.addTarget(self, action: #selector(signInTapped), for: .touchUpInside)
        let scanQRButton = EduIDButton(type: .primary, buttonTitle: "Scan a QR code")
        scanQRButton.addTarget(self, action: #selector(showScanScreen), for: .touchUpInside)
        let noEduIDYetButton = EduIDButton(type: .naked, buttonTitle: "I don't have an eduId")
        
        //the action for this button is on CreateEduIDBaseViewController superclass
        noEduIDYetButton.addTarget(self, action: #selector(showNextScreen), for: .touchUpInside)
        
        //MARK: - create the stackview
        stack = AnimatedVStackView(arrangedSubviews: [logo, posterLabel, imageView, signinButton, scanQRButton, noEduIDYetButton])
        stack.axis = .vertical
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.distribution = .equalSpacing
        stack.alignment = .center
        view.addSubview(stack)
        
        stack.edgesToSuperview(insets: TinyEdgeInsets(top: 24, left: 24, bottom: 24, right: 24), usingSafeArea: true)
        signinButton.width(to: stack, offset: -24)
        scanQRButton.width(to: stack, offset: -24)
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
