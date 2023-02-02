import UIKit
import TinyConstraints

class ExplanationViewController: EduIDBaseViewController {
    
    private var stack: AnimatedVStackView!
    
    //MARK: -lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    //MARK: - setup UI
    func setupUI() {
        
        //MARK: - create Label
        let posterLabel = UILabel.posterTextLabel(text: "Don't have an eduID yet?", size: 24)
        
        //MARK: - create the textView
        let textLabelParent = UIView()
        let textLabel = UILabel()
        textLabel.numberOfLines = 0
        textLabel.isUserInteractionEnabled = false
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 24 - 16
        let attrText = NSMutableAttributedString(string:
"""
eduID is a central account for users\nassociated with Dutch education and\nresearch. It is yours and exists independent\nof an educational institution.\n\n• Use it to login to several services connected to SURFconext.\n• Users without an institution account can also request an eduID.\n• eduID is a lifelong account. It stays validafter you graduate.
"""
                                                 , attributes: [.paragraphStyle: paragraphStyle, .font: UIFont.sourceSansProLight(size: 16), .foregroundColor: UIColor.secondaryColor])
        textLabel.attributedText = attrText
        textLabelParent.addSubview(textLabel)
        textLabel.edges(to: textLabelParent)
        
        //MARK: - create button
        let button = EduIDButton(type: .primary, buttonTitle: "Create a new eduID")
        
        //the action for this buton is defined in superclass
        button.addTarget(self, action: #selector(showNextScreen), for: .touchUpInside)
        
        //MARK: - spacing
        let spacerView = UIView()
        
        //MARK: - create the stackview
        stack = AnimatedVStackView(arrangedSubviews: [posterLabel, textLabelParent, spacerView, button])
        stack.axis = .vertical
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.distribution = .fill
        stack.alignment = .center
        stack.spacing = 32
        view.addSubview(stack)
        
        //MARK: - add constraints
        stack.edgesToSuperview(insets: TinyEdgeInsets(top: 24, left: 24, bottom: 24, right: 24), usingSafeArea: true)
        
        posterLabel.height(34)
        button.width(to: stack, offset: -24)
        
        textLabel.width(to: stack, offset: -32)
        
        stack.hideAndTriggerAll(onlyThese: [2])
    }
}
