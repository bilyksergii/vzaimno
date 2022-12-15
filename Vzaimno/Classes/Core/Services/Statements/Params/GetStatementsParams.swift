//
//  GetStatementsParams.swift
//  Vzaimno
//
//  Created by Sergii Bilyk on 23.09.2021.
//

import Foundation

struct GetStatementsParams: Encodable {
	let platform: String = "ios"
	let action: String = "statements_getStatements"
	let token: String = SecureService.shared.authToken ?? ""
}
