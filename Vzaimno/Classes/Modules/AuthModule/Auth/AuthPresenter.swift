//
//  AuthPresenter.swift
//  Vzaimno
//
//  Created by Sergii Bilyk on 26.06.2021.
//

import Foundation

protocol AuthPresenterProtocol: AnyObject {
	func getSmsPass(phone: String)
}

class AuthPresenter: AuthPresenterProtocol {

	weak var view: AuthViewProtocol?
	private let router: AuthRouterProtocol
	private let authService: AuthServiceProtocol

	init(view: AuthViewProtocol,
		 authService: AuthServiceProtocol = AuthService.shared,
		 router: AuthRouterProtocol) {
		self.view = view
		self.authService = authService
		self.router = router
	}

	func getSmsPass(phone: String) {
		view?.showLoader()
		authService.getSmsPass(params: GetSmsPassParams(phone: phone)) { [weak self] (result) in
			self?.view?.hideLoader()
			switch result {
			case .success(_):
				self?.router.showPhoneConfirmation(phone: phone)
			case let .failure(error):
				self?.view?.showToastMessage(error.localizedDescription, type: .error)
			}
		}
	}
}


