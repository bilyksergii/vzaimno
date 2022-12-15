//
//  Formatter+Extension.swift
//  Vzaimno
//
//  Created by Sergii Bilyk on 13.09.2021.
//

import Foundation

extension Formatter {

	static let withSpaceSeparator: NumberFormatter = {
		let formatter = NumberFormatter()
		formatter.numberStyle = .decimal
		formatter.maximumFractionDigits = 2
		formatter.groupingSeparator = " "
		return formatter
	}()
}
