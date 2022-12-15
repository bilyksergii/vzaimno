//
//  TrancheService.swift
//  Vzaimno
//
//  Created by Sergii Bilyk on 30.08.2021.
//

import Foundation

protocol TrancheServiceProtocol {
	func isInsuranceAvailable(completionHandler: @escaping (Result<Bool>) -> Void)
	func getMounthPay(params: GetMonthlyPayParams, completionHandler: @escaping (Result<String>) -> Void)
	func getSecretQuestions(completionHandler: @escaping (Result<[SecretQuestion]>) -> Void)
	func trancheRequest(params: TrancheRequestParams, completionHandler: @escaping (Result<Void>) -> Void)
}

final class TrancheService: TrancheServiceProtocol {

	static let shared = TrancheService()

	private let httpClient: HttpClientProtocol

	init(httpClient: HttpClientProtocol = HttpClient()) {
		self.httpClient = httpClient
	}

	// MARK: - TrancheServiceProtocol

	func isInsuranceAvailable(completionHandler: @escaping (Result<Bool>) -> Void) {
		let responseHandler = { (result: Result<IsInsuranceAvailableResponse>) in
			switch result {
			case let .success(response):
				completionHandler(.success(response.is_available))
			case let .failure(error):
				completionHandler(.failure(error))
			}
		}
		let request = TrancheNetworkRouter.isInsuranceAvailable(params: IsInsuranceAvailableParams())
		httpClient.loadMFData(request: request, completionHandler: responseHandler)
	}

	func getMounthPay(params: GetMonthlyPayParams, completionHandler: @escaping (Result<String>) -> Void) {
		let responseHandler = { (result: Result<GetMounthPayResponse>) in
			switch result {
			case let .success(response):
				completionHandler(.success(response.data.mount_pay))
			case let .failure(error):
				completionHandler(.failure(error))
			}
		}
		let request = TrancheNetworkRouter.getMounthPay(params: params)
		httpClient.loadMFData(request: request, completionHandler: responseHandler)
	}

	func getSecretQuestions(completionHandler: @escaping (Result<[SecretQuestion]>) -> Void) {
		let responseHandler = { (result: Result<GetSecretQuestionsResponse>) in
			switch result {
			case let .success(response):
				completionHandler(.success(response.secret_questions))
			case let .failure(error):
				completionHandler(.failure(error))
			}
		}
		let request = TrancheNetworkRouter.getSecretQuestions(params: GetSecretQuestionsParams())
		httpClient.loadMFData(request: request, completionHandler: responseHandler)
	}

	func trancheRequest(params: TrancheRequestParams, completionHandler: @escaping (Result<Void>) -> Void) {
		let responseHandler = {(result: Result<EmptyResponse>) in
			switch result {
			case .success(_):
				completionHandler(.success(()))
			case let .failure(error):
				completionHandler(.failure(error))
			}
		}
		let request = TrancheNetworkRouter.trancheRequest(params: params)
		httpClient.loadMFData(request: request, completionHandler: responseHandler)
	}
}
