//
//  TrancheDetailsParams.swift
//  Vzaimno
//
//  Created by Sergii Bilyk on 13.09.2021.
//

import Foundation

struct TrancheDetailsParams: Encodable {
	let platform: String = "ios"
	let action: String = "get_loan_data"
	let token: String = SecureService.shared.authToken ?? ""
	let guid: String
}
