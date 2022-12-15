//
//  AuthService.swift
//  Vzaimno
//
//  Created by Sergii Bilyk on 03.07.2021.
//

import Foundation

protocol AuthServiceProtocol {
	func getSmsPass(params: GetSmsPassParams, completionHandler: @escaping (Result<Void>) -> Void)
	func authUser(params: AuthParams, completionHandler: @escaping (Result<Void>) -> Void)
}

final class AuthService: AuthServiceProtocol {

	static let shared = AuthService()

	private let secureService: SecureServiceProtocol
	private let httpClient: HttpClientProtocol

	init(secureService: SecureServiceProtocol = SecureService.shared,
		 httpClient: HttpClientProtocol = HttpClient()) {
		self.secureService = secureService
		self.httpClient = httpClient
	}

	// MARK: - AuthServiceProtocol

	func getSmsPass(params: GetSmsPassParams, completionHandler: @escaping (Result<Void>) -> Void) {
		let responseHandler = { (result: Result<EmptyResponse>) in
			switch result {
			case .success(_):
				completionHandler(.success(()))
			case let .failure(error):
				completionHandler(.failure(error))
			}
		}
		let request = AuthNetworkRouter.getSmsPass(params: params)
		httpClient.loadMFData(request: request, completionHandler: responseHandler)
	}

	func authUser(params: AuthParams, completionHandler: @escaping (Result<Void>) -> Void) {
		let responseHandler = { [weak self] (result: Result<AuthResponse>) in
			switch result {
			case let .success(responseResult):
				self?.secureService.saveToken(responseResult.data.hash)
				self?.secureService.saveUserName(responseResult.data.name ?? "")
				completionHandler(.success(()))
			case let .failure(error):
				completionHandler(.failure(error))
			}
		}
		let request = AuthNetworkRouter.auth(params: params)
		httpClient.loadMFData(request: request, completionHandler: responseHandler)
	}
}
