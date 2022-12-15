//
//  SigningViewController.swift
//  Vzaimno
//
//  Created by Sergii Bilyk on 20.07.2021.
//

import UIKit

protocol SigningViewProtocol: BaseViewProtocol {
	func signingDataUpdated(blocks: [SigningModel.Block], id_form: String)
}

class SigningViewController: BaseViewController {

	// MARK: - IBOutlets

	@IBOutlet weak var tableView: UITableView!

	// MARK: - Properties

	private lazy var router: SigningRouterProtocol = SigningRouter(sourceViewController: self)
	lazy var presenter = SigningPresenter(view: self, router: router)

	private var blocks: [SigningModel.Block]?
	private let refreshControl = UIRefreshControl()
	private var showTranche = false
	private var id_form: String?

	// MARK: - LifeCycle

	static func controller(showTranche: Bool = false) -> SigningViewController {
		let storyboard = UIStoryboard(name: "Signing", bundle: nil)
		let vc = storyboard.instantiateInitialViewController() as! SigningViewController
		vc.showTranche = showTranche
		return vc
	}

	override func viewDidLoad() {
		super.viewDidLoad()

		refreshControl.addTarget(self, action: #selector(onRefresh), for: .valueChanged)
		tableView.addSubview(refreshControl)

		tableView.register(UINib(nibName: SignStepCell.cellId, bundle: nil), forCellReuseIdentifier: SignStepCell.cellId)
		tableView.register(UINib(nibName: SignButtonCell.cellId, bundle: nil), forCellReuseIdentifier: SignButtonCell.cellId)
		tableView.register(UINib(nibName: SignTextCell.cellId, bundle: nil), forCellReuseIdentifier: SignTextCell.cellId)
		tableView.tableFooterView = UIView()
		tableView.rowHeight = UITableView.automaticDimension

		configureAppearance()
	}

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		hideTabBar()
		setNavigationBarStyleLight(true)
		presenter.getSigningData()
	}

	override func showLoader() {
		if !refreshControl.isRefreshing {
			activityIndicatorView?.startAnimating()
		}
	}

	// MARK: - LifeCycle

	private func configureAppearance() {
		addRightNavigationButton()
		navigationItem.title = "Подписание"
	}

	@objc private func onRefresh() {
		presenter.getSigningData()
	}
}

extension SigningViewController: UITableViewDataSource, UITableViewDelegate {

	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return blocks?.count ?? 0
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		guard let block = blocks?[indexPath.row] else { return UITableViewCell() }

		switch block.type {
		case .step:
			if let cell = tableView.dequeueReusableCell(withIdentifier: SignStepCell.cellId, for: indexPath) as? SignStepCell {
				cell.setupWith(item: block, switchValueChangedCompletion: { [weak self] value in
					self?.presenter.sendRightsAssignment(value: value)
				}, docActionCompletion: { [weak self] md5 in
					self?.presenter.downloadDoc(md5: md5)
				}, signActionCompletion: { [weak self] step in
					self?.presenter.stepGetSignCode(step: step)
				})
				cell.separatorView.isHidden = indexPath.row == 0
				cell.delegate = self
				return cell
			}
		case .text:
			if let cell = tableView.dequeueReusableCell(withIdentifier: SignTextCell.cellId, for: indexPath) as? SignTextCell {
				cell.setupWith(item: block)
				cell.separatorView.isHidden = indexPath.row == 0
				return cell
			}
		case .button:
			if let cell = tableView.dequeueReusableCell(withIdentifier: SignButtonCell.cellId, for: indexPath) as? SignButtonCell {
				cell.setupWith(item: block, completion: { [weak self] action in
					switch action {
					case .tranche:
						self?.router.showTranche(isSecond: false, id_form: self?.id_form ?? "")
					case .noTranche:
						self?.router.showFinalLoanRequest(is_paymentData_needed: block.is_paymentData_needed)
					case .none:
						return
					}
				})
				cell.separatorView.isHidden = indexPath.row == 0
				return cell
			}
		}

		return UITableViewCell()
	}
}

extension SigningViewController: SigningViewProtocol {

	func signingDataUpdated(blocks: [SigningModel.Block], id_form: String) {
		refreshControl.endRefreshing()
		self.blocks = blocks
		self.id_form = id_form
		tableView.reloadData()
		if showTranche {
			router.showTranche(isSecond: false, id_form: id_form, showModal: true)
			showTranche = false
		} else {
			presenter.checkPaymentResult()
		}
	}
}

extension SigningViewController: SignStepCellProtocol {

	func showFullScreenImage(imageLink: String) {
		router.showFullScreenImage(imageLink: imageLink)
	}
}
