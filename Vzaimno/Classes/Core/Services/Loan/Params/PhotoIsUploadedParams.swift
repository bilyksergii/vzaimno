//
//  FotoIsUploadedParams.swift
//  Vzaimno
//
//  Created by Sergii Bilyk on 19.07.2021.
//

import Foundation

struct PhotoIsUploadedParams: Encodable {
	let platform: String = "ios"
	let action: String = "documents_uploaded"
	let token: String = SecureService.shared.authToken ?? ""
}
