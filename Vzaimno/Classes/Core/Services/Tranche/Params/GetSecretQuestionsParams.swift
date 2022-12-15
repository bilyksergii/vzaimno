//
//  GetSecretQuestionsParams.swift
//  Vzaimno
//
//  Created by Sergii Bilyk on 03.09.2021.
//

import Foundation

struct GetSecretQuestionsParams: Encodable {
	let platform: String = "ios"
	let action: String = "get_secret_questions"
	let token: String = SecureService.shared.authToken ?? ""
}
