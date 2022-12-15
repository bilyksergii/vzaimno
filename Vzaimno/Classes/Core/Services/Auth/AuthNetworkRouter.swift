//
//  AuthNetworkRouter.swift
//  Vzaimno
//
//  Created by Sergii Bilyk on 03.07.2021.
//

import Alamofire

enum AuthNetworkRouter: URLRequestConvertible {
	case getSmsPass(params: GetSmsPassParams)
	case auth(params: AuthParams)
}

extension AuthNetworkRouter: NetworkRequestParams {

	var parameters: Parameters? {
		switch self {
		case .getSmsPass(let params):
			return params.encode()
		case .auth(let params):
			return params.encode()
		}
	}
}
