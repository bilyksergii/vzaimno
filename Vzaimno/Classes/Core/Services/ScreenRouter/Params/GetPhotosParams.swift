//
//  GetPhotosParams.swift
//  Vzaimno
//
//  Created by Sergii Bilyk on 26.08.2021.
//

import Foundation

struct GetPhotosParams: Encodable {
	let platform: String = "ios"
	let action: String = "get_photos"
	let token: String = SecureService.shared.authToken ?? ""
}
