//
//  FirstScreen.swift
//  Vzaimno
//
//  Created by Sergii Bilyk on 12.07.2021.
//

import Foundation

struct FirstScreen: Codable {
	let screen: String
	let text: String
	let full: Bool?
	let photos: [Photo]?

	enum CodingKeys: String, CodingKey {
		case screen = "screen"
		case text = "text"
		case full = "full"
		case photos = "photos"
	}

	init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		screen = try container.decode(String.self, forKey: .screen)
		text = try container.decode(String.self, forKey: .text)
		full = try? container.decode(Bool.self, forKey: .full)
		photos = try container.decode([Photo].self, forKey: .photos)
	}
}

struct Photo: Codable {
	let id: Int
	let title: String
	let image_group: Int
	let required: Bool?
	let file: String?
	let file_path: String?

	enum CodingKeys: String, CodingKey {
		case id = "id"
		case title = "title"
		case image_group = "image_group"
		case required = "required"
		case file = "file"
		case file_path = "file_path"
	}

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
