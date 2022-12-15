//
//  FirstScreen.swift
//  Vzaimno
//
//  Created by Sergii Bilyk on 13.07.2021.
//

import Foundation

enum ScreenRouter: String, Codable {
	case new_client
	case rejected
	case thankYou_page
	case account
}

struct FirstScreen: Codable {
	let screen: ScreenRouter?
	let text: String?
	let full: Bool?
	let photos: [Photo]?
}

struct Photo: Codable {
	let id: Int
	let title: String
	let image_group: Int
	let required: Bool?
	let file: String?
	let file_path: String?

	init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		id = Int(try container.decode(String.self, forKey: .id)) ?? 0
		title = try container.decode(String.self, forKey: .title)
		image_group = Int(try container.decode(String.self, forKey: .image_group)) ?? 0

		if let requiredString = try? container.decode(String.self, forKey: .required) {
			required = requiredString == "1" ? true : false
		} else {
			required = nil
		}

		file = try? container.decode(String.self, forKey: .file)
		file_path = try? container.decode(String.self, forKey: .file_path)
	}
}
