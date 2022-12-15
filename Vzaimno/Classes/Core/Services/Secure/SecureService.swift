//
//  SecureService.swift
//  Vzaimno
//
//  Created by Sergii Bilyk on 24.06.2021.
//

import Foundation

protocol SecureServiceProtocol {
	var authToken: String? { get }
	var userName: String? { get }
	func saveToken(_ token: String)
	func saveUserName(_ name: String)
	func clear()
	func isAuth() -> Bool
}

final class SecureService: SecureServiceProtocol {

	static let shared = SecureService()

	private let authTokenKey = "SecureService.authTokenKey"
	private let userNameKey = "SecureService.userNameKey"

	private init() {}

	// MARK: - SecureServiceInterface

	var authToken: String? {
		return UserDefaults.standard.string(forKey: authTokenKey)
	}

	var userName: String? {
		return UserDefaults.standard.string(forKey: userNameKey)
	}

	func saveToken(_ token: String) {
		UserDefaults.standard.set(token, forKey: authTokenKey)
	}

	func saveUserName(_ name: String) {
		UserDefaults.standard.set(name, forKey: userNameKey)
	}

	func isAuth() -> Bool {
		return authToken != nil
	}

	func clear() {
		UserDefaults.standard.removeObject(forKey: authTokenKey)
		UserDefaults.standard.removeObject(forKey: userNameKey)
	}
}
