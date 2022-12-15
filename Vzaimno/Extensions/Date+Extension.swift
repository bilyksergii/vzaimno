//
//  Date+Extension.swift
//  Vzaimno
//
//  Created by Sergii Bilyk on 13.09.2021.
//

import Foundation

extension Date {

	func dateToDDMMYYYYString(withFormat format: String = "dd.MM.yyyy") -> String {
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = format
		let str = dateFormatter.string(from: self)
		return str
	}
}
