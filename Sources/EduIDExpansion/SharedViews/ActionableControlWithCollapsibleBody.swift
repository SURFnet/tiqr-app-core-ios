import UIKit
import TinyConstraints

enum Role: String {
    case student
    case employee
}

class ActionableControlWithCollapsibleBody: UIControl {

    private var stack: UIStackView!
    private var isExpanded = false
    
    //MARK: - init
    init(role: Role, institution: String, verifiedAt: Date, affiliation: String, expires: Date) {
        super.init(frame: .zero)
        
        setupUI(role: role, institution: institution, verifiedAt: verifiedAt, affiliation: affiliation, expires: expires)
        
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(expandOrContract)))
    }
            
    //MARK: - setup UI
    func setupUI(role: Role, institution: String, verifiedAt: Date, affiliation: String, expires: Date) {
        
        //body stackview
        let attributedStringBody = NSMutableAttributedString()
        let iconEmoji = role == .employee ? "🏢️" : "🧑‍🎓"
        attributedStringBody.append(NSAttributedString(string: "\(iconEmoji) \(role.rawValue.capitalized)", attributes: AttributedStringHelper.attributesSemiBoldSecondaryColor))
        attributedStringBody.append(NSAttributedString(string: "\n"))
        attributedStringBody.append(NSAttributedString(string: "At ", attributes: AttributedStringHelper.attributesRegularSecondaryColor))
        attributedStringBody.append(NSAttributedString(string: institution, attributes: [.font: UIFont.sourceSansProSemiBold(size: 16), .foregroundColor: UIColor.backgroundColor]))
        let bodyParent = UIView()
        let bodyLabel = UILabel()
        bodyParent.addSubview(bodyLabel)
        bodyLabel.edges(to: bodyParent)
        bodyLabel.numberOfLines = 0
        bodyLabel.attributedText = attributedStringBody
        
        let chevronImage = UIImageView(image: UIImage(systemName: "chevron.down")?.withRenderingMode(.alwaysTemplate))
        chevronImage.tintColor = .secondaryColor
        chevronImage.size(CGSize(width: 24, height: 24))
        
        let bodyStack = UIStackView(arrangedSubviews: [bodyParent, chevronImage])
        bodyStack.alignment = .center
        bodyStack.height(50)
        
        // verfied by
        let verifiedParent = UIView()
        let verifiedLabel = UILabel()
        verifiedParent.addSubview(verifiedLabel)
        verifiedLabel.edges(to: verifiedParent)
        let verifiedFormatted = String(format: NSLocalizedString(LocalizedKey.Profile.verifiedAt, bundle: .module, comment: ""), locale: nil, institution, ActionableControlWithCollapsibleBody.dateFormatter.string(from: verifiedAt))
        let verifiedAttributedString = NSMutableAttributedString(string: verifiedFormatted, attributes: AttributedStringHelper.attributesRegularSecondaryColor)
        verifiedAttributedString.setAttributeTo(part: institution, attributes: AttributedStringHelper.attributesSemiBoldSecondaryColor)
        verifiedLabel.attributedText = verifiedAttributedString
        
        // line 2
        let line2 = UIView()
        line2.height(1)
        line2.backgroundColor = .secondaryColor
        
        // institution
        let institutionlabelLabel = UILabel()
        let institutionlabelAttributedString = NSAttributedString(string: NSLocalizedString(LocalizedKey.Profile.institution, bundle: .module, comment: ""), attributes: AttributedStringHelper.attributesRegularSecondaryColor)
        institutionlabelLabel.attributedText = institutionlabelAttributedString
        
        let institutionLabel = UILabel()
        let institutionLabelAttributedString = NSAttributedString(string: institution, attributes: AttributedStringHelper.attributesSemiBoldSecondaryColor)
        institutionLabel.attributedText = institutionLabelAttributedString
        
        let institutionStack = UIStackView(arrangedSubviews: [institutionlabelLabel, institutionLabel])
        institutionStack.axis = .horizontal
        institutionStack.distribution = .fillEqually
        
        // line 3
        let line3 = UIView()
        line3.height(1)
        line3.backgroundColor = .secondaryColor
        
        // affiliations
        let affiliationslabelLabel = UILabel()
        let affiliationslabelAttributedString = NSAttributedString(string: NSLocalizedString(LocalizedKey.Profile.affiliations, bundle: .module, comment: ""), attributes: AttributedStringHelper.attributesRegularSecondaryColor)
        affiliationslabelLabel.attributedText = affiliationslabelAttributedString
        
        let affiliationsLabel = UILabel()
        let affiliationsLabelAttributedString = NSAttributedString(string: affiliation, attributes: AttributedStringHelper.attributesSemiBoldSecondaryColor)
        affiliationsLabel.attributedText = affiliationsLabelAttributedString
        
        let affiliationsStack = UIStackView(arrangedSubviews: [affiliationslabelLabel, affiliationsLabel])
        affiliationsStack.axis = .horizontal
        affiliationsStack.distribution = .fillEqually
        
        // line 4
        let line4 = UIView()
        line4.height(1)
        line4.backgroundColor = .secondaryColor
        
        // link expires
        let expireslabelLabel = UILabel()
        let expireslabelAttributedString = NSAttributedString(string: NSLocalizedString(LocalizedKey.Profile.expires, bundle: .module, comment: ""), attributes: AttributedStringHelper.attributesRegularSecondaryColor)
        expireslabelLabel.attributedText = expireslabelAttributedString
        
        let expiresLabel = UILabel()
        let expiresLabelAttributedString = NSAttributedString(string: ActionableControlWithCollapsibleBody.dateFormatter.string(from: expires), attributes: AttributedStringHelper.attributesSemiBoldSecondaryColor)
        expiresLabel.attributedText = expiresLabelAttributedString
        
        let expiresStack = UIStackView(arrangedSubviews: [expireslabelLabel, expiresLabel])
        expiresStack.axis = .horizontal
        expiresStack.distribution = .fillEqually
        
        // line 5
        let line5 = UIView()
        line5.height(1)
        line5.backgroundColor = .secondaryColor
        
        // remove button
        let button = EduIDButton(type: .ghost, buttonTitle: NSLocalizedString(LocalizedKey.Institution.delete, bundle: .module, comment: ""), isDelete: true)
        
        stack = UIStackView(arrangedSubviews: [bodyStack, verifiedParent, line2, institutionStack, line3, affiliationsStack, line4, expiresStack, line5, button])
        stack.axis = .vertical
        stack.distribution = .equalSpacing
        stack.spacing = 18
        
        addSubview(stack)
        stack.edges(to: self, insets: TinyEdgeInsets(top: 16, left: 18, bottom: 16, right: 18))
        
        //border
        layer.borderWidth = 3
        layer.borderColor = UIColor.backgroundColor.cgColor
        layer.cornerRadius = 6
        
        // initially contract elements
        for i in (1..<stack.arrangedSubviews.count) {
            stack.arrangedSubviews[i].isHidden = true
            stack.arrangedSubviews[i].alpha = 0 
        }
    }
    
    //MARK: - expand or contract action
    @objc
    func expandOrContract() {
        UIView.animate(withDuration: 0.3) { [weak self] in
            for i in (1..<(self?.stack.arrangedSubviews.count ?? 0)) {
                self?.stack.arrangedSubviews[i].isHidden = self?.isExpanded ?? true
                self?.stack.arrangedSubviews[i].alpha = (self?.isExpanded ?? true) ? 0 : 1
            }
        }
        isExpanded.toggle()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    static var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, MMM d, yyyy"
        return formatter
    }
    
}
