//
//  SideMenuPresenter.swift
//  Vzaimno
//
//  Created by Sergii Bilyk on 09.09.2021.
//

import Foundation

protocol SideMenuPresenterProtocol: AnyObject {
	func selectedMenu(_ item: SideMenuViewModel)
}

class SideMenuPresenter: SideMenuPresenterProtocol {

	weak var view: SideMenuViewProtocol?
	private let router:  SideMenuRouterProtocol

	init(view: SideMenuViewProtocol,
		 router: SideMenuRouterProtocol) {
		self.view = view
		self.router = router
	}

	func selectedMenu(_ item: SideMenuViewModel) {
		switch item {
		case .about,
			 .license,
			 .payment:
			router.showMenuItemWith(item.url, navTitle: item.title)
		case .exit:
			router.logout()
		}
	}
}
