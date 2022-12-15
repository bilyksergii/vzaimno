//
//  GetMonthlyPayParams .swift
//  Vzaimno
//
//  Created by Sergii Bilyk on 02.09.2021.
//

import Foundation

struct GetMonthlyPayParams: Encodable {
	let platform: String = "ios"
	let action: String = "getMounthPay"
	let token: String = SecureService.shared.authToken ?? ""
	let summ: String
	let term: String
	let lgot: String
	let id_form_root: String
	let wantInsurance: String
	let pay_way: String
}
