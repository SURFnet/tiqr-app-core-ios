import UIKit
import TinyConstraints

class AddInstitutionViewController: OnBoardingBaseViewController {

    //MARK: - verify button
    let continueButton = EduIDButton(type: .primary, buttonTitle: "Continue")
    
    //MARK: scroll view
    let scrollView = UIScrollView()
    
    //MARK: - lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        screenType = .addInstitutionScreen

        setupUI()
        
        continueButton.addTarget(self, action: #selector(showNextScreen), for: .touchUpInside)
    }
    
    //MARK: - setup UI
    func setupUI() {
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        scrollView.edges(to: view)
        
        //MARK: - posterLabel
        let posterLabel = UILabel.posterTextLabelBicolor(text: "Your school/uni\nwas contacted successfully", size: 24, primary: "Your school/uni")
        
        //MARK: - create the textView
        let textLabelParent = UIView()
        let textLabel = UILabel.plainTextLabelPartlyBold(text: """
The following information has been added to your eduID and can now be shared.
"""
                                                         , partBold: "")
        textLabelParent.addSubview(textLabel)
        textLabel.edges(to: textLabelParent)
        
        //MARK: institution views
        let firstInstitution = InstitutionView(title: "full name", firstText: "R. van Hamersdonksveer", secondText: "Provided by Universiteit van Amsterdam", action: {})
        let secondInstitution = InstitutionView(title: "Proof of being a student", firstText: "🧑‍🎓 Student", secondText: "Provided by Universiteit van Amsterdam", action: {})
        let thirdInstitution = InstitutionView(title: "Your institution", firstText: "‍🏛️ Universiteit van Amsterdam", secondText: "Provided by Universiteit van Amsterdam", action: {})
        
        //MARK: - Space
        let spaceView = UIView()
        
        //MARK: - create the stackview
        let stack = UIStackView(arrangedSubviews: [posterLabel, textLabelParent, firstInstitution, secondInstitution, thirdInstitution, spaceView, continueButton])
        stack.axis = .vertical
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.distribution = .fill
        stack.alignment = .center
        stack.spacing = 20
        scrollView.addSubview(stack)
        
        //MARK: - add constraints
        stack.edges(to: scrollView, insets: TinyEdgeInsets(top: 24, left: 24, bottom: 24, right: -24))
        stack.width(to: scrollView, offset: -48)
        textLabel.width(to: stack)
        posterLabel.width(to: stack)
        firstInstitution.width(to: stack)
        secondInstitution.width(to: stack)
        thirdInstitution.width(to: stack)
        posterLabel.height(68)
        continueButton.width(to: stack, offset: -24)
    }
}
