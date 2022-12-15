//
//  Encodable+Extension.swift
//  Vzaimno
//
//  Created by Sergii Bilyk on 24.06.2021.
//

import Alamofire

extension Encodable {

	func encode(dateEncodingStrategy: JSONEncoder.DateEncodingStrategy = .formatted(DateFormatter.serverDateFormatter)) -> Parameters {
		let encoder = JSONEncoder()
		encoder.dateEncodingStrategy = dateEncodingStrategy
		let encodedData = try? encoder.encode(self)
		let parameters = try? JSONSerialization.jsonObject(with: encodedData!, options: [])
		return parameters as! Parameters
	}
}
