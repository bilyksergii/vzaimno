//
//  IsSignNeededParams.swift
//  Vzaimno
//
//  Created by Sergii Bilyk on 27.08.2021.
//

import Foundation

struct IsSignNeededParams: Encodable {
	let platform: String = "ios"
	let action: String = "is_sign_needed"
	let token: String = SecureService.shared.authToken ?? ""
}
