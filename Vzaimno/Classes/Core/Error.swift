//
//  Error.swift
//  Vzaimno
//
//  Created by Sergii Bilyk on 24.06.2021.
//

import Foundation

//enum ResponseError: String {
//	case unknown
//	case userNotFound = "UserNotFoundException"
//	case invalidPassword = "InvalidPasswordException"
//	case alreadyAdded = "AlreadyAddedException"
//	case invalidPinCode = "InvalidPinCodeException"
//
//	var message: String {
//		switch self {
//		case .unknown: return "Unknown error."
//		case .userNotFound: return "User Not Found"
//		case .invalidPassword: return "Invalid Password"
//		case .alreadyAdded: return "Already Added"
//		case .invalidPinCode: return "Oops! Wrong code. Please, try again"
//		}
//	}
//}

enum ErrorCode: String {
	case no_auth = "no_auth"
}

enum Error : Swift.Error, LocalizedError {
	case parsing
	case noConnection
	case timeout
	case noData
	case serverError(json: [String: Any])
	case somethingWentWrong

	var errorDescription: String? {
		switch self {
		case .serverError(let json):
//			guard let error = json["code"] as? String else {
//				return "Unknown error"
//			}
//			let responseError = ResponseError(rawValue: error) ?? .unknown
//			return responseError.message

			if let errorText = json["text"] as? String {
				return errorText
			}

			if let errorText = json["description"] as? String {
				return errorText
			}

			if let errorCode = json["code"] as? String {
				switch errorCode {
				case ErrorCode.no_auth.rawValue:
					NotificationCenter.default.post(name: .didLogout, object: nil)
					return "Нет авторизации"
				default:
					return "Неизвестный код ошибки"
				}
			}

			return "Неизвестная ошибка"

		case .parsing, .noData, .somethingWentWrong:
			return "Неизвестная ошибка"

		case .noConnection:
			return "Нет соединения"

		case .timeout:
			return "Превышено время ожидания запроса"
		}
	}
}
