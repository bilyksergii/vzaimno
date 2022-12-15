//
//  SideMenuViewController.swift
//  Vzaimno
//
//  Created by Sergii Bilyk on 09.09.2021.
//

import UIKit
import SideMenu

protocol SideMenuViewProtocol: BaseViewProtocol {

}

class SideMenuViewController: BaseViewController {

	// MARK: - IBOutlets

	@IBOutlet weak var userNameLabel: UILabel!
	@IBOutlet weak var tableView: UITableView!

	// MARK: - Properties

	private lazy var router: SideMenuRouterProtocol = SideMenuRouter(sourceViewController: self)
	private lazy var presenter = SideMenuPresenter(view: self, router: router)

	// MARK: - lifeCycle

	static func controller() -> SideMenuNavigationController {
		let storyboard = UIStoryboard(name: "SideMenu", bundle: nil)
		let vc = storyboard.instantiateInitialViewController() as! SideMenuNavigationController
		return vc
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		userNameLabel.text = SecureService.shared.userName
		userNameLabel.setLineSpacing(lineSpacing: 10.0)

		tableView.estimatedRowHeight = 54.0
		tableView.tableFooterView = UIView()
	}
}

extension SideMenuViewController: SideMenuViewProtocol {
	
}

extension SideMenuViewController: UITableViewDataSource, UITableViewDelegate {

	func numberOfSections(in tableView: UITableView) -> Int {
		return 1
	}

	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		SideMenuViewModel.allCases.count
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let item = SideMenuViewModel.allCases[indexPath.row]
		guard let cell = tableView.dequeueReusableCell(withIdentifier: "SideMenuCell", for: indexPath) as? SideMenuCell else { return UITableViewCell() }
			cell.setupWith(item: item)
			return cell
	}

	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		presenter.selectedMenu(SideMenuViewModel.allCases[indexPath.row])
	}
}

