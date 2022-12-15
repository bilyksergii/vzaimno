//
//  BaseRouter.swift
//  Vzaimno
//
//  Created by Sergii Bilyk on 26.06.2021.
//

import UIKit

protocol BaseRouterProtocol: AnyObject {
	func showAuth()
	func showWebViewScreen(url: URL?, htmlString: String?, moveCloseButton: Bool?)
	func showNewСlientScreen()
	func showRejectedScreen()
	func showThankYouPageScreen(fromAccount: Bool, text: String?, photos: [Photo]?)
	func showAccountScreen()
	func showTranche(isSecond: Bool, id_form: String, showModal: Bool)
	func showPayment()
	func showPaymentResultScreen(_ paymentResult: PaymentResult)
	func logout()
}

extension BaseRouterProtocol {
	func showTranche(isSecond: Bool, id_form: String, showModal: Bool = false) {
		showTranche(isSecond: isSecond, id_form: id_form, showModal: showModal)
	}
}

class BaseRouter: BaseRouterProtocol {

	weak var sourceViewController: BaseViewController?

	init(sourceViewController: BaseViewController?) {
		self.sourceViewController = sourceViewController
	}

	func showAuth() {
		let vc = AuthViewController.controller()
		sourceViewController?.navigationController?.pushViewController(vc, animated: true)
	}

	func showWebViewScreen(url: URL? = nil, htmlString: String? = nil, moveCloseButton: Bool? = nil) {
		let vc = WebDocViewController.controller(url: url, htmlString: htmlString)
		vc.modalPresentationStyle = .fullScreen
		sourceViewController?.present(vc, animated: true, completion: nil)
	}

	func logout() {
		NotificationCenter.default.post(name: .didLogout, object: nil)
	}

	func showPayment() {
		if let paymentUrl = URL(string: Constants.paymentUrlString), UIApplication.shared.canOpenURL(paymentUrl) {
			UIApplication.shared.open(paymentUrl)
		}
	}

	func showPaymentResultScreen(_ paymentResult: PaymentResult) {
		let vc = PaymentResultViewController.controller(paymentResult: paymentResult)
		vc.modalPresentationStyle = .overFullScreen
		vc.modalTransitionStyle = .crossDissolve
		sourceViewController?.present(vc, animated: true, completion: nil)
	}

	//Methods of getFirstScreen

	func showNewСlientScreen() {
		let vc = LoanRequestViewController.controller()
		sourceViewController?.navigationController?.pushViewController(vc, animated: true)
	}

	func showRejectedScreen() {
		let vc = RejectedViewController.controller()
		sourceViewController?.navigationController?.pushViewController(vc, animated: true)
	}

	func showThankYouPageScreen(fromAccount: Bool, text: String?, photos: [Photo]?) {
		let vc = UploadPhotoViewController.controller(fromAccount: fromAccount, text: text, photos: photos)
		sourceViewController?.navigationController?.pushViewController(vc, animated: true)
	}

	func showAccountScreen() {
		let vc = MainTabBarViewController.controller()
		sourceViewController?.navigationController?.pushViewController(vc, animated: true)
	}

	func showTranche(isSecond: Bool, id_form: String, showModal: Bool = false) {
		let vc = TrancheViewController.controller(isSecond: isSecond, id_form: id_form, showModal: showModal)
		sourceViewController?.navigationController?.pushViewController(vc, animated: true)
	}
}
