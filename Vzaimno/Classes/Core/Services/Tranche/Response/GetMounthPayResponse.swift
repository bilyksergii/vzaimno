//
//  GetMounthPayResponse.swift
//  Vzaimno
//
//  Created by Sergii Bilyk on 02.09.2021.
//

import Foundation

struct GetMounthPayResponse: Codable {
	struct MountPay: Codable {
		let mount_pay: String
		let mount_pay_number: String
	}

	let data: MountPay
}
