//
//  UIStackView+Extension.swift
//  Vzaimno
//
//  Created by Sergii Bilyk on 08.10.2021.
//

import UIKit

extension UIStackView {
	func addBackground(color: UIColor, rounded: Bool = false) {
		let subView = UIView(frame: bounds)
		subView.backgroundColor = color
		subView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
		if rounded {
			subView.layer.cornerRadius = 8
		}
		insertSubview(subView, at: 0)
	}

	func addBlueBorders(color: UIColor = UIColor.mainBlueColor) {
		let subView = UIView(frame: bounds)
		subView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
		subView.layer.borderWidth = 1
		subView.layer.borderColor = color.cgColor
		subView.layer.cornerRadius = 8
		insertSubview(subView, at: 0)
	}
}
