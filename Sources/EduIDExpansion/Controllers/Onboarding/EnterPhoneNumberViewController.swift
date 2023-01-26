//
//  PhoneChallengeViewController.swift
//  eduID
//
//  Created by Jairo Bambang Oetomo on 20/01/2023.
//

import UIKit
import TinyConstraints

class EnterPhoneNumberViewController: EduIDBaseViewController, ValidatedTextFieldDelegate {
    
    var stack: AnimatedVStackView!
    
    //MARK: - phone textfield
    let validatedPhoneTextField = EduIDValidatedTextStackView(title: "Enter your phone number", placeholder: "e.g. 0612345678", keyboardType: .numberPad)
    
    //MARK: - verify button
    let verifyButton = EduIDButton(type: .primary, buttonTitle: "Verify this phone number")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        verifyButton.addTarget(self, action: #selector(showNextScreen), for: .touchUpInside)
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(resignKeyboardResponder)))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        stack.animate(onlyThese: [2])
    }
    
    func setupUI() {
        
        //MARK: - phone textfield delegate
        validatedPhoneTextField.delegate = self
        
        //MARK: - button state
        verifyButton.isEnabled = false
        
        //MARK: - posterLabel
        let posterLabel = UILabel.posterTextLabel(text: "Your eduID has been created", size: 24)
        
        //MARK: - create the textView
        let textView = UITextView()
        textView.isUserInteractionEnabled = false
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.font = .sourceSansProLight(size: 16)
        textView.textColor = .secondaryColor
        let attributedText = NSMutableAttributedString(string:
"""
Let’s add a recovery phonenumber
If you can't access eduID with the app or via email, you can use this to sign in to your eduID Account.

We will text you a code to verify your number.
"""
                                                ,attributes: [.font : UIFont.sourceSansProLight(size: 16)])
        attributedText.setAttributes([.font : UIFont.sourceSansProSemiBold(size: 16)], range: NSRange(location: 0, length: 32))
        textView.attributedText = attributedText
        
        //MARK: - Space
        let spaceView = UIView()
        
        //MARK: - create the stackview
        stack = AnimatedVStackView(arrangedSubviews: [posterLabel, textView, validatedPhoneTextField, spaceView, verifyButton])
        stack.axis = .vertical
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.distribution = .fill
        stack.alignment = .center
        stack.spacing = 32
        view.addSubview(stack)
        
        //MARK: - add constraints
        stack.edgesToSuperview(insets: TinyEdgeInsets(top: 24, left: 24, bottom: 24, right: 24), usingSafeArea: true)
        textView.width(to: stack)
        textView.height(120)
        posterLabel.height(34)
        verifyButton.width(to: stack, offset: -24)
        validatedPhoneTextField.width(to: stack)
        
        stack.hideAndTriggerAll(onlyThese: [2])
    }
    
    //MARK: - textfield validation method
    func updateValidation(with value: Bool, from tag: Int) {
        verifyButton.isEnabled = value
    }
    
    func keyBoardDidReturn(tag: Int) {
        resignKeyboardResponder()
    }
    
    @objc
    func resignKeyboardResponder() {
        _ = validatedPhoneTextField.resignFirstResponder()
    }
    
}
