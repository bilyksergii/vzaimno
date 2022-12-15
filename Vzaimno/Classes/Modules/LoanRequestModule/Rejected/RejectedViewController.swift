//
//  RejectedViewController.swift
//  Vzaimno
//
//  Created by Sergii Bilyk on 16.09.2021.
//

import UIKit

class RejectedViewController: BaseViewController {

	// MARK: - IBOutlets

	@IBOutlet weak var requestLoanButton: UIButton!
	@IBOutlet weak var infoLabel: UILabel!

	// MARK: - Properties

	private lazy var router: RejectedRouterProtocol = RejectedRouter(sourceViewController: self)

	// MARK: - LifeCycle

	static func controller() -> RejectedViewController {
		let storyboard = UIStoryboard(name: "Rejected", bundle: nil)
		let vc = storyboard.instantiateInitialViewController() as! RejectedViewController
		return vc
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		configureAppearance()
	}

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		hideNavBar(false)
		setNavigationBarStyleLight(true)
	}

	// MARK: - Private

	private func configureAppearance() {
		hideBackButton()
		addRightNavigationButton()
		navigationItem.title = "Заявка"

		requestLoanButton.setTitle("Подать повторно", for: .normal)
		requestLoanButton.layer.cornerRadius = 8

		infoLabel.text = "Мы очень сожалеем, но по Вашей заявке было принято отрицательное решение. Надеемся, что будем Вам полезны в следующий раз."
		infoLabel.setLineSpacing()
	}

	// MARK: - IBActions

	@IBAction func requestLoanButtonAction(_ sender: Any) {
		router.showLoanRequestScreen()
	}
}
