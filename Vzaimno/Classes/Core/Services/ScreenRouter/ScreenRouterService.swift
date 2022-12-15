//
//  ScreenRouterService.swift
//  Vzaimno
//
//  Created by Sergii Bilyk on 12.07.2021.
//

import Foundation

protocol ScreenRouterServiceProtocol {
	func getFirstScreen(completionHandler: @escaping (FirstScreen?, Error?) -> Void)
	func getPhotos(completionHandler: @escaping (FirstScreen?, Error?) -> Void)
}

final class ScreenRouterService: ScreenRouterServiceProtocol {

	static let shared = ScreenRouterService()

	private let httpClient: HttpClientProtocol

	init(httpClient: HttpClientProtocol = HttpClient()) {
		self.httpClient = httpClient
	}

	// MARK: - ScreenRouterServiceProtocol

	func getFirstScreen(completionHandler: @escaping (FirstScreen?, Error?) -> Void) {
		let responseHandler = { (result: Result<FirstScreen>) in
			switch result {
			case let .success(firstScreen):
				completionHandler(firstScreen, nil)
			case let .failure(error):
				completionHandler(nil, error)
			}
		}
		let request = ScreenRouterNetworkRouter.getFirstScreen(params: FirstScreenParams())
		httpClient.loadMFData(request: request, completionHandler: responseHandler)
	}

	func getPhotos(completionHandler: @escaping (FirstScreen?, Error?) -> Void) {
		let responseHandler = { (result: Result<FirstScreen>) in
			switch result {
			case let .success(firstScreen):
				completionHandler(firstScreen, nil)
			case let .failure(error):
				completionHandler(nil, error)
			}
		}
		let request = ScreenRouterNetworkRouter.getPhotos(params: GetPhotosParams())
		httpClient.loadMFData(request: request, completionHandler: responseHandler)
	}
}
