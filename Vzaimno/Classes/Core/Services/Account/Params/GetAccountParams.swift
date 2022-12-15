//
//  GetAccountParams.swift
//  Vzaimno
//
//  Created by Sergii Bilyk on 17.08.2021.
//

import Foundation

struct GetAccountParams: Encodable {
	let platform: String = "ios"
	let action: String = "get_account_screen_data"
	let token: String = SecureService.shared.authToken ?? ""
}
