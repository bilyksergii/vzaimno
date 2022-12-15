//
//  Mapper.swift
//  Vzaimno
//
//  Created by Sergii Bilyk on 24.06.2021.
//

import Foundation

protocol MapperProtocol {
	func map<T: Codable>(json: [String: Any], dateDecodingStrategy: JSONDecoder.DateDecodingStrategy, rootKey: String?) -> Result<T>

	func map<T: Codable>(data: Data, dateDecodingStrategy: JSONDecoder.DateDecodingStrategy, rootKey: String?) -> Result<T>
}

extension MapperProtocol {
	func map<T: Codable>(json: [String: Any]) -> Result<T> {
		return map(json: json, dateDecodingStrategy: .formatted(DateFormatter.serverDateFormatter), rootKey: nil)
	}

	func map<T: Codable>(data: Data, rootKey: String?) -> Result<T> {
		return map(data: data, dateDecodingStrategy: .formatted(DateFormatter.serverDateFormatter), rootKey: rootKey)
	}
}


final class Mapper : MapperProtocol {

	func map<T>(data: Data, dateDecodingStrategy: JSONDecoder.DateDecodingStrategy, rootKey: String?) -> Result<T> where T : Codable {
		let decoder = JSONDecoder()
		do {
			if let key = rootKey {
				let result = try decoder.decode(T.self, from: data, keyPath: key)
				return .success(result)
			} else {
				let result = try decoder.decode(T.self, from: data)
				return .success(result)
			}

		} catch DecodingError.dataCorrupted(let context) {
			print(DecodingError.dataCorrupted(context))
			return .failure(Error.parsing)
		} catch DecodingError.keyNotFound(let key, let context) {
			print(DecodingError.keyNotFound(key, context))
			return .failure(Error.parsing)
		} catch DecodingError.typeMismatch(let type, let context) {
			print(DecodingError.typeMismatch(type, context))
			return .failure(Error.parsing)
		} catch DecodingError.valueNotFound(let value, let context) {
			print(DecodingError.valueNotFound(value, context))
			return .failure(Error.parsing)
		} catch let error {
			print(error)
			return .failure(Error.parsing)
		}
	}

	func map<T: Codable>(json: [String: Any], dateDecodingStrategy: JSONDecoder.DateDecodingStrategy = .deferredToDate, rootKey: String?) -> Result<T> {
		if let key = rootKey, json[key] is NSNull {
			return .failure(Error.parsing)
		}
		var _json = (rootKey != nil) ? json[rootKey!] as Any? : json
		guard _json != nil else {
			return .failure(Error.parsing)
		}
		if let jsonString = _json as? String {
			_json = Mapper.convertStringToDictionary(json: jsonString) ?? [:]
		}
		guard let jsonObject = _json else {
			return .failure(Error.parsing)
		}
		let data = try? JSONSerialization.data(withJSONObject: jsonObject, options: [])
		guard let parsedData = data else { return .failure(Error.parsing) }
		return map(data: parsedData, dateDecodingStrategy: dateDecodingStrategy, rootKey: nil)
	}

	static func convertStringToDictionary(json: String) -> [String: AnyObject]? {
		if let data = json.data(using: .utf8) {
			do {
				let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: AnyObject]
				return json
			} catch let error {
				print("❌❌❌ \(error)")
			}
		}
		return nil
	}
}
