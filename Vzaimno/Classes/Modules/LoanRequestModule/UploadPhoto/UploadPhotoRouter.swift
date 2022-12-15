//
//  UploadPhotoRouter.swift
//  Vzaimno
//
//  Created by Sergii Bilyk on 13.07.2021.
//

import Foundation

protocol UploadPhotoRouterProtocol: BaseRouterProtocol {

	func showCameraView(photo: Photo, type: String)
	func showPhotoUploadedScreen(infoText: String)
}

class UploadPhotoRouter: BaseRouter, UploadPhotoRouterProtocol {

	func showCameraView(photo: Photo, type: String) {
		let vc = CameraViewController.controller(photo: photo, completionHandler: { [weak self] photoImage in
			(self?.sourceViewController as? UploadPhotoViewController)?.presenter.uploadPhoto(photoImage: photoImage, type: type)
		})
		sourceViewController?.navigationController?.pushViewController(vc, animated: true)
	}

	func showPhotoUploadedScreen(infoText: String) {
		let vc = PhotoUploadedViewController.controller(infoText: infoText)
		vc.modalPresentationStyle = .overCurrentContext
		vc.modalTransitionStyle = .crossDissolve
		sourceViewController?.present(vc, animated: true, completion: nil)
	}
}
