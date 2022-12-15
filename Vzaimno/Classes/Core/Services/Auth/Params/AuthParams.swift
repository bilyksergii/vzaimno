//
//  AuthParams.swift
//  Vzaimno
//
//  Created by Sergii Bilyk on 03.07.2021.
//

import Foundation

struct AuthParams: Encodable {
	let platform: String = "ios"
	let action: String = "auth"
	let phone: String
	let password: String

	enum CodingKeys: String, CodingKey {
		case platform = "platform"
		case action = "action"
		case phone = "login"
		case password = "password"
	}
}
