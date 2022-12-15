//
//  AuthResponse.swift
//  Vzaimno
//
//  Created by Sergii Bilyk on 03.07.2021.
//

import Foundation

struct AuthResponse: Codable {
	struct Token: Codable {
		let hash: String
		let name: String?
	}

	let data: Token
}
