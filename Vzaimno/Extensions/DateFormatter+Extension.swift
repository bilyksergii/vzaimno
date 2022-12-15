//
//  DateFormatter+Extension.swift
//  Vzaimno
//
//  Created by Sergii Bilyk on 24.06.2021.
//

import Foundation

extension DateFormatter {

	static var serverDateFormatter: DateFormatter = {
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
		return dateFormatter
	}()
}
