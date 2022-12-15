//
//  AuthRouter.swift
//  Vzaimno
//
//  Created by Sergii Bilyk on 26.06.2021.
//

import UIKit

protocol AuthRouterProtocol: BaseRouterProtocol {
	func showPhoneConfirmation(phone: String)
}

class AuthRouter: BaseRouter, AuthRouterProtocol {

	func showPhoneConfirmation(phone: String) {
		let vc = SmsCodeViewController.controller(phone: phone)
		sourceViewController?.navigationController?.pushViewController(vc, animated: true)
	}
}
