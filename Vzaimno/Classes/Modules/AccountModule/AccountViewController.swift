//
//  AccountViewController.swift
//  Vzaimno
//
//  Created by Sergii Bilyk on 16.08.2021.
//

import UIKit

protocol AccountViewProtocol: BaseViewProtocol {
	func accountDataUpdated(_ accountData: AccountData)
}

class AccountViewController: BaseViewController {

	private struct Section {
		let name: String
		let items: [AccountCellItem]
		var collapsed: Bool = false
	}

	// MARK: - IBOutlets

	@IBOutlet weak var scrollView: UIScrollView!
	@IBOutlet weak var navBarBgView: UIView!
	@IBOutlet weak var topBgView: UIView!

	@IBOutlet weak var collectionView: UICollectionView!
	@IBOutlet weak var tableView: UITableView!

	@IBOutlet weak var tableViewHeightConstraint: NSLayoutConstraint!

	@IBOutlet weak var trancheButton: UIButton!

	// MARK: - Properties

	private lazy var router: AccountRouterProtocol = AccountRouter(sourceViewController: self)
	private lazy var presenter = AccountPresenter(view: self, router: router)

	private let refreshControl = UIRefreshControl()

	private var accountData: AccountData? {
		didSet {
			banners = accountData?.banners
			prepareViewModelSections()
		}
	}

	private var sections = [Section]()
	private var banners: [AccountData.Banner]?

	private lazy var id_form_root: String? = {
		if let openedLoans = accountData?.loans?.filter ({ $0.is_opened == true }), openedLoans.count > 0 {
			return openedLoans.last?.id_form_root
		}
		return nil
	}()

	// MARK: - LifeCycle

	override func viewDidLoad() {
		super.viewDidLoad()

		refreshControl.addTarget(self, action: #selector(onRefresh), for: .valueChanged)
		refreshControl.tintColor = .white
		scrollView.addSubview(refreshControl)

		collectionView.delegate = self
		collectionView.dataSource = self

		tableView.delegate = self
		tableView.dataSource = self
		tableView.estimatedRowHeight = 44.0
		tableView.estimatedSectionHeaderHeight = 54.0
		tableView.rowHeight = UITableView.automaticDimension
		tableView.tableFooterView = UIView()
		tableView.register(UINib(nibName: "LoansHeaderView", bundle: nil), forHeaderFooterViewReuseIdentifier: "LoansHeaderView")

		configureAppearance()
		presenter.getAccountScreenData(checkIsSignNeeded: true)
	}

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		setNavigationBarStyleBlue()
		hideTabBar(false)
	}

	override func showLoader() {
		if !refreshControl.isRefreshing {
			activityIndicatorView?.startAnimating()
		}
	}

	// MARK: - Private

	private func configureAppearance() {
		navBarBgView.backgroundColor = UIColor.mainBlueColor
		topBgView.backgroundColor = UIColor.mainBlueColor
		navigationItem.title = "Уведомления"
		setNavigationBarStyleBlue()
		addLeftMenuButton()
		addRightNavigationButton(isWhite: true)
		addPanGestureToPresentMenu()
	}

	@objc private func onRefresh() {
		presenter.getAccountScreenData(checkIsSignNeeded: false)
	}

	private func prepareViewModelSections() {
		sections = [Section]()
		var firstSectionItems = [AccountCellItem]()
		if let orderItems = accountData?.order_data {
			firstSectionItems.append(contentsOf: orderItems)
		}
		if let items = (accountData?.loans?.filter { $0.is_opened == true }) {
			firstSectionItems.append(contentsOf: items)
		}
		if firstSectionItems.count > 0 {
			sections.append(Section(name: "Заявки и активные договоры", items: firstSectionItems))
		}

		if let secondSectionItems = (accountData?.loans?.filter { $0.is_opened == false }),
		   secondSectionItems.count > 0 {
			sections.append(Section(name: "Архивные договоры", items: secondSectionItems))
		}
	}

	private func updateTableViewHeight() {
		tableViewHeightConstraint.constant = tableView.contentSize.height < view.frame.size.height - 200
			? view.frame.size.height - 200 : tableView.contentSize.height + 100
	}

