//
//  CacheService.swift
//  Vzaimno
//
//  Created by Sergii Bilyk on 27.09.2021.
//

import Foundation

protocol CacheServiceProtocol: AnyObject {
	func saveTranches(_ tranches: [AccountData.Loan.Tranche])
	func getTranches() -> [AccountData.Loan.Tranche]?
	func clearCaches()
}

final class CacheService: CacheServiceProtocol {

	// MARK: - Static

	static let shared = CacheService()

	// MARK: - Properties

	private let queue = DispatchQueue(label: "CacheService")

	private var _userTranches: [AccountData.Loan.Tranche]?
	private var userTranches: [AccountData.Loan.Tranche]? {
		get { queue.sync { _userTranches } }
		set { queue.sync { _userTranches = newValue } }
	}

	// MARK: - Internal

	func saveTranches(_ tranches: [AccountData.Loan.Tranche]) {
		userTranches = tranches
	}

	func getTranches() -> [AccountData.Loan.Tranche]? {
		return userTranches
	}

	func clearCaches() {
		userTranches = nil
	}
}
