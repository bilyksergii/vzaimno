//
//  GetSecretQuestionsResponse.swift
//  Vzaimno
//
//  Created by Sergii Bilyk on 03.09.2021.
//

import Foundation

struct SecretQuestion: Codable {
	let id: String
	let text: String
}

struct GetSecretQuestionsResponse: Codable {
	let secret_questions: [SecretQuestion]
}
