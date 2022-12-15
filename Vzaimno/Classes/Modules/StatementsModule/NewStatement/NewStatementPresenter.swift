//
//  NewStatementPresenter.swift
//  Vzaimno
//
//  Created by Sergii Bilyk on 27.09.2021.
//

import Foundation

protocol NewStatementPresenterProtocol: AnyObject {
	var userTranches: [AccountData.Loan.Tranche]? { get }
	func getNewStatementsList()
	func getStatementText(params: [String: String])
	func prepareFile(url: URL, filesHash: String?)
}

class NewStatementPresenter: NewStatementPresenterProtocol {

	weak var view: NewStatementViewProtocol?
	private let router: NewStatementRouterProtocol
	private let statementsService: StatementsServiceProtocol
	private let cacheService: CacheServiceProtocol

	init(view: NewStatementViewProtocol,
		 router: NewStatementRouterProtocol,
		 statementsService: StatementsServiceProtocol = StatementsService.shared,
		 cacheService: CacheServiceProtocol = CacheService.shared) {
		self.view = view
		self.router = router
		self.statementsService = statementsService
		self.cacheService = cacheService
	}

	// MARK: - NewStatementPresenterProtocol

	var userTranches: [AccountData.Loan.Tranche]? {
		return cacheService.getTranches()
	}

	func getNewStatementsList() {
		statementsService.getNewStatementsList { [weak self] newStatements, error in
			if let error = error {
				self?.view?.showToastMessage(error.localizedDescription, type: .error)
				return
			}
			if let newStatements = newStatements {
				self?.view?.newStatementsUpdated(newStatements)
			}
		}
	}

	func getStatementText(params: [String: String]) {
		statementsService.getStatementText(params: params) { [weak self] result in
			switch result {
			case .success(let data):
				self?.view?.statementTextUpdated(data)
			case let .failure(error):
				self?.view?.showToastMessage(error.localizedDescription, type: .error)
			}
		}
	}

	func sendNewStatement(msg: String, filesBundleHash: String) {
		view?.showLoader()
		let params = SendNewStatementParams(msg: msg, filesBundleHash: filesBundleHash)
		statementsService.sendNewStatement(params: params) { [weak self] result in
			self?.view?.hideLoader()
			switch result {
			case .success():
				self?.view?.closeScreen()
			case let .failure(error):
				self?.view?.showToastMessage(error.localizedDescription, type: .error)
			}
		}
	}

	func prepareFile(url: URL, filesHash: String?) {
		guard let fileData = NSData(contentsOf: url) else {
			print("❌ Error loading file")
			return
		}

		guard fileData.count <= 10485760 else {
			view?.showToastMessage("Файл не должен быть больше 10МБ",
								   type: .info,
								   position: .bottom,
								   duration: 3.0)
			return
		}

		let fileName = url.lastPathComponent
		let fileExtension = (fileName as NSString).pathExtension
		let mimeType = FileUTIWrapper.mimeTypeFrom(fileName: fileName)
		switch fileExtension {
		case "doc", "docx", "png", "jpg", "jpeg", "txt", "pdf":
			sendFile(fileData: Data(referencing: fileData),
					 fileName: fileName,
					 mimeType: mimeType,
					 filesHash: filesHash)
		default:
			view?.showToastMessage("Файл имеет формат \(fileExtension). Допустимый формат: 'doc', 'docx', 'png', 'jpg', 'txt', 'pdf'",
								   type: .info,
								   position: .bottom,
								   duration: 3.0)
		}
		print("✅ New Statement File Name: \(fileName) Extension: \(fileExtension) MimeType: \(mimeType)")
	}

	private func sendFile(fileData: Data,
						  fileName: String,
						  mimeType: String,
						  filesHash: String? = nil) {
		view?.showLoader()
		let params = SendFileStatementParams(hash: filesHash)
		statementsService.sendFileStatement(params: params,
											fileData: fileData,
											fileName: fileName,
											mimeType: mimeType) { [weak self] result in
			self?.view?.hideLoader()
			switch result {
			case .success(let response):
				self?.view?.updateFilesList(file: StatementFileViewModel(fname_user: response.fname_user,
																		 fname_hash: response.fname_hash),
											filesHash: response.hash)
			case let .failure(error):
				self?.view?.showToastMessage(error.localizedDescription, type: .error)
			}
		}
	}
}
