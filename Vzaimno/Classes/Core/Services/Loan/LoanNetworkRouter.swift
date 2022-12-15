//
//  LoanNetworkRouter.swift
//  Vzaimno
//
//  Created by Sergii Bilyk on 09.07.2021.
//

import Alamofire

enum LoanNetworkRouter: URLRequestConvertible {
	case newLoan(params: NewLoanParams)
	case uploadFile(params: UploadFileParams)
	case fotoIsUploaded(params: PhotoIsUploadedParams)
	case signingLoan(params: SigningLoanParams)
	case rightsAssignment(params: RightsAssignmentParams)
	case stepGetCode(params: StepGetCodeParams)
	case stepSign(params: StepSignParams )
}

extension LoanNetworkRouter: NetworkRequestParams {
	var parameters: Parameters? {
		switch self {
		case .newLoan(let params):
			return params.encode()
		case .uploadFile(let params):
			return params.encode()
		case .fotoIsUploaded(let params):
			return params.encode()
		case .signingLoan(let params):
			return params.encode()
		case .rightsAssignment(let params):
			return params.encode()
		case .stepGetCode(let params):
			return params.encode()
		case .stepSign(let params):
			return params.encode()
		}
	}
}

