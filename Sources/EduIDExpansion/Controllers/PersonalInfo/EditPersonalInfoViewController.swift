//
//  EditPersonalInfoViewController.swift
//  
//
//  Created by Jairo Bambang Oetomo on 31/01/2023.
//

import UIKit
import TinyConstraints

class EditPersonalInfoViewController: EduIDBaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }
    
    func setupUI() {
        
        //MARK: - posterLabel
        let posterLabel = UILabel.posterTextLabelBicolor(text: "Your personal info", size: 24, primary: "Your personal info")
        
        //MARK: - create the textView
        let textView = UITextView()
        textView.isUserInteractionEnabled = false
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.font = .sourceSansProLight(size: 16)
        textView.textColor = .secondaryColor
        let attributedText = NSMutableAttributedString(string:
"""
When you use eduID to login to other websites, some of your personal information will be shared. Some websites require that your personal information is validated by a third party.
"""
                                                       ,attributes: [.font : UIFont.sourceSansProLight(size: 16)])
        textView.attributedText = attributedText
        
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
        let stack = UIStackView(arrangedSubviews: [posterLabel, textView, firstControl, secondControl, thirdControl, fourthControl, spaceView])
        stack.axis = .vertical
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.distribution = .fill
        stack.alignment = .center
        stack.spacing = 20
        view.addSubview(stack)
        
        //MARK: - add constraints
        stack.edgesToSuperview(insets: TinyEdgeInsets(top: 24, left: 24, bottom: 24, right: 24), usingSafeArea: true)
        textView.width(to: stack)
        textView.height(90)
        posterLabel.width(to: stack)
        firstControl.width(to: stack)
        secondControl.width(to: stack)
        thirdControl.width(to: stack)
        fourthControl.width(to: stack)
        
        //MARK: - actions
        firstControl.addTarget(coordinator, action: #selector(PersonalInfoCoordinator.drillDown), for: .touchUpInside)
    }
}
