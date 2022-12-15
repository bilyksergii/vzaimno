//
//  FirstScreenParams.swift
//  Vzaimno
//
//  Created by Sergii Bilyk on 12.07.2021.
//

import Foundation

struct FirstScreenParams: Encodable {
	let platform: String = "ios"
	let action: String = "getFirstScreen"
	let token: String = SecureService.shared.authToken ?? ""
}
