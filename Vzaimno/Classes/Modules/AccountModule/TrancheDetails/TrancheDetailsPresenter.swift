//
//  TrancheDetailsPresenter.swift
//  Vzaimno
//
//  Created by Sergii Bilyk on 11.09.2021.
//

import Foundation

protocol TrancheDetailsPresenterProtocol: AnyObject {

}

class TrancheDetailsPresenter: TrancheDetailsPresenterProtocol {

	weak var view: TrancheDetailsViewProtocol?
	private let router: TrancheDetailsRouterProtocol
	private let accountService: AccountServiceProtocol

	init(view: TrancheDetailsViewProtocol,
		 router: TrancheDetailsRouterProtocol,
		 accountService: AccountServiceProtocol = AccountService.shared) {
		self.view = view
		self.router = router
		self.accountService = accountService
	}

	func getTrancheDetails(guid: String) {
		view?.showLoader()
		accountService.getTrancheDetails(params: TrancheDetailsParams(guid: guid)) { [weak self] trancheDetails, error in
			self?.view?.hideLoader()

			if let error = error {
				self?.view?.showToastMessage(error.localizedDescription, type: .error)
				return
			}

			if let trancheDetails = trancheDetails {
				self?.view?.trancheDetailsUpdated(trancheDetails)
			}
		}
	}
}
