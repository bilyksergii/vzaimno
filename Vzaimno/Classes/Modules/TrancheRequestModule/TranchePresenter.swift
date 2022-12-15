//
//  TranchePresenter.swift
//  Vzaimno
//
//  Created by Sergii Bilyk on 30.08.2021.
//

import Foundation

protocol TranchePresenterProtocol: BasePresenterProtocol {
	func isInsuranceAvailable()
	func getMounthPay(summ: String, term: String, lgot: String, id_form_root: String, wantInsurance: String, pay_way: String)
	func getSecretQuestions()
	func trancheRequest(summ: String, term: String, lgot: String, pWay: String, addData: String, is_second: String, insurance: String, email: String?, question_id: String?, secret_answer: String?)
}

class TranchePresenter: BasePresenter, TranchePresenterProtocol {

	weak var view: TrancheViewProtocol?
	private let router: TrancheRouterProtocol
	private let trancheService: TrancheServiceProtocol

	init(view: TrancheViewProtocol,
		 router: TrancheRouterProtocol,
		 trancheService: TrancheServiceProtocol = TrancheService.shared) {
		self.view = view
		self.router = router
		self.trancheService = trancheService

		super.init(view: view, router: router)
	}

	func isInsuranceAvailable() {
		view?.showLoader()
		trancheService.isInsuranceAvailable { [weak self] result in
			self?.view?.hideLoader()
			switch result {
			case .success(let isAvailable):
				self?.view?.isInsuranceAvailableUpdated(isAvailable: isAvailable)
			case let .failure(error):
				self?.view?.showToastMessage(error.localizedDescription, type: .error)
			}
		}
	}

	func getMounthPay(summ: String, term: String, lgot: String, id_form_root: String, wantInsurance: String, pay_way: String) {
		view?.showLoader()
		let params = GetMonthlyPayParams(summ: summ,
										term: term,
										lgot: lgot,
										id_form_root: id_form_root,
										wantInsurance: wantInsurance,
										pay_way: pay_way)
		trancheService.getMounthPay(params: params) { [weak self] result in
			self?.view?.hideLoader()
			switch result {
			case .success(let monthPay):
				self?.view?.monthlyPaymentUpdated(monthPay: monthPay)
			case let .failure(error):
				self?.view?.showToastMessage(error.localizedDescription, type: .error)
			}
		}
	}

	func getSecretQuestions() {
		trancheService.getSecretQuestions { [weak self] result in
			switch result {
			case .success(let secretQuestions):
				self?.view?.secretQuestionsUpdated(questions: secretQuestions)
			case let .failure(error):
				self?.view?.showToastMessage(error.localizedDescription, type: .error)
			}
		}
	}

	func trancheRequest(summ: String, term: String, lgot: String, pWay: String, addData: String, is_second: String, insurance: String, email: String? = nil, question_id: String? = nil, secret_answer: String? = nil) {
		let params = TrancheRequestParams(summ: summ, term: term, lgot: lgot, pWay: pWay, addData: addData, is_second: is_second, insurance: insurance, email: email, question_id: question_id, secret_answer: secret_answer)
		view?.showLoader()
		trancheService.trancheRequest(params: params) { [weak self] (result) in
			self?.view?.hideLoader()
			switch result {
			case .success(_):
				self?.router.showTrancheRequestApproved()
			case let .failure(error):
				self?.view?.showToastMessage(error.localizedDescription, type: .error)
			}
		}
	}
}
