//
//  SendNewStatementParams.swift
//  Vzaimno
//
//  Created by Sergii Bilyk on 30.09.2021.
//

import Foundation

struct SendNewStatementParams: Encodable {
	let platform: String = "ios"
	let action: String = "statements_newMessage"
	let token: String = SecureService.shared.authToken ?? ""
	let msg: String
	let filesBundleHash: String
}
