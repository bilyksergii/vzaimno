//
//  NewLoanParams.swift
//  Vzaimno
//
//  Created by Sergii Bilyk on 12.07.2021.
//

import Foundation

struct NewLoanParams: Encodable {
	let platform: String = "ios"
	let action: String = "new_inbox"
	let token: String = SecureService.shared.authToken ?? ""
	let summ: String
	let term: String
}
