//
//  SideMenuRouter.swift
//  Vzaimno
//
//  Created by Sergii Bilyk on 09.09.2021.
//

import Foundation

protocol SideMenuRouterProtocol: BaseRouterProtocol {
	func showMenuItemWith(_ url: URL?, navTitle: String)
}

class SideMenuRouter: BaseRouter, SideMenuRouterProtocol {

	func showMenuItemWith(_ url: URL?, navTitle: String) {
		let vc = WebDocViewController.controller(url: url, navTitle: navTitle)
		sourceViewController?.navigationController?.pushViewController(vc, animated: true)
	}
}
