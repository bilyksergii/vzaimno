//
//  RightsAssignmentParams.swift
//  Vzaimno
//
//  Created by Sergii Bilyk on 06.08.2021.
//

import Foundation

struct RightsAssignmentParams: Encodable {
	let platform: String = "ios"
	let action: String = "rightsAssigment"
	let token: String = SecureService.shared.authToken ?? ""
	let ra_action: String = "set"
	let state: String
}
