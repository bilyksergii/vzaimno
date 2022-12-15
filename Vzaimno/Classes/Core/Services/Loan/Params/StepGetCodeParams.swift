//
//  StepGetCodeParams.swift
//  Vzaimno
//
//  Created by Sergii Bilyk on 15.08.2021.
//

import Foundation

struct StepGetCodeParams: Encodable {
	let platform: String = "ios"
	let action: String = "step_getCode"
	let token: String = SecureService.shared.authToken ?? ""
	let id_form: String
	let step: String
}
