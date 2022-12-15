//
//  StepSign.swift
//  Vzaimno
//
//  Created by Sergii Bilyk on 16.08.2021.
//

import Foundation

enum SignResult: String, Codable {
	case success
	case wait
	case too_late
	case wrong_code
}

struct StepSign: Codable {
	let result: SignResult
	let text: String?
}
