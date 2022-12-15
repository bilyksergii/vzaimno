//
//  TrancheDetails.swift
//  Vzaimno
//
//  Created by Sergii Bilyk on 13.09.2021.
//

import Foundation

struct TrancheDetails: Codable {
	let loan: Loan
	let owe: Owe

	struct Loan: Codable {
		let date: String
		let sum: String
		let history: [History]?
		let graphic: [Graphic]?

		struct History: Codable {
			let date: String?
			let telo: String?
			let proc: String?
			let peni: String?
			let summ: String?
			let created: String?
		}

		struct Graphic: Codable {
			let contract_guid: String?
			let contract_number: String?
			let date: String?
			let summ: String?
			let telo: String?
			let chdo_telo: String?
			let proc: String?
			let telo_ost_start: String?
			let telo_ost_fin: String?
			let created: String?
			let status: String?
			let pay: String?
			let balance: String?
		}
	}

	struct Owe: Codable {
		let full: OweCommon?
		let next: OweCommon?
		let owe: OweCommon?

		struct OweCommon: Codable {
			let date: String?
			let telo: String?
			let proc: String?
			let peni: String?
			let summ: String?
			let count: String?
		}
	}
}
