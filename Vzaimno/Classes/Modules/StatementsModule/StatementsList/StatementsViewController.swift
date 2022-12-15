//
//  StatementsViewController.swift
//  Vzaimno
//
//  Created by Sergii Bilyk on 22.09.2021.
//

import UIKit

protocol StatementsViewProtocol: BaseViewProtocol {
	func statementsUpdated(_ statements: [Statement]?)
}

class StatementsViewController: BaseViewController {

	// MARK: - IBOutlets

	@IBOutlet weak var topBgView: UIView!
	@IBOutlet weak var tableView: UITableView!
	@IBOutlet weak var sendStatementButton: UIButton!
	
	// MARK: - Properties

	private lazy var router: StatementsRouterProtocol = StatementsRouter(sourceViewController: self)
	private lazy var presenter = StatementsPresenter(view: self, router: router)

	private let refreshControl = UIRefreshControl()

	private var statements: [Statement]?
	private var newStatementWasShown = false

	// MARK: - LifeCycle

	override func viewDidLoad() {
		super.viewDidLoad()
		configureAppearance()

		refreshControl.addTarget(self, action: #selector(onRefresh), for: .valueChanged)
		tableView.addSubview(refreshControl)

		tableView.delegate = self
		tableView.dataSource = self
		tableView.estimatedRowHeight = 47.0
		tableView.estimatedSectionHeaderHeight = 44.0
		tableView.rowHeight = UITableView.automaticDimension
		tableView.tableFooterView = UIView()
		tableView.register(UINib(nibName: "StatementsHeaderView", bundle: nil),
						   forHeaderFooterViewReuseIdentifier: "StatementsHeaderView")
	}

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		setNavigationBarStyleBlue()
		hideTabBar(false)
		presenter.getStatementsList()
	}

	override func showLoader() {
		if !refreshControl.isRefreshing {
			activityIndicatorView?.startAnimating()
		}
	}

	// MARK: - Private

	private func configureAppearance() {
		navigationItem.title = "Заявления"
		topBgView.backgroundColor = UIColor.mainBlueColor
		sendStatementButton.isHidden = !presenter.userHasTranches
	}

	@objc private func onRefresh() {
		presenter.getStatementsList()
	}

	// MARK: - IBActions

	@IBAction func sendStatementButtonAction(_ sender: Any) {
		router.showNewStatement()
	}
}

extension StatementsViewController: StatementsViewProtocol {

	func statementsUpdated(_ statements: [Statement]?) {
		self.statements = statements
		refreshControl.endRefreshing()
		if !newStatementWasShown && (statements == nil || statements?.count == 0) && presenter.userHasTranches {
			newStatementWasShown = true
			router.showNewStatement()
		} else {
			tableView.reloadData()
		}
	}
}

extension StatementsViewController: UITableViewDelegate, UITableViewDataSource {

	// MARK: - UITableViewDataSource

	func numberOfSections(in tableView: UITableView) -> Int {
		return 1
	}

	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return statements?.count ?? 0
	}

	func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
		return tableView.dequeueReusableHeaderFooterView(withIdentifier: "StatementsHeaderView") as? StatementsHeaderView
	}

	func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
		return 47.0
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		if let statementItem = statements?[indexPath.row],
			let cell = tableView.dequeueReusableCell(withIdentifier: "StatementsCell", for: indexPath) as? StatementsCell {
			cell.setupWith(item: statementItem)
			return cell
		}
		return UITableViewCell()
	}

	// MARK: - UITableViewDelegate

	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		if let statementItem = statements?[indexPath.row] {
			router.openStatement(statementItem)
		}
	}
}
