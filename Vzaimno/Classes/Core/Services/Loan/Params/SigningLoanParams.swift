//
//  SigningLoanParams.swift
//  Vzaimno
//
//  Created by Sergii Bilyk on 20.07.2021.
//

import Foundation

struct SigningLoanParams: Encodable {
	let platform: String = "ios"
	let action: String = "get_verification_data"
	let token: String = SecureService.shared.authToken ?? ""
}
