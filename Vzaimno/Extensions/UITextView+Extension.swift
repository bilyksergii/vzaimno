//
//  UITextView+Extension.swift
//  Vzaimno
//
//  Created by Sergii Bilyk on 29.09.2021.
//

import UIKit

extension UITextView {

	func setLineSpacing(lineSpacing: CGFloat = 6.0) {
		guard let textViewText = self.text else { return }

		let paragraphStyle = NSMutableParagraphStyle()
		paragraphStyle.lineSpacing = lineSpacing

		let attributedString: NSMutableAttributedString
		if let labelattributedText = self.attributedText {
			attributedString = NSMutableAttributedString(attributedString: labelattributedText)
		} else {
			attributedString = NSMutableAttributedString(string: textViewText)
		}

		attributedString.addAttribute(NSAttributedString.Key.paragraphStyle,
									  value: paragraphStyle,
									  range: NSMakeRange(0, attributedString.length))

		self.attributedText = attributedString
	}
}
