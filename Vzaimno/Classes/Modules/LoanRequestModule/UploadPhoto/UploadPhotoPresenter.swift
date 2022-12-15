//
//  UploadPhotoPresenter.swift
//  Vzaimno
//
//  Created by Sergii Bilyk on 13.07.2021.
//

import Foundation
import UIKit

protocol UploadPhotoPresenterProtocol: BasePresenterProtocol {
	func updateCurrentScreen()
	func updatePhotos()
	func uploadPhoto(photoImage: UIImage, type: String)
	func makeFotoIsUploadedRequest()
}

class UploadPhotoPresenter: BasePresenter, UploadPhotoPresenterProtocol {

	weak var view: UploadPhotoViewProtocol?
	private let router: UploadPhotoRouterProtocol
	private let loanService: LoanServiceProtocol

	init(view: UploadPhotoViewProtocol,
		 router: UploadPhotoRouterProtocol,
		 loanService: LoanServiceProtocol = LoanService.shared) {
		self.view = view
		self.router = router
		self.loanService = loanService

		super.init(view: view, router: router)
	}

	func updateCurrentScreen() {
		getFirstScreen { [weak self] firstScreenItem in
			guard let item = firstScreenItem, let photos = item.photos else { return }
			self?.view?.updatePhotos(text: item.text, photos: photos)
		}
	}

	func updatePhotos() {
		getPhotos { [weak self] firstScreenItem in
			guard let item = firstScreenItem, let photos = item.photos else { return }
			self?.view?.updatePhotos(text: item.text, photos: photos)
		}
	}

	func uploadPhoto(photoImage: UIImage, type: String) {
		view?.showLoader()
		let location = LocationService.shared.userLocation
		let params = UploadFileParams(type: type, latitude: location?.latitude, longtitude: location?.longitude)
		loanService.uploadPhoto(params: params, imgData: photoImage.jpegData(compressionQuality: 0.5)) { [weak self] result in
			self?.view?.hideLoader()
			switch result {
			case .success(_):
				self?.updateCurrentScreen()
			case let .failure(error):
				self?.view?.showToastMessage(error.localizedDescription, type: .error)
			}
		}
	}

	func makeFotoIsUploadedRequest() {
		view?.showLoader()
		loanService.photoIsUploaded() { [weak self] result in
			self?.view?.hideLoader()
			switch result {
			case .success(let text):
				self?.router.showPhotoUploadedScreen(infoText: text)
			case let .failure(error):
				self?.view?.showToastMessage(error.localizedDescription, type: .error)
			}
		}
	}
}
