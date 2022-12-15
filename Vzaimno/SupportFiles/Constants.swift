//
//  Constants.swift
//  Vzaimno
//
//  Created by Sergii Bilyk on 24.06.2021.
//

import Foundation

enum Constants {

	enum APIConfiguration {
		static let host = "http://std.mfovzaimno.ru:81"
		static let rootParh = "/server/m/index.php"

		static var baseUrl: String {
			return host + rootParh
		}
	}

	static let agreementUrlString = "https://www.mfovzaimno.ru/agreement"
	static let insuranceInfoUrlString = "https://www.mfovzaimno.ru/insurance-info"
	static let paymentUrlString = "https://www.mfovzaimno.ru/online"
}
