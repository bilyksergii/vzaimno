//
//  LoanService.swift
//  Vzaimno
//
//  Created by Sergii Bilyk on 09.07.2021.
//

import Foundation
import UIKit

protocol LoanServiceProtocol {
	func newLoanRequest(params: NewLoanParams, completionHandler: @escaping (Result<Void>) -> Void)
	func uploadPhoto(params: UploadFileParams, imgData: Data?, completionHandler: @escaping (Result<Void>) -> Void)
	func photoIsUploaded(completionHandler: @escaping (Result<String>) -> Void)
	func signingLoan(params: SigningLoanParams, completionHandler: @escaping (SigningModel?, Error?) -> Void)
	func rightsAssignmentSwitch(params: RightsAssignmentParams, completionHandler: @escaping (Result<Void>) -> Void)
	func downloadDoc(idForm: String, md5: String, completionHandler: @escaping (URL?, Error?) -> Void)
	func stepGetCode(params: StepGetCodeParams, completionHandler: @escaping (StepSign?, Error?) -> Void)
	func stepSign(params: StepSignParams, completionHandler: @escaping (StepSign?, Error?) -> Void)
}

final class LoanService: LoanServiceProtocol {

	static let shared = LoanService()

	private let httpClient: HttpClientProtocol

	init(httpClient: HttpClientProtocol = HttpClient()) {
		self.httpClient = httpClient
	}

	// MARK: - LoanServiceProtocol

	func newLoanRequest(params: NewLoanParams, completionHandler: @escaping (Result<Void>) -> Void) {
		let responseHandler = { (result: Result<EmptyResponse>) in
			switch result {
			case .success(_):
				completionHandler(.success(()))
			case let .failure(error):
				completionHandler(.failure(error))
			}
		}
		let request = LoanNetworkRouter.newLoan(params: params)
		httpClient.loadMFData(request: request, completionHandler: responseHandler)
	}

	func uploadPhoto(params: UploadFileParams, imgData: Data?, completionHandler: @escaping (Result<Void>) -> Void) {
		let responseHandler = { (result: Result<EmptyResponse>) in
			switch result {
			case .success(_):
				completionHandler(.success(()))
			case let .failure(error):
				completionHandler(.failure(error))
			}
		}
		let request = LoanNetworkRouter.uploadFile(params: params)
		httpClient.loadMFData(request: request,
							  fileData: imgData,
							  fileName: "photo.jpg",
							  mimeType: "image/jpg",
							  completionHandler: responseHandler)
	}

	func photoIsUploaded(completionHandler: @escaping (Result<String>) -> Void) {
		let responseHandler = { (result: Result<FotoIsUploadedResponse>) in
			switch result {
			case let .success(response):
				completionHandler(.success(response.text))
			case let .failure(error):
				completionHandler(.failure(error))
			}
		}
		let request = LoanNetworkRouter.fotoIsUploaded(params: PhotoIsUploadedParams())
		httpClient.loadMFData(request: request, completionHandler: responseHandler)
	}

	func signingLoan(params: SigningLoanParams, completionHandler: @escaping (SigningModel?, Error?) -> Void) {
		let responseHandler = { (result: Result<SigningModel>) in
			switch result {
			case let .success(signingModel):
				completionHandler(signingModel, nil)
			case let .failure(error):
				completionHandler(nil, error)
			}
		}
		let request = LoanNetworkRouter.signingLoan(params: params)
		httpClient.loadMFData(request: request, completionHandler: responseHandler)
	}

	func rightsAssignmentSwitch(params: RightsAssignmentParams, completionHandler: @escaping (Result<Void>) -> Void) {
		let responseHandler = { (result: Result<EmptyResponse>) in
			switch result {
			case .success(_):
				completionHandler(.success(()))
			case let .failure(error):
				completionHandler(.failure(error))
			}
		}
		let request = LoanNetworkRouter.rightsAssignment(params: params)
		httpClient.loadMFData(request: request, completionHandler: responseHandler)
	}

	func downloadDoc(idForm: String, md5: String, completionHandler: @escaping (URL?, Error?) -> Void) {
		let urlString = Constants.APIConfiguration.baseUrl + "?action=get_file&id_form=\(idForm)&md5=\(md5)"
		httpClient.downloadFile(urlString: urlString, completionHandler: { fileUrl, error in
			completionHandler(fileUrl, error)
		})
	}

	func stepGetCode(params: StepGetCodeParams, completionHandler: @escaping (StepSign?, Error?) -> Void) {
		let responseHandler = { (result: Result<StepSign>) in
			switch result {
			case let .success(stepSign):
				completionHandler(stepSign, nil)
			case let .failure(error):
				completionHandler(nil, error)
			}
		}
		let request = LoanNetworkRouter.stepGetCode(params: params)
		httpClient.loadMFData(request: request, completionHandler: responseHandler)
	}

	func stepSign(params: StepSignParams, completionHandler: @escaping (StepSign?, Error?) -> Void) {
		let responseHandler = { (result: Result<StepSign>) in
			switch result {
			case let .success(stepSign):
				completionHandler(stepSign, nil)
			case let .failure(error):
				completionHandler(nil, error)
			}
		}
		let request = LoanNetworkRouter.stepSign(params: params)
		httpClient.loadMFData(request: request, completionHandler: responseHandler)
	}
}
