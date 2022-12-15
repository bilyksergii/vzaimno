//
//  StatementsPresenter.swift
//  Vzaimno
//
//  Created by Sergii Bilyk on 22.09.2021.
//

import Foundation

protocol StatementsPresenterProtocol: AnyObject {
	var userHasTranches: Bool { get }
	func getStatementsList()
}

class StatementsPresenter: StatementsPresenterProtocol {

	weak var view: StatementsViewProtocol?
	private let router: StatementsRouterProtocol
	private let statementsService: StatementsServiceProtocol
	private let cacheService: CacheServiceProtocol

	init(view: StatementsViewProtocol,
		 router: StatementsRouterProtocol,
		 statementsService: StatementsServiceProtocol = StatementsService.shared,
		 cacheService: CacheServiceProtocol = CacheService.shared) {
		self.view = view
		self.router = router
		self.statementsService = statementsService
		self.cacheService = cacheService
	}

	var userHasTranches: Bool {
		return cacheService.getTranches()?.count ?? 0 > 0
	}

	func getStatementsList() {
		view?.showLoader()
		statementsService.getStatementsList { [weak self] statements, error in
			self?.view?.hideLoader()
			if let error = error {
				self?.view?.showToastMessage(error.localizedDescription, type: .error)
				return
			}
			self?.view?.statementsUpdated(statements)
		}
	}
}
