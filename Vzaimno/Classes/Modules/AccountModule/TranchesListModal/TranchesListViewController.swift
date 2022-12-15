//
//  TranchesListViewController.swift
//  Vzaimno
//
//  Created by Sergii Bilyk on 11.09.2021.
//

import UIKit

class TranchesListViewController: UIViewController {

	// MARK: - IBOutlets

	@IBOutlet weak var tapView: UIView!
	@IBOutlet weak var tableView: IntrinsicTableView!
	
	// MARK: - Properties

	private var tranches = [AccountData.Loan.Tranche]()
	private var completion: ((AccountData.Loan.Tranche) -> Void)?

	// MARK: - LifeCycle

	static func controller(tranches: [AccountData.Loan.Tranche], completion: ((AccountData.Loan.Tranche) -> Void)?) -> TranchesListViewController {
		let storyboard = UIStoryboard(name: "TranchesList", bundle: nil)
		let vc = storyboard.instantiateInitialViewController() as! TranchesListViewController
		vc.tranches = tranches
		vc.completion = completion
		return vc
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		configureAppearance()

		tableView.estimatedRowHeight = 49.0
		tableView.tableFooterView = UIView()

		tapView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapViewDone)))
	}

	// MARK: - Private

	private func configureAppearance() {
		view.backgroundColor = UIColor(white: 0.1, alpha: 0.5)
	}

	@objc private func tapViewDone(gestureRecognizer: UITapGestureRecognizer) {
		dismiss(animated: true, completion: nil)
	}
}

extension TranchesListViewController: UITableViewDataSource, UITableViewDelegate {

	func numberOfSections(in tableView: UITableView) -> Int {
		return 1
	}

	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		tranches.count
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let item = tranches[indexPath.row]
		guard let cell = tableView.dequeueReusableCell(withIdentifier: "TranchesListCell", for: indexPath) as? TranchesListCell else { return UITableViewCell() }
			cell.setupWith(item: item)
			return cell
	}

	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		dismiss(animated: true) { [weak self] in
			if let item = self?.tranches[indexPath.row] {
				self?.completion?(item)
			}
		}
	}
}
