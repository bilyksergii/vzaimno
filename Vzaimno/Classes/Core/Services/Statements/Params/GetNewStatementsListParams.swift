//
//  GetNewStatementsListParams.swift
//  Vzaimno
//
//  Created by Sergii Bilyk on 27.09.2021.
//

import Foundation

struct GetNewStatementsListParams: Encodable {
	let platform: String = "ios"
	let action: String = "statements_get_list"
	let token: String = SecureService.shared.authToken ?? ""
}
