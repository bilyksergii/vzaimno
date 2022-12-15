//
//  HttpClient.swift
//  Vzaimno
//
//  Created by Sergii Bilyk on 24.06.2021.
//

import Alamofire
import AlamofireNetworkActivityIndicator

struct EmptyResponse: Codable {}

protocol HttpClientProtocol {

	func loadMFData<T: Codable>(request: NetworkRequestParams & URLRequestConvertible,
					fileData: Data?,
					fileName: String?,
					mimeType: String?,
					rootKey: String?,
					completionHandler: @escaping (_ result: Result<T>) -> Void)

	func downloadFile(urlString: String,
					  completionHandler: @escaping (URL?, Error?) -> Void)
}

extension HttpClientProtocol {

	func loadMFData<T: Codable>(request: NetworkRequestParams & URLRequestConvertible,
					fileData: Data? = nil,
					fileName: String? = nil,
					mimeType: String? = nil,
					rootKey: String? = nil,
					completionHandler: @escaping (_ result: Result<T>) -> Void) {
		loadMFData(request: request,
				   fileData: fileData,
				   fileName: fileName,
				   mimeType: mimeType,
				   rootKey: rootKey,
				   completionHandler: completionHandler)
	}
}

final class HttpClient: HttpClientProtocol {

	private let sessionManager: Alamofire.Session
	private let mapper: MapperProtocol

	init(mapper: MapperProtocol = Mapper()) {

		let configuration = URLSessionConfiguration.default
		configuration.timeoutIntervalForResource = 600

		NetworkActivityIndicatorManager.shared.isEnabled = true
		NetworkActivityIndicatorManager.shared.startDelay = 0.3

		self.sessionManager = Session(configuration: configuration)
		self.mapper = mapper
	}

	deinit {
		sessionManager.session.getAllTasks { (task) in
			task.forEach { $0.cancel() }
		}
	}

	// MARK: - HttpClientProtocol

	func loadMFData<T: Codable>(request: NetworkRequestParams & URLRequestConvertible,
					fileData: Data? = nil,
					fileName: String? = nil,
					mimeType: String? = nil,
					rootKey: String? = nil,
					completionHandler: @escaping (_ result: Result<T>) -> Void) {
		sendFormDataRequest(request: request,
							fileData: fileData,
							fileName: fileName,
							mimeType: mimeType,
							rootKey: rootKey) { (result) in
			switch result {
			case let .success(data):
				let mapperResult: Result<T> = self.mapper.map(data: data, rootKey: rootKey)
				completionHandler(mapperResult)
			case let .failure(error):
				completionHandler(.failure(error))
			}
		}
	}

	func downloadFile(urlString: String, completionHandler: @escaping (URL?, Error?) -> Void) {
		clearCache()
		let sessionConfig = URLSessionConfiguration.default
		let session = URLSession(configuration: sessionConfig, delegate: nil, delegateQueue: nil)
		let request = NSMutableURLRequest(url: URL(string: urlString)!)
		request.httpMethod = "GET"
		let task = session.downloadTask(with: request as URLRequest) { url, response, error in
			if error == nil, (response as? HTTPURLResponse)?.statusCode == 200 {
				#if DEBUG
				print("✅\(response.debugDescription)")
				#endif
				if let fileUrl = url,
					let fileName = response?.suggestedFilename,
					let fileNameString = String(data: fileName.data(using: .isoLatin1) ?? Data(), encoding: .utf8),
					let cacheDirectory = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).first {
					let casheFileUrl = URL(fileURLWithPath: "\(cacheDirectory)/\(fileNameString)")
					do {
						try FileManager.default.moveItem(at: fileUrl, to: casheFileUrl)
						completionHandler(casheFileUrl, nil)
					} catch {
						completionHandler(nil, error as? Error)
					}
				}
			} else if let error = error {
				completionHandler(nil, error as? Error)
			}
		}
		task.resume()
	}

	// MARK: - Private

	func sendFormDataRequest(request: NetworkRequestParams & URLRequestConvertible,
							 fileData: Data? = nil,
							 fileName: String? = nil,
							 mimeType: String? = nil,
							 rootKey: String? = nil,
							 completionHandler: @escaping (_ result: Result<Data>) -> Void) {
		let urlRequest = try! request.asURLRequest()
		let _ = sessionManager.upload(multipartFormData: { multipartFormData in
			if let parameters = request.parameters {
				for key in parameters.keys {
					let name = String(key)
					if let val = parameters[name] as? String, let valData = val.data(using: .utf8) {
						multipartFormData.append(valData, withName: name)
					} else if let value = parameters[name] {
						print("❌❌❌ ERROR adding multipartFormData param: \(name) value: \(value) type: \(type(of: value)) 😝😝😝")
					}
				}
			}
			if let fileData = fileData, let fileName = fileName, let mimeType = mimeType {
				multipartFormData.append(fileData, withName: "userFile", fileName: fileName, mimeType: mimeType)
			}
		}, with: urlRequest).responseData { [weak self] (response) in
			DispatchQueue.main.async {
				#if DEBUG
				print("✅\(response.debugDescription)")
				#endif
				self?.handle(response: response, rootKey: rootKey, completionHandler: completionHandler)
			}
		}
	}

	private func handle(response: AFDataResponse<Data>, rootKey: String?, completionHandler: @escaping (_ result: Result<Data>) -> Void) {

		if let error = response.error {
			if error.responseCode == NSURLErrorNotConnectedToInternet {
				completionHandler(.failure(Error.noConnection))
				return
			}
			completionHandler(.failure(Error.timeout))
			return
		}

		guard let httpResponse = response.response else {
			completionHandler(.failure(Error.noData))
			return
		}

		switch httpResponse.statusCode {
		case 200...205:
			guard let data = response.data else {
				completionHandler(.failure(Error.noData))
				return
			}
			if let error = self.handleError(data: data) {
				completionHandler(.failure(error))
				return
			}
			completionHandler(.success(data))

		case 400..<500:

			if httpResponse.statusCode == 401 {
				NotificationCenter.default.post(name: .didLogout, object: nil)
				return
			}

			if let responseData = response.data {
				if let error = self.handleError(data: responseData) {
					completionHandler(.failure(error))
					return
				}

				let error = Error.somethingWentWrong
				completionHandler(.failure(error))
				return

			} else {
				completionHandler(.failure(Error.noData))
			}

		case 500..<600:
			let error = Error.somethingWentWrong
			completionHandler(.failure(error))

		default:
			break
		}

	}

	private func handleError(data: Data) -> Error? {
		guard let json_ = try? JSONSerialization.jsonObject(with: data, options: []), let json = json_ as? [String: Any] else { return nil }
		if (json["result"] as? String) == "error" {
			let error = Error.serverError(json: json)
			return error
		}
		return nil
	}

	private func clearCache() {
		let cacheURL =  FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first!
		let fileManager = FileManager.default
		do {
			let directoryContents = try FileManager.default.contentsOfDirectory( at: cacheURL, includingPropertiesForKeys: nil, options: [])
			for file in directoryContents {
				do {
					try fileManager.removeItem(at: file)
				}
				catch let error as NSError {
					debugPrint("❌ Ooops! Something went wrong: \(error.localizedDescription)")
				}

			}
		} catch let error as NSError {
			print("❌ \(error.localizedDescription)")
		}
	}
}
