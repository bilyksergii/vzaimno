//
//  PaymentsGraphicViewController.swift
//  Vzaimno
//
//  Created by Sergii Bilyk on 15.09.2021.
//

import UIKit

class PaymentsGraphicViewController: BaseViewController {

	// MARK: - IBOutlets

	@IBOutlet weak var tableView: UITableView!

	// MARK: - Properties

	private var paymentsGraphic = [TrancheDetails.Loan.Graphic]()

	// MARK: - LifeCycle

	static func controller(paymentsGraphic: [TrancheDetails.Loan.Graphic]) -> PaymentsGraphicViewController {
		let storyboard = UIStoryboard(name: "PaymentsGraphic", bundle: nil)
		let vc = storyboard.instantiateInitialViewController() as! PaymentsGraphicViewController
		vc.paymentsGraphic = paymentsGraphic
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
		navigationItem.title = "График платежей"
		addRightNavigationButton()
	}
}

extension PaymentsGraphicViewController: UITableViewDataSource, UITableViewDelegate {

	func numberOfSections(in tableView: UITableView) -> Int {
		return 1
	}

	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		paymentsGraphic.count
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let item = paymentsGraphic[indexPath.row]
		guard let cell = tableView.dequeueReusableCell(withIdentifier: "PaymentsGraphicCell", for: indexPath) as? PaymentsGraphicCell else { return UITableViewCell() }
			cell.setupWith(item: item)
			return cell
	}
}
