//
//  SigningRouter.swift
//  Vzaimno
//
//  Created by Sergii Bilyk on 20.07.2021.
//

import Foundation

protocol SigningRouterProtocol: BaseRouterProtocol {
	func showFullScreenImage(imageLink: String)
	func showStepSigning(text: String, id_form: String, step: String)
	func showFinalLoanRequest(is_paymentData_needed: String?)
}

class SigningRouter: BaseRouter, SigningRouterProtocol {

	func showFullScreenImage(imageLink: String) {
		let vc = FullImageViewController.controller(imageLink: imageLink)
		vc.modalPresentationStyle = .overCurrentContext
		vc.modalTransitionStyle = .crossDissolve
		sourceViewController?.present(vc, animated: true, completion: nil)
	}

	func showStepSigning(text: String, id_form: String, step: String) {
		let vc = StepSigningViewController.controller(infoText: text, id_form: id_form, step: step) { [weak self] in
			(self?.sourceViewController as? SigningViewController)?.presenter.getSigningData()
		}
		vc.modalPresentationStyle = .overCurrentContext
		vc.modalTransitionStyle = .crossDissolve
		sourceViewController?.present(vc, animated: true, completion: nil)
	}

	func showFinalLoanRequest(is_paymentData_needed: String?) {
		#warning("Show FinalLoanRequest")
		print("Show FinalLoanRequest")
	}
}
