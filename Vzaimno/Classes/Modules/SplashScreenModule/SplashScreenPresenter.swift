//
//  SplashScreenPresenter.swift
//  Vzaimno
//
//  Created by Sergii Bilyk on 26.06.2021.
//

import UIKit

protocol SplashScreenPresenterProtocol: BasePresenterProtocol {
	func checkToken()
}

class SplashPresenter: BasePresenter, SplashScreenPresenterProtocol {

	private weak var view: SplashScreenProtocol?
	private let router: SplashScreenRouterProtocol
	private let secureService: SecureServiceProtocol

	init(view: SplashScreenProtocol,
		 router: SplashScreenRouterProtocol,
		 secureService: SecureServiceProtocol = SecureService.shared) {

		self.view = view
		self.router = router
		self.secureService = secureService

		super.init(view: view, router: router)
	}

	// MARK: - SplashScreenPresenterProtocol

	func checkToken() {
		self.view?.showLoader()
		if secureService.isAuth() {
			getFirstScreen()
		} else {
			router.showAuth()
		}
		view?.hideLoader()
	}
}
