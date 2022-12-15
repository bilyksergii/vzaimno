//
//  UniversalLinkService.swift
//  Vzaimno
//
//  Created by Sergii Bilyk on 06.10.2021.
//

import Foundation

enum PaymentResult {
	case success
	case error
	case notDetermined
}

protocol UniversalLinkServiceProtocol: AnyObject {
	func cheduleLink(url: URL)
	func checkPaymentResult() -> PaymentResult
	func resetPaymentResult()
}

final class UniversalLinkService: UniversalLinkServiceProtocol {

	// MARK: - Static

	static let shared = UniversalLinkService()

	// MARK: - Properties

	private var paymentResult: PaymentResult = .notDetermined

	// MARK: - Internal

	func cheduleLink(url: URL) {
		guard SecureService.shared.isAuth(),
			  let components = URLComponents(url: url, resolvingAgainstBaseURL: true) else { return }

		for queryItem in components.queryItems ?? [] {
			if queryItem.value == "error" {
				paymentResult = .error
				return
			}
		}

		if components.path == "/payresult" {
			paymentResult = .success
		}
	}

	func checkPaymentResult() -> PaymentResult {
		return paymentResult
	}

	func resetPaymentResult() {
		paymentResult = .notDetermined
	}
}
