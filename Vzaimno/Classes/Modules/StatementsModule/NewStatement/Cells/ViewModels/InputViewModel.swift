//
//  InputViewModel.swift
//  Vzaimno
//
//  Created by Sergii Bilyk on 29.09.2021.
//

import Foundation

class InputViewModel {
	let type: StatementInputType
	let title: String
	let placeholder: String?
	let required: String
	let input_name: String
	var input_text: String?
	var isExpanded: Bool

	init(input: NewStatement.TextInput) {
		self.type = input.type
		self.title = input.title
		self.placeholder = input.placeholder
		self.required = input.required
		self.input_name = input.input_name
		self.input_text = nil
		self.isExpanded = false
	}
}
