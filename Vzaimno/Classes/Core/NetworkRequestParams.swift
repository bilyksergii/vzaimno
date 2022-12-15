//
//  NetworkRequestParams.swift
//  Vzaimno
//
//  Created by Sergii Bilyk on 24.06.2021.
//

import Alamofire

protocol NetworkRequestParams {
	var path: String { get }
	var method: HTTPMethod { get }
	var parameters: Parameters? { get }
	var encoding: ParameterEncoding { get }
	var headers: HTTPHeaders? { get }
}

extension NetworkRequestParams {

	var path: String {
		return ""
	}

	var encoding: ParameterEncoding {
		return JSONEncoding()
	}

	var method: HTTPMethod {
		return .post
	}

	var headers: HTTPHeaders? {
		var headers = HTTPHeaders()

		headers.add(name: "Content-Type", value: "multipart/form-data")
		
//		if let authToken = SecureService.shared.authToken {
//			headers.add(name: "Authorization", value: "Bearer \(authToken)")
//			#if DEBUG
//			print("authToken = \(authToken)")
//			#endif
//		}

		return headers
	}

	var parameters: Parameters? {
		return nil
	}
}

extension URLRequestConvertible where Self: NetworkRequestParams  {

	func asURLRequest() throws -> URLRequest {
		guard let baseUrl = URL(string: Constants.APIConfiguration.baseUrl) else { fatalError("baseURL could not be configured.") }
		let url = baseUrl.appendingPathComponent(self.path)
		var request = try! URLRequest(url: url, method: self.method, headers: self.headers)
		request.cachePolicy = .reloadIgnoringLocalCacheData
		request.timeoutInterval = 30
		return try self.encoding.encode(request, with: self.parameters)
	}
}
