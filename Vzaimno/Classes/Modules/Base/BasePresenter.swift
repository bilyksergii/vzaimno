//
//  BasePresenter.swift
//  Vzaimno
//
//  Created by Sergii Bilyk on 12.07.2021.
//

import Foundation

protocol BasePresenterProtocol {
	func getFirstScreen(completionHandler: ((FirstScreen?) -> Void)?)
	func getPhotos(completionHandler: ((FirstScreen?) -> Void)?)
	func checkPaymentResult()
}

class BasePresenter: BasePresenterProtocol {

	private weak var view: BaseViewProtocol?
	private let router: BaseRouterProtocol
	private let screenRouterService: ScreenRouterServiceProtocol

	init(view: BaseViewProtocol,
		 router: BaseRouterProtocol,
		 firstScreenService: ScreenRouterServiceProtocol = ScreenRouterService.shared) {
		self.view = view
		self.router = router
		self.screenRouterService = firstScreenService
	}

	func getFirstScreen(completionHandler: ((FirstScreen?) -> Void)? = nil) {
		view?.showLoader()
		screenRouterService.getFirstScreen { [weak self] firstScreenItem, error in
			self?.view?.hideLoader()

			if let error = error {
				self?.view?.showToastMessage(error.localizedDescription, type: .error)
				return
			}

			guard let screenItem = firstScreenItem, let screen = firstScreenItem?.screen else { return }
			
			switch screen {
			case .new_client:
				self?.router.showNewСlientScreen()
			case .rejected:
				self?.router.showRejectedScreen()
			case .thankYou_page:
				if let view = self?.view, view is UploadPhotoViewController {
					completionHandler?(screenItem)
				} else {
					self?.router.showThankYouPageScreen(fromAccount: false, text: screenItem.text, photos: screenItem.photos)
				}
			case .account:
				self?.router.showAccountScreen()
			}
		}
	}

	func getPhotos(completionHandler: ((FirstScreen?) -> Void)? = nil) {
		view?.showLoader()

		screenRouterService.getPhotos { [weak self] firstScreenItem, error in
			self?.view?.hideLoader()

			if let error = error {
				self?.view?.showToastMessage(error.localizedDescription, type: .error)
				return
			}

			if let screenItem = firstScreenItem {
				if let view = self?.view, view is UploadPhotoViewController {
					completionHandler?(screenItem)
				} else {
					self?.router.showThankYouPageScreen(fromAccount: true, text: screenItem.text, photos: screenItem.photos)
				}
			}
		}
	}

	func checkPaymentResult() {
		let paymentResult = UniversalLinkService.shared.checkPaymentResult()
		switch paymentResult {
		case .success, .error:
			router.showPaymentResultScreen(paymentResult)
		default:
			return
		}
		UniversalLinkService.shared.resetPaymentResult()
	}
}
