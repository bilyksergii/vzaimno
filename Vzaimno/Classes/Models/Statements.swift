//
//  Statements.swift
//  Vzaimno
//
//  Created by Sergii Bilyk on 23.09.2021.
//

import Foundation

struct Statements: Codable {
	let statements: [Statement]?
}

struct Statement: Codable {
	let number: String?
	let date: String?
	let client_name: String?
	let cis_user: String?
	let status: String?
	let answer_type: String?
	let answer_date: String?
	let statement: String?
	let answer: String?
	let files: [File]?

	struct File: Codable {
		let id: String?
		let hash: String?
		let name_hash: String?
		let name_user: String?
		let path_file: String?
	}
}
