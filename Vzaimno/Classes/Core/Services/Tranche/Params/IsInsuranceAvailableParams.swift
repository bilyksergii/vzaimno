//
//  IsInsuranceAvailableParams.swift
//  Vzaimno
//
//  Created by Sergii Bilyk on 31.08.2021.
//

import Foundation

struct IsInsuranceAvailableParams: Encodable {
	let platform: String = "ios"
	let action: String = "is_insurance_available"
	let token: String = SecureService.shared.authToken ?? ""
}
