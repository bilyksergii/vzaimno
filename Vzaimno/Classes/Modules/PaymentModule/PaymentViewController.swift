//
//  PaymentViewController.swift
//  Vzaimno
//
//  Created by Sergii Bilyk on 05.10.2021.
//

import UIKit

class PaymentViewController: BaseViewController {

	// MARK: - Properties

	private lazy var router: BaseRouterProtocol = BaseRouter(sourceViewController: self)

	// MARK: - LifeCycle

	override func viewDidLoad() {
		super.viewDidLoad()
		openPaymentUrl()
	}

	// MARK: - Private

	private func openPaymentUrl() {
		router.showPayment()
	}
}
