//
//  SigningModel.swift
//  Vzaimno
//
//  Created by Sergii Bilyk on 21.07.2021.
//

import Foundation

enum BlockType: String, Codable {
	case text
	case step
	case button
}

enum BlockState: String, Codable {
	case online
	case offline
	case active
}

enum ButtonAction: String, Codable {
	case tranche = "screen.tranche_request"
	case noTranche = "screen.no_tranche_Request"
}

struct SigningModel: Codable {
	let id_form: String
	let blocks: [Block]?

	struct Block: Codable {

		struct State: Codable {

			struct ESign: Codable {
				let id: String
				let step: String
				let id_form: String
				let status: String
				let static_code: String
				let sms_code: String
				let generated_time: String
				let final_md5: String
				let long_md5: String
				let device: String
			}

			let state: BlockState?
			let eSign: ESign?
		}

		struct Photo: Codable {
			let id: String
			let id_type: String
			let id_form: String
			let file_name: String
			let md5: String
			let latitude: String?
			let longtitude: String?
			let title_android: String
			let full_path: String
		}

		struct Custom: Codable {
			let name: String
			let text: String
			let value: Int
			let is_active: Bool
		}

		struct Doc: Codable {
			let id: String
			let md5: String?
			let title: String
			let position: String
		}

		let type: BlockType

		//Button block
		let action: ButtonAction?
		let button_text: String?
		let is_paymentData_needed: String?

		//Step block
		let step: String?
		let title: String?
		let state: State?
		let photos: [Photo]?
		let customs: [Custom]?
		let docs: [Doc]?
		let text: String?
	}
}
