//
//  PaymentsHistoryViewController.swift
//  Vzaimno
//
//  Created by Sergii Bilyk on 15.09.2021.
//

import UIKit

class PaymentsHistoryViewController: BaseViewController {

	// MARK: - IBOutlets

	@IBOutlet weak var tableView: UITableView!

	// MARK: - Properties

	private var paymentsHistory = [TrancheDetails.Loan.History]()

	// MARK: - LifeCycle

	static func controller(paymentsHistory: [TrancheDetails.Loan.History]) -> PaymentsHistoryViewController {
		let storyboard = UIStoryboard(name: "PaymentsHistory", bundle: nil)
		let vc = storyboard.instantiateInitialViewController() as! PaymentsHistoryViewController
		vc.paymentsHistory = paymentsHistory
		return vc
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		configureAppearance()
	}

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		setNavigationBarStyleLight(true)
	}

	// MARK: - Private

	private func configureAppearance() {
		navigationItem.title = "История платежей"
		addRightNavigationButton()
	}
}

extension PaymentsHistoryViewController: UITableViewDataSource, UITableViewDelegate {

	func numberOfSections(in tableView: UITableView) -> Int {
		return 1
	}

	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		paymentsHistory.count
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let item = paymentsHistory[indexPath.row]
		guard let cell = tableView.dequeueReusableCell(withIdentifier: "PaymentsHistoryCell", for: indexPath) as? PaymentsHistoryCell else { return UITableViewCell() }
			cell.setupWith(item: item)
			return cell
	}
}
