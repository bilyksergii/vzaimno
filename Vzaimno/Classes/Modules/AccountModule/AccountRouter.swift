//
//  AccountRouter.swift
//  Vzaimno
//
//  Created by Sergii Bilyk on 16.08.2021.
//

import Foundation

protocol AccountRouterProtocol: BaseRouterProtocol {
	func showSigningScreen(showTranche: Bool)
	func showTranchesList(tranches: [AccountData.Loan.Tranche], loanIsOpened: Bool, id_form_root: String?)
	func showTrancheDetails(tranche: AccountData.Loan.Tranche, loanIsOpened: Bool, id_form_root: String?)
}

class AccountRouter: BaseRouter, AccountRouterProtocol {

	func showSigningScreen(showTranche: Bool) {
		let vc = SigningViewController.controller(showTranche: showTranche)
		sourceViewController?.navigationController?.pushViewController(vc, animated: true)
	}

	func showTranchesList(tranches: [AccountData.Loan.Tranche], loanIsOpened: Bool, id_form_root: String?) {
		let vc = TranchesListViewController.controller(tranches: tranches) { [weak self] tranche in
			self?.showTrancheDetails(tranche: tranche, loanIsOpened: loanIsOpened, id_form_root: id_form_root)
		}
		vc.modalPresentationStyle = .overFullScreen
		vc.modalTransitionStyle = .crossDissolve
		sourceViewController?.present(vc, animated: true, completion: nil)
	}

	func showTrancheDetails(tranche: AccountData.Loan.Tranche, loanIsOpened: Bool, id_form_root: String?) {
		let vc = TrancheDetailsViewController.controller(tranche: tranche, loanIsOpened: loanIsOpened, id_form_root: id_form_root)
		sourceViewController?.navigationController?.pushViewController(vc, animated: true)
	}
}
