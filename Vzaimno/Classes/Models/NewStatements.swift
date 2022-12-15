//
//  NewStatements.swift
//  Vzaimno
//
//  Created by Sergii Bilyk on 27.09.2021.
//

import Foundation

enum StatementInputType: String, Codable {
	case text
	case date
	case textarea
}

struct NewStatements: Codable {
	let data: [NewStatement]?
}

struct NewStatement: Codable {
	let id: String
	let title: String
	let textInputs: [TextInput]?

	enum CodingKeys: String, CodingKey {
		case id = "id"
		case title = "title"
		case textInputs = "inputs"
	}

	struct TextInput: Codable {
		let type: StatementInputType
		let title: String
		let placeholder: String?
		let required: String
		let input_name: String
	}
}
