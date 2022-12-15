//
//  SendFileStatementResponse.swift
//  Vzaimno
//
//  Created by Sergii Bilyk on 04.10.2021.
//

import Foundation

struct SendFileStatementResponse: Codable {
	let hash: String
	let fname_user: String
	let fname_hash: String
	let description: String?
}
