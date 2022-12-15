//
//  SigningPresenter.swift
//  Vzaimno
//
//  Created by Sergii Bilyk on 20.07.2021.
//

import Foundation

protocol SigningPresenterProtocol: BasePresenterProtocol {
	func getSigningData()
	func sendRightsAssignment(value: Bool)
	func downloadDoc(md5: String)
	func stepGetSignCode(step: String)
}

class SigningPresenter: BasePresenter, SigningPresenterProtocol {

	weak var view: SigningViewProtocol?
	private let router: SigningRouterProtocol
	private let loanService: LoanServiceProtocol
	private let shareService: ShareServiceProtocol

	private var id_form: String?

	init(view: SigningViewProtocol,
		 router: SigningRouterProtocol,
		 loanService: LoanServiceProtocol = LoanService.shared,
		 shareService: ShareServiceProtocol = ShareService.shared) {
		self.view = view
		self.router = router
		self.loanService = loanService
		self.shareService = shareService

		super.init(view: view, router: router)
	}

	func getSigningData() {
		view?.showLoader()
		loanService.signingLoan(params: SigningLoanParams()) { [weak self] signingModel, error in
			self?.view?.hideLoader()
			if let error = error {
				self?.view?.showToastMessage(error.localizedDescription, type: .error)
				return
			}
			self?.id_form = signingModel?.id_form
			if let blocks = signingModel?.blocks {
				self?.view?.signingDataUpdated(blocks: blocks, id_form: self?.id_form ?? "")
			}
		}
	}

	func sendRightsAssignment(value: Bool) {
		view?.showLoader()
		let params = RightsAssignmentParams(state: value ? "1" : "0")
		loanService.rightsAssignmentSwitch(params: params) { [weak self] result in
			self?.view?.hideLoader()
			switch result {
			case .success(_):
				print("Rights Assignment changed successfully")
			case let .failure(error):
				self?.view?.showToastMessage(error.localizedDescription, type: .error)
			}
		}
	}

	func downloadDoc(md5: String) {
		view?.showLoader()
		loanService.downloadDoc(idForm: id_form ?? "", md5: md5, completionHandler: { [weak self] fileUrl, error in
			DispatchQueue.main.async {
				self?.view?.hideLoader()
				if error == nil, let url = fileUrl, let vc = self?.view as? BaseViewController {
					self?.shareService.share(url: url, fromViewController: vc)
				} else {
					self?.view?.showToastMessage(error?.localizedDescription ?? "Ошибка скачивания файла", type: .error)
				}
			}
		})
	}

	func stepGetSignCode(step: String) {
		view?.showLoader()
		let params = StepGetCodeParams(id_form: id_form ?? "", step: step)
		loanService.stepGetCode(params: params) { [weak self] stepSign, error  in
			self?.view?.hideLoader()

			if let error = error {
				self?.view?.showToastMessage(error.localizedDescription, type: .error)
				return
			}

			if let stepSign = stepSign {
				switch stepSign.result {
				case .success, .wait:
					self?.router.showStepSigning(text: stepSign.text ?? "", id_form: self?.id_form ?? "", step: step)
				default:
					return
				}
			}
		}
	}
}
