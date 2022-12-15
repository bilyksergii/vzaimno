//
//  SendFileStatementParams.swift
//  Vzaimno
//
//  Created by Sergii Bilyk on 04.10.2021.
//

import Foundation

struct SendFileStatementParams: Encodable {
	let platform: String = "ios"
	let action: String = "statements_send_files"
	let token: String = SecureService.shared.authToken ?? ""
	let hash: String?
}
