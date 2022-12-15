//
//  StepSigningPresenter.swift
//  Vzaimno
//
//  Created by Sergii Bilyk on 15.08.2021.
//

import Foundation

protocol StepSigningPresenterProtocol: AnyObject {
	func stepSign(step: String, id_form: String, smsCode: String)
}

class StepSigningPresenter: StepSigningPresenterProtocol {

	weak var view: StepSigningViewProtocol?
	private let router: StepSigningRouterProtocol
	private let loanService: LoanServiceProtocol

	init(view: StepSigningViewProtocol,
		 router: StepSigningRouterProtocol,
		 loanService: LoanServiceProtocol = LoanService.shared) {
		self.view = view
		self.router = router
		self.loanService = loanService
	}

	func stepSign(step: String, id_form: String, smsCode: String) {
		view?.showLoader()
		let params = StepSignParams(id_form: id_form, step: step, sms_code: smsCode)

		loanService.stepSign(params: params) { [weak self] stepSign, error  in
			self?.view?.hideLoader()

			if let error = error {
				self?.view?.showResultMessage(text: error.localizedDescription, isError: true)
				return
			}

			if let stepSign = stepSign {
				switch stepSign.result {
				case .success, .too_late:
					self?.view?.showResultMessage(text: stepSign.text ?? "", isError: false)
				case .wrong_code:
					self?.view?.showWrongCode(text: stepSign.text ?? "")
				default:
					return
				}
			}
		}
	}
}
