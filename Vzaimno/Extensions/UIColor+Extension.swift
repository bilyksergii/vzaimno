//
//  UIColor+Extension.swift
//  Vzaimno
//
//  Created by Sergii Bilyk on 28.06.2021.
//

import UIKit

extension UIColor {

	static let mainBlueColor = UIColor(hex: 0x0046AD)
	static let greenToastColor = UIColor(hex: 0x31AD36)
	static let redToastColor = UIColor(hex: 0xBE3616)
	static let grayToastColor = UIColor(hex: 0x787878)
	static let lightGrayColor = UIColor(hex: 0xBEBEBE)
	static let darkGrayColor = UIColor(hex: 0x6E6E6E)

	convenience init(hex: Int, alpha: CGFloat = 1) {
		let components = (
			R: CGFloat((hex >> 16) & 0xff) / 255,
			G: CGFloat((hex >> 08) & 0xff) / 255,
			B: CGFloat((hex >> 00) & 0xff) / 255
		)

		self.init(red: components.R, green: components.G, blue: components.B, alpha: alpha)
	}

	static func hexStringToUIColor(hex: String) -> UIColor {
		var cString: String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()

		if (cString.hasPrefix("#")) {
			cString.remove(at: cString.startIndex)
		}

		if ((cString.count) != 6) {
			return UIColor.gray
		}

		var rgbValue: UInt64 = 0
		Scanner(string: cString).scanHexInt64(&rgbValue)

		return UIColor(
			red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
			green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
			blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
			alpha: CGFloat(1.0)
		)
	}
}
