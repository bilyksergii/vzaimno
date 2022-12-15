//
//  DateFormat.swift
//  Vzaimno
//
//  Created by Sergii Bilyk on 02.07.2021.
//

import Foundation

class DateFormat {

	func secondsToMinutesSeconds(seconds : Int) -> (Int, Int) {
		return ((seconds % 3600) / 60, (seconds % 3600) % 60)
	}

	func getStringTimeFromSeconds(time: (Int, Int)) -> String {
		let minutes = time.0 < 10 ? "0\(String(time.0))" : String(time.0)
		let seconds = time.1 < 10 ? "0\(String(time.1))" : String(time.1)
		let stringTime = minutes + ":" + seconds
		return stringTime
	}
}
