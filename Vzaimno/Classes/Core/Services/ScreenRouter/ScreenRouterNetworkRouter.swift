//
//  ScreenRouterNetworkRouter.swift
//  Vzaimno
//
//  Created by Sergii Bilyk on 12.07.2021.
//

import Alamofire

enum ScreenRouterNetworkRouter: URLRequestConvertible {
	case getFirstScreen(params: FirstScreenParams)
	case getPhotos(params: GetPhotosParams)
}

extension ScreenRouterNetworkRouter: NetworkRequestParams {
	var parameters: Parameters? {
		switch self {
		case .getFirstScreen(let params):
			return params.encode()
		case .getPhotos(let params):
			return params.encode()
		}
	}
}
