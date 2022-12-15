//
//  TrancheRouter.swift
//  Vzaimno
//
//  Created by Sergii Bilyk on 30.08.2021.
//

import Foundation

protocol TrancheRouterProtocol: BaseRouterProtocol {
	func showTrancheRequestApproved()
}

class TrancheRouter: BaseRouter, TrancheRouterProtocol {
	func showTrancheRequestApproved() {
		let vc = TrancheRequestApprovedViewController.controller(completion: { [weak self] in
			self?.sourceViewController?.navigationController?.popViewController(animated: true)
		})
		vc.modalPresentationStyle = .overCurrentContext
		vc.modalTransitionStyle = .crossDissolve
		sourceViewController?.present(vc, animated: true, completion: nil)
	}
}
