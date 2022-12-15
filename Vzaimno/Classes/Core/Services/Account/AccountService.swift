//
//  AccountService.swift
//  Vzaimno
//
//  Created by Sergii Bilyk on 17.08.2021.
//

import Foundation

protocol AccountServiceProtocol {
	func getAccountScreenData(completionHandler: @escaping (AccountData?, Error?) -> Void)
	func isSignNeeded(completionHandler: @escaping (Result<IsSignNeededScreen>) -> Void)
	func getTrancheDetails(params: TrancheDetailsParams, completionHandler: @escaping (TrancheDetails?, Error?) -> Void)
}

final class AccountService: AccountServiceProtocol {

	static let shared = AccountService()

	private let httpClient: HttpClientProtocol

	init(httpClient: HttpClientProtocol = HttpClient()) {
		self.httpClient = httpClient
	}

	// MARK: - AccountServiceProtocol

	func getAccountScreenData(completionHandler: @escaping (AccountData?, Error?) -> Void) {
		let responseHandler = { (result: Result<AccountData>) in
			switch result {
			case let .success(accountData):
				completionHandler(accountData, nil)
			case let .failure(error):
				completionHandler(nil, error)
			}
		}
		let request = AccountNetworkRouter.getAccountScreenData(params: GetAccountParams())
		httpClient.loadMFData(request: request, completionHandler: responseHandler)
	}

	func isSignNeeded(completionHandler: @escaping (Result<IsSignNeededScreen>) -> Void) {
		let responseHandler = { (result: Result<IsSignNeededResponse>) in
			switch result {
			case let .success(response):
				completionHandler(.success(response.screen))
			case let .failure(error):
				completionHandler(.failure(error))
			}
		}
		let request = AccountNetworkRouter.isSignNeeded(params: IsSignNeededParams())
		httpClient.loadMFData(request: request, completionHandler: responseHandler)
	}

	func getTrancheDetails(params: TrancheDetailsParams, completionHandler: @escaping (TrancheDetails?, Error?) -> Void) {
		let responseHandler = { (result: Result<TrancheDetails>) in
			switch result {
			case let .success(trancheDetails):
				completionHandler(trancheDetails, nil)
			case let .failure(error):
				completionHandler(nil, error)
			}
		}
		let request = AccountNetworkRouter.getTrancheDetails(params: params)
		httpClient.loadMFData(request: request, completionHandler: responseHandler)
	}
}
