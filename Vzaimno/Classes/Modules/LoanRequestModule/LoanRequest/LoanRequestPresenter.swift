//
//  LoanRequestPresenter.swift
//  Vzaimno
//
//  Created by Sergii Bilyk on 08.07.2021.
//

import Foundation

protocol LoanRequestPresenterProtocol: BasePresenterProtocol {
	func newLoanRequest(summ: String, term: String)
}

class LoanRequestPresenter: BasePresenter, LoanRequestPresenterProtocol {

	weak var view: LoanRequestViewProtocol?
	private let router: LoanRequestRouterProtocol
	private let loanService: LoanServiceProtocol

	init(view: LoanRequestViewProtocol,
		 router: LoanRequestRouterProtocol,
		 loanService: LoanServiceProtocol = LoanService.shared) {
		self.view = view
		self.router = router
		self.loanService = loanService

		super.init(view: view, router: router)
	}

	func newLoanRequest(summ: String, term: String) {
		view?.showLoader()
		loanService.newLoanRequest(params: NewLoanParams(summ: summ, term: term)) { [weak self] result in
			self?.view?.hideLoader()
			switch result {
			case .success(_):
				self?.router.showNextScreen()
			case let .failure(error):
				self?.view?.showToastMessage(error.localizedDescription, type: .error)
			}
		}
	}
}
