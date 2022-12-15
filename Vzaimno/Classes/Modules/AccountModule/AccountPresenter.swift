//
//  AccountPresenter.swift
//  Vzaimno
//
//  Created by Sergii Bilyk on 16.08.2021.
//

import Foundation

protocol AccountPresenterProtocol: BasePresenterProtocol {
	func getAccountScreenData(checkIsSignNeeded: Bool)
}

class AccountPresenter: BasePresenter, AccountPresenterProtocol {

	weak var view: AccountViewProtocol?

	private let router: AccountRouterProtocol
	private let accountService: AccountServiceProtocol
	private let cacheService: CacheServiceProtocol

	init(view: AccountViewProtocol,
		 router: AccountRouterProtocol,
		 accountService: AccountServiceProtocol = AccountService.shared,
		 cacheService: CacheServiceProtocol = CacheService.shared) {
		self.view = view
		self.router = router
		self.accountService = accountService
		self.cacheService = cacheService

		super.init(view: view, router: router)
	}

	// MARK: - AccountPresenterProtocol

	func getAccountScreenData(checkIsSignNeeded: Bool) {
		view?.showLoader()
		accountService.getAccountScreenData { [weak self] accountData, error in
			self?.view?.hideLoader()
			if let error = error {
				self?.view?.showToastMessage(error.localizedDescription, type: .error)
				return
			}
			if let accountData = accountData {
				self?.cacheTranches(accountData: accountData)
				self?.view?.accountDataUpdated(accountData)
				if checkIsSignNeeded, accountData.order_data?.count ?? 0 > 0 {
					self?.isSignNeeded()
				} else {
					self?.checkPaymentResult()
				}
			}
		}
	}

	// MARK: - Private

	private func isSignNeeded() {
		view?.showLoader()
		accountService.isSignNeeded { [weak self] result in
			self?.view?.hideLoader()
			switch result {
			case .success(let isSignNeededScreen):
				switch isSignNeededScreen {
				case .sign:
					self?.router.showSigningScreen(showTranche: false)
				case .tranche:
					self?.router.showSigningScreen(showTranche: true)
				case .isFalse:
					self?.checkPaymentResult()
					return
				}
			case let .failure(error):
				self?.view?.showToastMessage(error.localizedDescription, type: .error)
			}
		}
	}

	private func cacheTranches(accountData: AccountData) {
		var userTranches = [AccountData.Loan.Tranche]()
		let openedLoans = accountData.loans?.filter { $0.is_opened == true }
		openedLoans?.forEach { userTranches.append(contentsOf: $0.tranches) }
		cacheService.saveTranches(userTranches)
	}
}
