import UIKit
import TinyConstraints

class FirstTimeDialogViewController: EduIDBaseViewController {

    //MARK: - primary button
    let addButton = EduIDButton(type: .primary, buttonTitle: "Connect your school/institution")
    
    //MARK: - stck
    var stack: AnimatedVStackView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        addButton.addTarget(self, action: #selector(showNextScreen), for: .touchUpInside)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        stack.animate(onlyThese: [4, 5])
    }
    
    func setupUI() {
        //MARK: - postertext
        let posterLabel = UILabel.posterTextLabelBicolor(text: "Are you studying in NL?\nConnect your institution!", size: 24, primary: "Connect your institution!")
        
        //MARK: - textView
        let paragraph = NSMutableParagraphStyle()
        paragraph.lineSpacing = 24 - 16
        let attributedText = NSMutableAttributedString(string: """
When you study in the Netherlands and you want to use eduID to logon to an educational services, we need to be sure it’s you and not someone impersonating you.
You must therefore add the following information to your eduID:
• Validation of your full name by a third party
• Proof of being a student
• Your current institution
"""
                                                       , attributes: [.foregroundColor: UIColor.charcoalColor, .font: UIFont.sourceSansProRegular(size: 16), .paragraphStyle: paragraph])
        attributedText.setAttributeTo(part: "When you study in the Netherlands", attributes: [.font: UIFont.sourceSansProBold(size: 16), .paragraphStyle: paragraph])
        attributedText.setAttributeTo(part: "You must therefore add the following information to your eduID:", attributes: [.font: UIFont.sourceSansProBold(size: 16), .paragraphStyle: paragraph])
        let textView = TextViewBackgroundColor(attributedText: attributedText, backgroundColor: .yellowColor, insets: UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12))
        
        //MARK: - spacing
        let spaceView = UIView()
        
        //MARK: - additional text view
        let label = UILabel()
        label.numberOfLines = 0
        let attributedText2 = NSMutableAttributedString(string: "Add this information by connecting your school/institution via SURFconext.", attributes: [.foregroundColor: UIColor.charcoalColor, .font: UIFont.sourceSansProRegular(size: 16)])
        attributedText2.setAttributeTo(part: "Add this information", attributes: [.font: UIFont.sourceSansProBold(size: 16)])
        label.attributedText = attributedText2
        
        //MARK: - skip button
        let skipButton = EduIDButton(type: .ghost, buttonTitle: "Skip this")
        skipButton.isEnabled = false
        
        //MARK: - create the stackview
        stack = AnimatedVStackView(arrangedSubviews: [posterLabel, textView, spaceView, label, addButton, skipButton])
        stack.axis = .vertical
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.distribution = .fill
        stack.alignment = .center
        stack.spacing = 20
        view.addSubview(stack)
        
        //MARK: - add constraints
        stack.edgesToSuperview(insets: TinyEdgeInsets(top: 24, left: 24, bottom: 24, right: 24), usingSafeArea: true)
        textView.width(to: stack)
        posterLabel.width(to: stack)
        addButton.width(to: stack, offset: -24)
        skipButton.width(to: stack, offset: -24)
        posterLabel.height(68)
        
        stack.hideAndTriggerAll(onlyThese: [4, 5])
        
    }
}
