import UIKit
import TinyConstraints

class ActionableControlWithCollapsibleBody: UIControl {

    private var stack: UIStackView!
    private var isExpanded = false
    private var removeAction: () -> Void
    
    var institution: String
    
    //MARK: - init
    init(role: Affiliation, institution: String, verifiedAt: Date, affiliation: String, expires: Date, removeAction: @escaping () -> Void) {
        self.institution = institution
        self.removeAction = removeAction
        super.init(frame: .zero)
        
        setupUI(role: role, institution: institution, verifiedAt: verifiedAt, affiliation: affiliation, expires: expires)
        
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(expandOrContract)))
    }
            
    //MARK: - setup UI
    func setupUI(role: Affiliation, institution: String, verifiedAt: Date, affiliation: String, expires: Date) {
        
        backgroundColor = .disabledGrayBackground
        
        //body stackview
        let attributedStringBody = NSMutableAttributedString()
        let iconEmoji = role == .employee ? "🏢️" : "🧑‍🎓"
        attributedStringBody.append(NSAttributedString(string: "\(iconEmoji) \(role.rawValue.capitalized)", attributes: AttributedStringHelper.attributes(font: .sourceSansProSemiBold(size: 14), color: .secondaryColor, lineSpacing: 6)))
        attributedStringBody.append(NSAttributedString(string: "\n"))
        attributedStringBody.append(NSAttributedString(string: "At ", attributes: AttributedStringHelper.attributes(font: .sourceSansProRegular(size: 14), color: .secondaryColor, lineSpacing: 6)))
        attributedStringBody.append(NSAttributedString(string: institution, attributes:AttributedStringHelper.attributes(font: .sourceSansProSemiBold(size: 16), color: .backgroundColor, lineSpacing: 6)))
        let bodyParent = UIView()
        let bodyLabel = UILabel()
        bodyParent.addSubview(bodyLabel)
        bodyLabel.edges(to: bodyParent)
        bodyLabel.numberOfLines = 0
        bodyLabel.attributedText = attributedStringBody
        
        let chevronImage = UIImageView(image: UIImage(systemName: "chevron.down")?.withRenderingMode(.alwaysTemplate))
        chevronImage.tintColor = .backgroundColor
        chevronImage.size(CGSize(width: 24, height: 24))
        
        let bodyStack = UIStackView(arrangedSubviews: [bodyParent, chevronImage])
        bodyStack.alignment = .center
        bodyStack.height(50)
        
        // verfied by
        let verifiedParent = UIView()
        let verifiedLabel = UILabel()
        verifiedLabel.numberOfLines = 0
        verifiedParent.addSubview(verifiedLabel)
        verifiedLabel.edges(to: verifiedParent)
        let verifiedFormatted = String(format: NSLocalizedString(LocalizedKey.Profile.verifiedAt, bundle: .module, comment: ""), locale: nil, institution, ActionableControlWithCollapsibleBody.dateFormatter.string(from: verifiedAt))
        let verifiedAttributedString = NSMutableAttributedString(string: verifiedFormatted, attributes: AttributedStringHelper.attributes(font: .sourceSansProRegular(size: 14), color: .secondaryColor, lineSpacing: 6))
        verifiedAttributedString.setAttributeTo(part: institution, attributes: AttributedStringHelper.attributes(font: .sourceSansProRegular(size: 14), color: .secondaryColor, lineSpacing: 6))
        verifiedLabel.attributedText = verifiedAttributedString
        
        // line 2
        let line2 = UIView()
        line2.height(1)
        line2.backgroundColor = .backgroundColor
        
        // institution
        let institutionlabelLabel = UILabel()
        let institutionlabelAttributedString = NSAttributedString(string: NSLocalizedString(LocalizedKey.Profile.institution, bundle: .module, comment: ""), attributes: AttributedStringHelper.attributes(font: .sourceSansProRegular(size: 14), color: .secondaryColor, lineSpacing: 6))
        institutionlabelLabel.attributedText = institutionlabelAttributedString
        
        let institutionLabel = UILabel()
        let institutionLabelAttributedString = NSAttributedString(string: institution, attributes: AttributedStringHelper.attributes(font: .sourceSansProSemiBold(size: 14), color: .secondaryColor, lineSpacing: 6))
        institutionLabel.attributedText = institutionLabelAttributedString
        
        let institutionStack = UIStackView(arrangedSubviews: [institutionlabelLabel, institutionLabel])
        institutionStack.axis = .horizontal
        institutionStack.distribution = .fillEqually
        
        // line 3
        let line3 = UIView()
        line3.height(1)
        line3.backgroundColor = .backgroundColor
        
        // affiliations
        let affiliationslabelLabel = UILabel()
        let affiliationslabelAttributedString = NSAttributedString(string: NSLocalizedString(LocalizedKey.Profile.affiliations, bundle: .module, comment: ""), attributes: AttributedStringHelper.attributes(font: .sourceSansProRegular(size: 14), color: .secondaryColor, lineSpacing: 6))
        affiliationslabelLabel.attributedText = affiliationslabelAttributedString
        
        let affiliationsLabel = UILabel()
        let affiliationsLabelAttributedString = NSAttributedString(string: affiliation, attributes: AttributedStringHelper.attributes(font: .sourceSansProSemiBold(size: 14), color: .secondaryColor, lineSpacing: 6))
        affiliationsLabel.attributedText = affiliationsLabelAttributedString
        
        let affiliationsStack = UIStackView(arrangedSubviews: [affiliationslabelLabel, affiliationsLabel])
        affiliationsStack.axis = .horizontal
        affiliationsStack.distribution = .fillEqually
        
        // line 4
        let line4 = UIView()
        line4.height(1)
        line4.backgroundColor = .backgroundColor
        
        // link expires
        let expireslabelLabel = UILabel()
        let expireslabelAttributedString = NSAttributedString(string: NSLocalizedString(LocalizedKey.Profile.expires, bundle: .module, comment: ""), attributes: AttributedStringHelper.attributes(font: .sourceSansProRegular(size: 14), color: .secondaryColor, lineSpacing: 6))
        expireslabelLabel.attributedText = expireslabelAttributedString
        
        let expiresLabel = UILabel()
        let expiresLabelAttributedString = NSAttributedString(string: ActionableControlWithCollapsibleBody.dateFormatter.string(from: expires), attributes: AttributedStringHelper.attributes(font: .sourceSansProSemiBold(size: 14), color: .secondaryColor, lineSpacing: 6))
        expiresLabel.attributedText = expiresLabelAttributedString
        
        let expiresStack = UIStackView(arrangedSubviews: [expireslabelLabel, expiresLabel])
        expiresStack.axis = .horizontal
        expiresStack.distribution = .fillEqually
        
        // line 5
        let line5 = UIView()
        line5.height(1)
        line5.backgroundColor = .backgroundColor
        
        // remove button
        let button = EduIDButton(type: .ghost, buttonTitle: NSLocalizedString(LocalizedKey.Institution.delete, bundle: .module, comment: ""), isDelete: true)
        button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        
        stack = UIStackView(arrangedSubviews: [bodyStack, verifiedParent, line2, institutionStack, line3, affiliationsStack, line4, expiresStack, line5, button])
        stack.axis = .vertical
        stack.distribution = .equalSpacing
        stack.spacing = 18
        
        addSubview(stack)
        stack.edges(to: self, insets: TinyEdgeInsets(top: 12, left: 18, bottom: 12, right: 18))
        
        //border
        layer.borderWidth = 3
        layer.borderColor = UIColor.backgroundColor.cgColor
        layer.cornerRadius = 6
        
        // initially hide elements
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
    
    @objc
    func buttonAction() {
        removeAction()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    static var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .full
        return formatter
    }
    
}
