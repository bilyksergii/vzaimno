//
//  UIViewController+Extension.swift
//  Vzaimno
//
//  Created by Sergii Bilyk on 05.08.2021.
//

import UIKit
import Toast_Swift

enum ToastType {
	case success
	case error
	case info

	var backgroundColor: UIColor {
		switch self {
		case .success: return .greenToastColor
		case .error: return .redToastColor
		case .info: return .grayToastColor
		}
	}

	var messageColor: UIColor {
		return .white
	}
}

extension UIViewController {

	func showToast(message: String, type: ToastType, position: ToastPosition = .bottom, duration: TimeInterval = 2.0) {
		var style = ToastStyle()
		style.messageColor = type.messageColor
		style.backgroundColor = type.backgroundColor
		style.displayShadow = true
		view.makeToast(message,
					   duration: type == .error ? 3600.0 : duration,
					   position: position,
					   style: style)
	}

	func topmostPresentedVC() -> UIViewController {
		var retVal = self
		while let presentedVC = retVal.presentedViewController { retVal = presentedVC }
		return retVal
	}

	func topmostViewController() -> UIViewController? {
		if let nc = self as? UINavigationController, let vc = nc.viewControllers.last {
			return vc.topmostViewController()
		}
		if let tabBarVC = self as? UITabBarController, let vc = tabBarVC.selectedViewController {
			return vc.topmostViewController()
		}
		return self
	}

	func encodeDictToJSON(dict: [String: String]) -> String {
		let encoder = JSONEncoder()
		if let jsonData = try? encoder.encode(dict) {
			if let jsonString = String(data: jsonData, encoding: .utf8) {
				return jsonString
			}
		}
		return ""
	}
}
