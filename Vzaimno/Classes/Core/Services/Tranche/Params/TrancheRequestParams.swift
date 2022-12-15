//
//  TrancheRequestParams.swift
//  Vzaimno
//
//  Created by Sergii Bilyk on 06.09.2021.
//

import Foundation

struct TrancheRequestParams: Encodable {
	let platform: String = "ios"
	let action: String = "tranche_request"
	let token: String = SecureService.shared.authToken ?? ""
	let summ: String
	let term: String
	let lgot: String
	let pWay: String
	let addData: String
	let is_second: String
	let insurance: String
	let email: String?
	let question_id: String?
	let secret_answer: String?
}
