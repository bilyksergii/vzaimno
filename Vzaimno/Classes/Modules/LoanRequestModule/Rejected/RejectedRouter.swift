//
//  RejectedRouter.swift
//  Vzaimno
//
//  Created by Sergii Bilyk on 16.09.2021.
//

import Foundation

protocol RejectedRouterProtocol: BaseRouterProtocol {
	func showLoanRequestScreen()
}

class RejectedRouter: BaseRouter, RejectedRouterProtocol {

	func showLoanRequestScreen() {
		showNewСlientScreen()
	}
}
