//
//  NSAttributedString+Styling.swift
//  eduID
//
//  Created by Jairo Bambang Oetomo on 20/01/2023.
//

import UIKit

extension NSMutableAttributedString {
    func setAttributeTo(part: String, attributes: [NSAttributedString.Key: Any]?) {
        setAttributes(attributes, range: string.range(of: part)?.nsRange(in: string) ?? NSRange())
                            
    }
}

extension RangeExpression where Bound == String.Index  {
    func nsRange<S: StringProtocol>(in string: S) -> NSRange { .init(self, in: string) }
}

struct AttributedStringHelper {
    static let attributesRegularSecondaryColor: [NSAttributedString.Key: Any] = [
        .font: UIFont.sourceSansProRegular(size: 16),
        .foregroundColor: UIColor.secondaryColor
    ]
    
    static let attributesSemiBoldSecondaryColor: [NSAttributedString.Key: Any] = [
        .font: UIFont.sourceSansProSemiBold(size: 16),
        .foregroundColor: UIColor.secondaryColor
    ]
    
    static let attributesBoldSecondaryColor: [NSAttributedString.Key: Any] = [
        .font: UIFont.sourceSansProBold(size: 16),
        .foregroundColor: UIColor.secondaryColor
    ]
}
