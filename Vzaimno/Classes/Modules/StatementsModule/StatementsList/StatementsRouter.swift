//
//  StatementsRouter.swift
//  Vzaimno
//
//  Created by Sergii Bilyk on 22.09.2021.
//

import Foundation

protocol StatementsRouterProtocol: BaseRouterProtocol {
	func showNewStatement()
	func openStatement(_ statement: Statement)
}

class StatementsRouter: BaseRouter, StatementsRouterProtocol {

	func showNewStatement() {
		let vc = NewStatementViewController.controller()
		sourceViewController?.navigationController?.pushViewController(vc, animated: true)
	}

	func openStatement(_ statement: Statement) {
		let vc = StatementViewController.controller(statement: statement)
		sourceViewController?.navigationController?.pushViewController(vc, animated: true)
	}
}
