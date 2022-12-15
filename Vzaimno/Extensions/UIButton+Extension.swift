//
//  UIButton+Extension.swift
//  Vzaimno
//
//  Created by Sergii Bilyk on 28.06.2021.
//

import UIKit

extension UIButton {

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
									  range: NSMakeRange(0, attributedString.length))

		self.setAttributedTitle(attributedString, for: .normal)
	}

	func setLineSpacing(lineSpacing: CGFloat = 5.0) {
		guard let buttonText = self.titleLabel?.text else { return }

		let paragraphStyle = NSMutableParagraphStyle()
		paragraphStyle.lineSpacing = lineSpacing

		let attributedString: NSMutableAttributedString
		if let labelattributedText = self.titleLabel?.attributedText {
			attributedString = NSMutableAttributedString(attributedString: labelattributedText)
		} else {
			attributedString = NSMutableAttributedString(string: buttonText)
		}

		attributedString.addAttribute(NSAttributedString.Key.paragraphStyle,
									  value: paragraphStyle,
									  range: NSMakeRange(0, attributedString.length))
		self.setAttributedTitle(attributedString, for: .normal)
	}
}
