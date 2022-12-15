//
//  UploadFileParams.swift
//  Vzaimno
//
//  Created by Sergii Bilyk on 18.07.2021.
//

import Foundation

struct UploadFileParams: Encodable {
	let platform: String = "ios"
	let action: String = "upload_photo"
	let token: String = SecureService.shared.authToken ?? ""
	let type: String
	let latitude: String?
	let longtitude: String?
}
