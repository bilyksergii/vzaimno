//
//  Numeric+Extension.swift
//  Vzaimno
//
//  Created by Sergii Bilyk on 13.09.2021.
//

import Foundation

extension Numeric {
	
	var formattedWithSeparator: String { Formatter.withSpaceSeparator.string(for: self) ?? "" }
}
