//
//  SideMenuViewModel.swift
//  Vzaimno
//
//  Created by Sergii Bilyk on 09.09.2021.
//

import Foundation

enum SideMenuViewModel: CaseIterable {
	case about
	case license
	case payment
	case exit

	var title: String {
		switch self {
		case .about: return "О компании"
		case .license: return "Документы компании"
		case .payment: return "Помощь"
		case .exit: return "Выход"
		}
	}

	var url: URL? {
		switch self {
		case .about: return URL(string: "https://www.mfovzaimno.ru/webview/about")
		case .license: return URL(string: "https://www.mfovzaimno.ru/webview/license")
		case .payment: return URL(string: "https://www.mfovzaimno.ru/webview/payment")
		case .exit: return nil
		}
	}
}
