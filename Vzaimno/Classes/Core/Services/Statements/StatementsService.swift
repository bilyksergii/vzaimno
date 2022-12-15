//
//  StatementsService.swift
//  Vzaimno
//
//  Created by Sergii Bilyk on 22.09.2021.
//

import Foundation

protocol StatementsServiceProtocol {
	func getStatementsList(completionHandler: @escaping ([Statement]?, Error?) -> Void)
	func getNewStatementsList(completionHandler: @escaping ([NewStatement]?, Error?) -> Void)
	func getStatementText(params: [String: String], completionHandler: @escaping (Result<String>) -> Void)
	func sendNewStatement(params: SendNewStatementParams, completionHandler: @escaping (Result<Void>) -> Void)
	func sendFileStatement(params: SendFileStatementParams, fileData: Data, fileName: String, mimeType: String,  completionHandler: @escaping (Result<SendFileStatementResponse>) -> Void)
}

final class StatementsService: StatementsServiceProtocol {

	static let shared = StatementsService()

	private let httpClient: HttpClientProtocol

	init(httpClient: HttpClientProtocol = HttpClient()) {
		self.httpClient = httpClient
	}

	// MARK: - StatementsServiceProtocol

	func getStatementsList(completionHandler: @escaping ([Statement]?, Error?) -> Void) {
		let responseHandler = { (result: Result<Statements>) in
			switch result {
			case let .success(statements):
				completionHandler(statements.statements, nil)
			case let .failure(error):
				completionHandler(nil, error)
			}
		}
		let request = StatementsNetworkRouter.getStatementsList(params: GetStatementsParams())
		httpClient.loadMFData(request: request, completionHandler: responseHandler)
	}

	func getNewStatementsList(completionHandler: @escaping ([NewStatement]?, Error?) -> Void) {
		let responseHandler = { (result: Result<NewStatements>) in
			switch result {
			case let .success(newStatements):
				completionHandler(newStatements.data, nil)
			case let .failure(error):
				completionHandler(nil, error)
			}
		}
		let request = StatementsNetworkRouter.getNewStatementsList(params: GetNewStatementsListParams())
		httpClient.loadMFData(request: request, completionHandler: responseHandler)
	}

	func getStatementText(params: [String: String], completionHandler: @escaping (Result<String>) -> Void) {
		var requestParams = ["platform": "ios",
							 "action": "statements_render",
							 "token": SecureService.shared.authToken ?? ""]
		for (key, value) in params {
			requestParams[key] = value
		}

		let responseHandler = { (result: Result<GetStatementTextResponse>) in
			switch result {
			case let .success(response):
				completionHandler(.success(response.data))
			case let .failure(error):
				completionHandler(.failure(error))
			}
		}
		let request = StatementsNetworkRouter.getStatementText(params: requestParams)
		httpClient.loadMFData(request: request, completionHandler: responseHandler)
	}

	func sendNewStatement(params: SendNewStatementParams, completionHandler: @escaping (Result<Void>) -> Void) {
		let responseHandler = { (result: Result<EmptyResponse>) in
			switch result {
			case .success(_):
				completionHandler(.success(()))
			case let .failure(error):
				completionHandler(.failure(error))
			}
		}
		let request = StatementsNetworkRouter.sendNewStatement(params: params)
		httpClient.loadMFData(request: request, completionHandler: responseHandler)
	}

	func sendFileStatement(params: SendFileStatementParams,
						   fileData: Data,
						   fileName: String,
						   mimeType: String,
						   completionHandler: @escaping (Result<SendFileStatementResponse>) -> Void) {
		let responseHandler = { (result: Result<SendFileStatementResponse>) in
			switch result {
			case let .success(response):
				completionHandler(.success(response))
			case let .failure(error):
				completionHandler(.failure(error))
			}
		}
		let request = StatementsNetworkRouter.sendFileStatement(params: params)
		httpClient.loadMFData(request: request,
							  fileData: fileData,
							  fileName: fileName,
							  mimeType: mimeType,
							  completionHandler: responseHandler)
	}
}
