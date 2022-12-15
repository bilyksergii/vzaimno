//
//  UIView+Extension.swift
//  Vzaimno
//
//  Created by Sergii Bilyk on 26.08.2021.
//

import UIKit

extension UIView {

	func rotate(_ toValue: CGFloat, duration: CFTimeInterval = 0.2) {
		let animation = CABasicAnimation(keyPath: "transform.rotation")

		animation.toValue = toValue
		animation.duration = duration
		animation.isRemovedOnCompletion = false
		animation.fillMode = CAMediaTimingFillMode.forwards

		self.layer.add(animation, forKey: nil)
	}
}
