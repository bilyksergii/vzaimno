//
//  String+Extension.swift
//  Vzaimno
//
//  Created by Sergii Bilyk on 04.07.2021.
//

import Foundation

extension String {

	var onlyNumbers: String {
		return map { String ($0) }.filter { Int($0) != nil }.joined(separator: "")
	}

	private func toDate(withFormat format: String = "yyyy-MM-dd")-> Date?{
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = format
		let date = dateFormatter.date(from: self)
		return date
	}

	func dateStringToDDMMYYYYString() -> String? {
		return self.toDate()?.dateToDDMMYYYYString()
	}

	var formattedWithSeparatorAsFloat: String { Formatter.withSpaceSeparator.string(for: Float(self)) ?? "" }
}
