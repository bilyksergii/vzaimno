//
//  StatementsNetworkRouter.swift
//  Vzaimno
//
//  Created by Sergii Bilyk on 22.09.2021.
//

import Alamofire

enum StatementsNetworkRouter: URLRequestConvertible {
	case getStatementsList(params: GetStatementsParams)
	case getNewStatementsList(params: GetNewStatementsListParams)
	case getStatementText(params: [String: String])
	case sendNewStatement(params: SendNewStatementParams)
	case sendFileStatement(params: SendFileStatementParams)
}

extension StatementsNetworkRouter: NetworkRequestParams {
	var parameters: Parameters? {
		switch self {
		case .getStatementsList(let params):
			return params.encode()
		case .getNewStatementsList(let params):
			return params.encode()
		case .getStatementText(let params):
			return params.encode()
		case .sendNewStatement(let params):
			return params.encode()
		case .sendFileStatement(let params):
			return params.encode()
		}
	}
}

