//
//  AccountNetworkRouter.swift
//  Vzaimno
//
//  Created by Sergii Bilyk on 17.08.2021.
//

import Alamofire

enum AccountNetworkRouter: URLRequestConvertible {
	case getAccountScreenData(params: GetAccountParams)
	case isSignNeeded(params: IsSignNeededParams)
	case getTrancheDetails(params: TrancheDetailsParams)
}

extension AccountNetworkRouter: NetworkRequestParams {
	var parameters: Parameters? {
		switch self {
		case .getAccountScreenData(let params):
			return params.encode()
		case .isSignNeeded(let params):
			return params.encode()
		case .getTrancheDetails(let params):
		return params.encode()
		}
	}
}
