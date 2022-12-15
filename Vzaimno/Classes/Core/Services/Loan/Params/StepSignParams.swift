//
//  StepSignParams.swift
//  Vzaimno
//
//  Created by Sergii Bilyk on 15.08.2021.
//

import Foundation

struct StepSignParams: Encodable {
	let platform: String = "ios"
	let action: String = "step_sign"
	let token: String = SecureService.shared.authToken ?? ""
	let id_form: String
	let step: String
	let sms_code: String
}
