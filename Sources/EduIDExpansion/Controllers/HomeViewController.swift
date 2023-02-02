import UIKit
import TinyConstraints

class HomeViewController: UIViewController {
    
    weak var delegate: HomeNavigationDelegate?
    var buttonStack: AnimatedHStackView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        buttonStack.animate()
    }
    
    func setupUI() {
        //MARK: - PosterLabel
        let posterLabel = UILabel.posterTextLabelBicolor(text: "Your eduID app\nis ready for use", size: 32, primary: "Your eduID app", alignment: .center)
        posterLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(posterLabel)
        posterLabel.width(to: view)
        posterLabel.centerX(to: view)
        posterLabel.top(to: view, offset: 125)
        
        //MARK: - blue bottom view
        let blueBottomView = UIView()
        blueBottomView.translatesAutoresizingMaskIntoConstraints = false
        blueBottomView.backgroundColor = .backgroundColor
        view.addSubview(blueBottomView)
        blueBottomView.leading(to: view)
        blueBottomView.width(to: view)
        blueBottomView.bottom(to: view)
        blueBottomView.height(236)
        
        //MARK: - image
        let image = UIImageView(image: .readyForUse)
        image.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(image)
        image.leading(to: view)
        image.width(to: view)
        image.aspectRatio(0.761)
        image.contentMode = .scaleAspectFit
        image.bottom(to: view, offset: -76)
        
        //MARK: - button stack
        let securityButton = UIButton()
        securityButton.setImage(.security, for: .normal)
        securityButton.contentMode = .scaleAspectFit
        securityButton.height(51)
        securityButton.addTarget(self, action: #selector(securityTapped), for: .touchUpInside)
        let securityLabel = UILabel()
        securityLabel.font = .nunitoBold(size: 14)
        securityLabel.text = "Security"
        securityLabel.textAlignment = .center
        securityLabel.width(100)
        securityLabel.textColor = .white
        let firstVStack = UIStackView(arrangedSubviews: [securityButton, securityLabel])
        firstVStack.axis = .vertical
        firstVStack.width(100)
        firstVStack.spacing = 3
        
        let personalInfoButton = UIButton()
        personalInfoButton.setImage(.personalInfo, for: .normal)
        personalInfoButton.contentMode = .scaleAspectFit
        personalInfoButton.height(51)
        personalInfoButton.addTarget(self, action: #selector(personalInfoTapped), for: .touchUpInside)
        let personalInfoLabel = UILabel()
        personalInfoLabel.font = .nunitoBold(size: 14)
        personalInfoLabel.text = "Personal info"
        personalInfoLabel.textAlignment = .center
        personalInfoLabel.textColor = .white
        let secondVStack = UIStackView(arrangedSubviews: [personalInfoButton, personalInfoLabel])
        secondVStack.axis = .vertical
        secondVStack.width(100)
        secondVStack.spacing = 3
        
        let activityButton = UIButton()
        activityButton.setImage(.activity, for: .normal)
        activityButton.contentMode = .scaleAspectFit
        activityButton.height(51)
        activityButton.addTarget(self, action: #selector(activityTapped), for: .touchUpInside)
        let activityLabel = UILabel()
        activityLabel.text = "Activity"
        activityLabel.textAlignment = .center
        activityLabel.font = .nunitoBold(size: 14)
        activityLabel.textColor = .white
        let thirdVStack = UIStackView(arrangedSubviews: [activityButton, activityLabel])
        thirdVStack.axis = .vertical
        thirdVStack.width(100)
        thirdVStack.spacing = 3
        
        buttonStack = AnimatedHStackView(arrangedSubviews: [firstVStack, secondVStack, thirdVStack])
        buttonStack.translatesAutoresizingMaskIntoConstraints = false
        buttonStack.spacing = 0
        view.addSubview(buttonStack)
        buttonStack.centerX(to: view)
        buttonStack.bottom(to: view, offset: -60)
        buttonStack.height(100)
        
        buttonStack.hideAndTriggerAll()
        
    }
    
    //MARK: - action buttons
    
    @objc
    func securityTapped() {
        delegate?.showSecurityScreen()
    }
    
    @objc
    func personalInfoTapped() {
        delegate?.showPersonalInfoScreen()
    }
    
    @objc
    func activityTapped() {
        delegate?.showActivityScreen()
    }
}
