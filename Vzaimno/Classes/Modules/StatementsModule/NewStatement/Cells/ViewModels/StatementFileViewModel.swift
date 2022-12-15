//
//  StatementFileViewModel.swift
//  Vzaimno
//
//  Created by Sergii Bilyk on 04.10.2021.
//

import Foundation

class StatementFileViewModel {
	let fname_user: String
	let fname_hash: String

	init(fname_user: String, fname_hash: String) {
		self.fname_user = fname_user
		self.fname_hash = fname_hash
	}
}
