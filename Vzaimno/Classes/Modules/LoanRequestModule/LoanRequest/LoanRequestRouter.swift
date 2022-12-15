//
//  LoanRequestRouter.swift
//  Vzaimno
//
//  Created by Sergii Bilyk on 08.07.2021.
//

import Foundation

protocol LoanRequestRouterProtocol: BaseRouterProtocol {
	func showNextScreen()
}

class LoanRequestRouter: BaseRouter, LoanRequestRouterProtocol {

	func showNextScreen() {
		sourceViewController?.basePresenter.getFirstScreen()
	}
}
