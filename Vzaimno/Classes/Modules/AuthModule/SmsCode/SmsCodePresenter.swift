//
//  SmsCodePresenter.swift
//  Vzaimno
//
//  Created by Sergii Bilyk on 30.06.2021.
//

import Foundation

protocol SmsCodePresenterProtocol: BasePresenterProtocol {
	func loginWith(phone: String, code: String)
	func getSmsPass(phone: String)
}

class SmsCodePresenter: BasePresenter, SmsCodePresenterProtocol {

	weak var view: SmsCodeViewProtocol?
	private let router: SmsCodeRouterProtocol
	private let authService: AuthServiceProtocol

	init(view: SmsCodeViewProtocol,
		 authService: AuthServiceProtocol = AuthService.shared,
		 router: SmsCodeRouterProtocol) {
		self.view = view
		self.authService = authService
		self.router = router

		super.init(view: view, router: router)
	}

	func loginWith(phone: String, code: String) {
		view?.showLoader()
		authService.authUser(params: AuthParams(phone: phone, password: code)) { [weak self] (result) in
			self?.view?.hideLoader()
			switch result {
			case .success(_):
				self?.getFirstScreen()
				self?.view?.wrongCodeMessageIsHidden(true)
			case .failure(_):
				self?.view?.wrongCodeMessageIsHidden(false)
			}
		}
	}

	func getSmsPass(phone: String) {
		view?.showLoader()
		authService.getSmsPass(params: GetSmsPassParams(phone: phone)) { [weak self] (result) in
			self?.view?.hideLoader()
			switch result {
			case .success(_):
				print("GetSmsPass: Success")
			case let .failure(error):
				self?.view?.showToastMessage(error.localizedDescription, type: .error)
			}
		}
	}
}
