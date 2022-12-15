//
//  SignDocViewModel.swift
//  Vzaimno
//
//  Created by Sergii Bilyk on 22.07.2021.
//

import Foundation

class SignDocViewModel {
	let id: String
	let md5: String?
	let title: String
	let position: Int
	var switchIsOn: Bool
	var switchIsEnabled: Bool

	init(doc: SigningModel.Block.Doc) {
		self.id = doc.id
		self.md5 = doc.md5
		self.title = doc.title
		self.position = Int(doc.position) ?? 0
		self.switchIsOn = false
		self.switchIsEnabled = true
	}
}