	private func prepareHtmlString(banner: AccountData.Banner) -> String {
		var imageString = ""
		if let iamageLink = banner.image_big {
			imageString = "<img style='width: 100%; height: auto;' src='\(Constants.APIConfiguration.host)\(iamageLink)'/>"
		}
		var titleString = ""
		if let title = banner.title {
			titleString = "<h2>\(title)</h2>"
		}

		let innerStr = imageString + titleString + (banner.text ?? "")

		return """
				<!DOCTYPE html>
				<html>
					<head>
						<meta name='viewport' content=\"width=device-width content='initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, user-scalable=no, shrink-to-fit=no' content="user-scalable=no"/>
						<link href=\"accountArtilce.css\" rel=\"stylesheet\" type=\"text/css\" />
						<style>body {margin: 0;}img {max-width: 100% !important;}.side-bar {display: none;}</style>
					</head>
					<body>
						\(innerStr)
					</body>
				</html>
				"""
	}

	// MARK: - IBActions

	@IBAction func trancheButtonAction(_ sender: Any) {
		if id_form_root != nil {
			router.showTranche(isSecond: true, id_form: id_form_root ?? "")
		} else {
			router.showNewСlientScreen()
		}
	}
}

extension AccountViewController: AccountViewProtocol {
	func accountDataUpdated(_ accountData: AccountData) {
		refreshControl.endRefreshing()
		self.accountData = accountData
		trancheButton.isHidden = accountData.order_data?.count ?? 0 > 0

		collectionView.reloadData()
		tableView.reloadData()

		updateTableViewHeight()
	}
}

extension AccountViewController: UICollectionViewDelegate, UICollectionViewDataSource {

	// MARK: - UICollectionViewDataSource

	func numberOfSections(in collectionView: UICollectionView) -> Int {
		return 1
	}

	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return banners?.count ?? 0
	}

	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BannerItemCell", for: indexPath) as? BannerItemCell, let bannerItem = banners?[indexPath.row] else { return UICollectionViewCell() }
		cell.setupWith(item: bannerItem)
		return cell
	}

	// MARK: - UICollectionViewDelegate

	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		if let banner = banners?[indexPath.row] {
			router.showWebViewScreen(url: nil, htmlString: prepareHtmlString(banner: banner), moveCloseButton: true)
		}
	}
}

extension AccountViewController: UITableViewDelegate, UITableViewDataSource {

	// MARK: - UITableViewDataSource

	func numberOfSections(in tableView: UITableView) -> Int {
		return sections.count
	}

	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return sections[section].collapsed ? 0 : sections[section].items.count
	}

	func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
		let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "LoansHeaderView") as? LoansHeaderView ?? LoansHeaderView()
		headerView.titleLabel.text = sections[section].name
		headerView.separatorView.isHidden = section == 0
		headerView.setCollapsed(sections[section].collapsed)
		headerView.tapCompletion = { [weak self] in
			let collapsed = !(self?.sections[section].collapsed ?? false)
			self?.sections[section].collapsed = collapsed
			headerView.setCollapsed(collapsed)
			UIView.setAnimationsEnabled(false)
			tableView.reloadSections(IndexSet(integer: section), with: .none)
			self?.updateTableViewHeight()
		}

		return headerView
	}

	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return sections[indexPath.section].collapsed ? 0 : UITableView.automaticDimension
	}

	func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
		return 54.0
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		if let orderItem = sections[indexPath.section].items[indexPath.row] as? AccountData.OrderData,
		   let cell = tableView.dequeueReusableCell(withIdentifier: "RequestItemCell", for: indexPath) as? RequestItemCell {
			cell.setupWith(item: orderItem)
			cell.selectionStyle = .none
			return cell
		}

		if let loanItem = sections[indexPath.section].items[indexPath.row] as? AccountData.Loan,
		   let cell = tableView.dequeueReusableCell(withIdentifier: "LoanItemCell", for: indexPath) as? LoanItemCell {
			cell.setupWith(item: loanItem)
			cell.selectionStyle = .none
			return cell
		}

		return UITableViewCell()
	}

	// MARK: - UITableViewDelegate

	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		if let orderItem = sections[indexPath.section].items[indexPath.row] as? AccountData.OrderData {
			switch orderItem.click_action {
			case .rejected:
				router.showRejectedScreen()
			case .upload_photos:
				presenter.getPhotos()
			case .verification:
				router.showSigningScreen(showTranche: false)
			}
		}

		if let loanItem = sections[indexPath.section].items[indexPath.row] as? AccountData.Loan {
			if loanItem.tranches.count > 1 {
				router.showTranchesList(tranches: loanItem.tranches, loanIsOpened: loanItem.is_opened, id_form_root: id_form_root)
			} else if let tranche = loanItem.tranches.first {
				router.showTrancheDetails(tranche: tranche, loanIsOpened: loanItem.is_opened, id_form_root: id_form_root)
			}
		}
	}
}
