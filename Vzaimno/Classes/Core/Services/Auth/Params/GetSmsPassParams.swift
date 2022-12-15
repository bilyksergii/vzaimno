//
//  GetSmsPassParams.swift
//  Vzaimno
//
//  Created by Sergii Bilyk on 03.07.2021.
//

import Foundation

struct GetSmsPassParams: Encodable {
	let platform: String = "ios"
	let action: String = "get_sms_pass"
	let phone: String

	enum CodingKeys: String, CodingKey {
		case platform = "platform"
		case action = "action"
		case phone = "login"
	}
}
