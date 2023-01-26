import UIKit
import TinyConstraints

class TextViewBackgroundColor: UIView {

    init(attributedText: NSAttributedString, backgroundColor: UIColor, insets: UIEdgeInsets) {
        super.init(frame: .zero)
        
        self.backgroundColor = backgroundColor
        
        let textView = UITextView()
        textView.backgroundColor = .clear
        textView.attributedText = attributedText
        textView.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(textView)
        textView.edgesToSuperview(insets: TinyEdgeInsets(top: insets.top, left: insets.left, bottom: insets.bottom, right: insets.right))
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
