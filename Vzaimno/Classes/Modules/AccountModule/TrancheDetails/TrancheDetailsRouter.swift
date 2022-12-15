//
//  TrancheDetailsRouter.swift
//  Vzaimno
//
//  Created by Sergii Bilyk on 11.09.2021.
//

import Foundation

protocol TrancheDetailsRouterProtocol: BaseRouterProtocol {
	func showPaymentsGraphic(paymentsGraphic: [TrancheDetails.Loan.Graphic])
	func showPaymentsHistory(paymentsHistory: [TrancheDetails.Loan.History])
}

class TrancheDetailsRouter: BaseRouter, TrancheDetailsRouterProtocol {

	func showPaymentsGraphic(paymentsGraphic: [TrancheDetails.Loan.Graphic]) {
		let vc = PaymentsGraphicViewController.controller(paymentsGraphic: paymentsGraphic)
		sourceViewController?.navigationController?.pushViewController(vc, animated: true)
	}

	func showPaymentsHistory(paymentsHistory: [TrancheDetails.Loan.History]) {
		let vc = PaymentsHistoryViewController.controller(paymentsHistory: paymentsHistory)
		sourceViewController?.navigationController?.pushViewController(vc, animated: true)
	}
}
