//
//  AccountData.swift
//  Vzaimno
//
//  Created by Sergii Bilyk on 17.08.2021.
//

import Foundation

enum OrderClickAction: String, Codable {
	case rejected
	case upload_photos
	case verification
}

protocol AccountCellItem {

}

struct AccountData: Codable {
	let loans: [Loan]?
	let order_data: [OrderData]?
	let banners: [Banner]?

	struct Loan: Codable, AccountCellItem {
		let id_form_root: String
		let title_number: String
		let tranches: [Tranche]
		let summ: Int
		let is_opened: Bool

		struct Tranche: Codable {
			let number: String
			let guid: String
			let summ: String?
		}
	}

	struct OrderData: Codable, AccountCellItem {
		let summ: String
		let status: String
		let click_action: OrderClickAction
		let text_color: String
	}

	struct Banner: Codable {
		let id: String
		let title: String?
		let image_small: String?
		let image_big: String?
		let text: String?
		let created: String
	}
}
