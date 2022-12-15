//
//  IsSignNeededResponse.swift
//  Vzaimno
//
//  Created by Sergii Bilyk on 27.08.2021.
//

import Foundation

enum IsSignNeededScreen: String, Codable {
	case sign
	case tranche
	case isFalse = "false"
}

struct IsSignNeededResponse: Codable {
	let screen: IsSignNeededScreen
	let id_form: String
}
