//
//  Result.swift
//  Vzaimno
//
//  Created by Sergii Bilyk on 24.06.2021.
//

import Foundation

enum Result<T> {
	case success(T)
	case failure(Error)

	public func dematerialize() throws -> T {
		switch self {
		case let .success(value):
			return value
		case let .failure(error):
			throw error
		}
	}
}
