//
//  TrancheNetworkRouter.swift
//  Vzaimno
//
//  Created by Sergii Bilyk on 31.08.2021.
//

import Alamofire

enum TrancheNetworkRouter: URLRequestConvertible {
	case isInsuranceAvailable(params: IsInsuranceAvailableParams)
	case getMounthPay(params: GetMonthlyPayParams)
	case getSecretQuestions(params: GetSecretQuestionsParams)
	case trancheRequest(params: TrancheRequestParams)
}

extension TrancheNetworkRouter: NetworkRequestParams {
	var parameters: Parameters? {
		switch self {
		case .isInsuranceAvailable(let params):
			return params.encode()
		case .getMounthPay(let params):
			return params.encode()
		case .getSecretQuestions(let params):
			return params.encode()
		case .trancheRequest(let params):
			return params.encode()
		}
	}
}
