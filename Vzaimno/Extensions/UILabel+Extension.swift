//
//  UILabel+Extension.swift
//  Vzaimno
//
//  Created by Sergii Bilyk on 04.08.2021.
//

import UIKit

extension UILabel {

	func setUnderlinedText(_ string: String, font: UIFont?, color: UIColor, lineSpacing: CGFloat = 5.0) {
		let paragraphStyle = NSMutableParagraphStyle()
		paragraphStyle.lineSpacing = lineSpacing

		let attributes: [NSAttributedString.Key: Any] = [
			.font: font ?? UIFont.systemFont(ofSize: 13) as Any,
			.foregroundColor: color,
			.underlineStyle: NSUnderlineStyle.single.rawValue
		]
		let attributedString = NSMutableAttributedString(
			string: string,
			attributes: attributes
		)

		attributedString.addAttribute(NSAttributedString.Key.paragraphStyle,
									  value: paragraphStyle,
									  range:NSMakeRange(0, attributedString.length))

		self.attributedText = attributedString
	}

	func setLineSpacing(lineSpacing: CGFloat = 6.0) {
		guard let labelText = self.text else { return }

		let paragraphStyle = NSMutableParagraphStyle()
		paragraphStyle.lineSpacing = lineSpacing

		let attributedString: NSMutableAttributedString
		if let labelattributedText = self.attributedText {
			attributedString = NSMutableAttributedString(attributedString: labelattributedText)
		} else {
			attributedString = NSMutableAttributedString(string: labelText)
		}

		attributedString.addAttribute(NSAttributedString.Key.paragraphStyle,
									  value: paragraphStyle,
									  range: NSMakeRange(0, attributedString.length))

		self.attributedText = attributedString
	}
}
