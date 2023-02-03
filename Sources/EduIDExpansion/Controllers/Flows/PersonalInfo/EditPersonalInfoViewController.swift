//
//  EditPersonalInfoViewController.swift
//  
//
//  Created by Jairo Bambang Oetomo on 31/01/2023.
//

import UIKit
import TinyConstraints

class EditPersonalInfoViewController: UIViewController, ScreenWithScreenType {
   
    //MARK: screen type
    var screenType: ScreenType = .personalInfoLandingScreen
    
    //MARK: - delegate
    weak var delegate: PersonalInfoNavigationDelegate?
    
    private let scrollView = UIScrollView()
    
    //MARK: - lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        screenType.configureNavigationItem(item: navigationItem, target: self, action: #selector(dismissInfoScreen))
    }
    
    func setupUI() {
        
        //MARK: - scroll view
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        scrollView.edges(to: view)
        
        //MARK: - posterLabel
        let posterLabel = UILabel.posterTextLabelBicolor(text: "Your personal info", size: 24, primary: "Your personal info")
        
        //MARK: - create the textView
        let textLabelParent = UIView()
        let textLabel = UILabel()
        textLabel.numberOfLines = 0
        textLabel.isUserInteractionEnabled = false
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        textLabel.font = .sourceSansProLight(size: 16)
        textLabel.textColor = .secondaryColor
        let attributedText = NSMutableAttributedString(string:
"""
When you use eduID to login to other websites, some of your personal information will be shared. Some websites require that your personal information is validated by a third party.
"""
                                                       ,attributes: [.font : UIFont.sourceSansProLight(size: 16)])
        textLabel.attributedText = attributedText
        textLabelParent.addSubview(textLabel)
        textLabel.edges(to: textLabelParent)
        
        let spaceView = UIView()
        
        //MARK: - the info controls
        let firstTitle = NSAttributedString(string: "About you", attributes: [.font : UIFont.sourceSansProBold(size: 16), .foregroundColor: UIColor.charcoalColor])
        let firstBodyText = NSMutableAttributedString(string: "Your full name", attributes: [.font: UIFont.sourceSansProRegular(size: 16), .foregroundColor: UIColor.backgroundColor])
        firstBodyText.setAttributeTo(part: "full name", attributes: [.font: UIFont.sourceSansProSemiBold(size: 16), .foregroundColor: UIColor.backgroundColor])
        let firstControl = ActionableInfoControl(attributedTitle: firstTitle, attributedBodyText: firstBodyText, iconInBody: UIImage(systemName: "chevron.right")?.withRenderingMode(.alwaysTemplate), isFilled: true)
        
        let secondBodyText = NSMutableAttributedString(string: "Your email address", attributes: [.font: UIFont.sourceSansProRegular(size: 16), .foregroundColor: UIColor.backgroundColor])
        secondBodyText.setAttributeTo(part: "email address", attributes: [.font: UIFont.sourceSansProSemiBold(size: 16), .foregroundColor: UIColor.backgroundColor])
        let secondControl = ActionableInfoControl(attributedBodyText: secondBodyText, iconInBody: UIImage(systemName: "chevron.right"), isFilled: true)
        
        let thirdTitle = NSAttributedString(string: "About your education", attributes: [.font : UIFont.sourceSansProBold(size: 16), .foregroundColor: UIColor.charcoalColor])
        let thirdBodyText = NSMutableAttributedString(string: "Proof of being a student\nnot available yet", attributes: [.font: UIFont.sourceSansProRegular(size: 16), .foregroundColor: UIColor.charcoalColor])
        thirdBodyText.setAttributeTo(part: "being a student", attributes: [.font: UIFont.sourceSansProSemiBold(size: 16)])
        thirdBodyText.setAttributeTo(part: "not available yet", attributes: [.font: UIFont.sourceSansProLight(size: 12)])
        let thirdControl = ActionableInfoControl(attributedTitle: thirdTitle, attributedBodyText: thirdBodyText, iconInBody: UIImage(systemName: "chevron.right")?.withRenderingMode(.alwaysTemplate), isFilled: false)
        
        let fourthBodyText = NSMutableAttributedString(string: "Your link to a school/uni", attributes: [.font: UIFont.sourceSansProRegular(size: 16), .foregroundColor: UIColor.backgroundColor])
        fourthBodyText.setAttributeTo(part: "link to a school/uni", attributes: [.font: UIFont.sourceSansProSemiBold(size: 16), .foregroundColor: UIColor.backgroundColor])
        let fourthControl = ActionableInfoControl(attributedBodyText: fourthBodyText, iconInBody: UIImage(systemName: "chevron.right")?.withRenderingMode(.alwaysTemplate), isFilled: true)
        
        //MARK: - create the stackview
        let stack = UIStackView(arrangedSubviews: [posterLabel, textLabelParent, firstControl, secondControl, thirdControl, fourthControl, spaceView])
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
        firstControl.width(to: stack)
        secondControl.width(to: stack)
        thirdControl.width(to: stack)
        fourthControl.width(to: stack)
        
        //MARK: - actions
//        firstControl.addTarget(coordinator, action: #selector(PersonalInfoCoordinator.drillDown), for: .touchUpInside)
//        secondControl.addTarget(coordinator, action: #selector(PersonalInfoCoordinator.drillDown), for: .touchUpInside)
//        thirdControl.addTarget(coordinator, action: #selector(PersonalInfoCoordinator.drillDown), for: .touchUpInside)
//        fourthControl.addTarget(coordinator, action: #selector(PersonalInfoCoordinator.drillDown), for: .touchUpInside)
    }
    
    @objc
    func dismissInfoScreen() {
        delegate?.dismiss()
    }
}