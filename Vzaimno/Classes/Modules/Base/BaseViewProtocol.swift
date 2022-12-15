//
//  BaseViewProtocol.swift
//  Vzaimno
//
//  Created by Sergii Bilyk on 26.06.2021.
//

import Foundation
import Toast_Swift

protocol BaseViewProtocol: AnyObject {
	func showLoader()
	func hideLoader()
	func showToastMessage(_ message: String, type: ToastType, position: ToastPosition, duration: TimeInterval)
}

extension BaseViewProtocol {

	func showToastMessage(_ message: String, type: ToastType) {
		showToastMessage(message, type: type, position: .center, duration: 2.0)
	}

	func showToastMessage(_ message: String, type: ToastType, duration: TimeInterval) {
		showToastMessage(message, type: type, position: .center, duration: duration)
	}
}
