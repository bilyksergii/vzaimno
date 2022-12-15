//
//  TrancheDetailsViewController.swift
//  Vzaimno
//
//  Created by Sergii Bilyk on 11.09.2021.
//

import UIKit

protocol TrancheDetailsViewProtocol: BaseViewController {
	func trancheDetailsUpdated(_ trancheDetails: TrancheDetails)
}

class TrancheDetailsViewController: BaseViewController {

	// MARK: - IBOutlets

	@IBOutlet weak var navBarBgView: UIView!
	@IBOutlet weak var topBgView: UIView!
	@IBOutlet weak var scrollView: UIScrollView!
	@IBOutlet weak var owesStackViewHeightConstraint: NSLayoutConstraint!

	@IBOutlet weak var topInfoStackView: UIStackView!
	@IBOutlet weak var loanSummLabel: UILabel!
	@IBOutlet weak var loanDateLabel: UILabel!	
	@IBOutlet weak var loanCurrentDate: UILabel!

	@IBOutlet weak var owesStackView: UIStackView!

	@IBOutlet weak var oweFullStackView: UIStackView!
	@IBOutlet weak var oweFullSeparatorView: UIView!
	@IBOutlet weak var oweFullDateLabel: UILabel!
	@IBOutlet weak var oweFullTeloLabel: UILabel!
	@IBOutlet weak var oweFullProcLabel: UILabel!
	@IBOutlet weak var oweFullPeniLabel: UILabel!
	@IBOutlet weak var oweFullSummLabel: UILabel!

	@IBOutlet weak var oweOweStackView: UIStackView!
	@IBOutlet weak var oweOweSeparatorView: UIView!
	@IBOutlet weak var oweOweTeloLabel: UILabel!
	@IBOutlet weak var oweOweProcLabel: UILabel!
	@IBOutlet weak var oweOwePeniLabel: UILabel!
	@IBOutlet weak var oweOweSummLabel: UILabel!

	@IBOutlet weak var oweNextMainStackView: UIStackView!
	@IBOutlet weak var oweNextInsideStackView: UIStackView!
	@IBOutlet weak var oweNextTitleLabel: UILabel!
	@IBOutlet weak var oweNextStackView: UIStackView!

	@IBOutlet weak var oweNextDateLabel: UILabel!
	@IBOutlet weak var oweNextTeloLabel: UILabel!
	@IBOutlet weak var oweNextProcLabel: UILabel!
	@IBOutlet weak var oweNextPeniLabel: UILabel!

	@IBOutlet weak var loanGraphicButton: UIButton!
	@IBOutlet weak var loanHistoryButton: UIButton!
	@IBOutlet weak var oweNextPayButton: UIButton!
	@IBOutlet weak var trancheButton: UIButton!

	// MARK: - Properties

	private lazy var router: TrancheDetailsRouterProtocol = TrancheDetailsRouter(sourceViewController: self)
	private lazy var presenter = TrancheDetailsPresenter(view: self, router: router)

	private let refreshControl = UIRefreshControl()
	private var tranche: AccountData.Loan.Tranche!
	private var trancheDetails: TrancheDetails?
	private var loanIsOpened = false
	private var id_form_root: String?

	// MARK: - LifeCycle

	static func controller(tranche: AccountData.Loan.Tranche, loanIsOpened: Bool, id_form_root: String?) -> TrancheDetailsViewController {
		let storyboard = UIStoryboard(name: "TrancheDetails", bundle: nil)
		let vc = storyboard.instantiateInitialViewController() as! TrancheDetailsViewController
		vc.tranche = tranche
		vc.loanIsOpened = loanIsOpened
		vc.id_form_root = id_form_root
		return vc
	}

	override func viewDidLoad() {
		super.viewDidLoad()

		refreshControl.addTarget(self, action: #selector(onRefresh), for: .valueChanged)
		refreshControl.tintColor = .white
		scrollView.addSubview(refreshControl)
		configureAppearance()
		presenter.getTrancheDetails(guid: tranche.guid)
	}

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)

		setNavigationBarStyleBlue()
		hideTabBar()
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
		navigationItem.title = tranche.number
		setNavigationBarStyleBlue()
		addRightNavigationButton(isWhite: true)
		owesStackView.addBackground(color: .white, rounded: true)

		scrollView.alwaysBounceVertical = true

		topInfoStackView.isHidden = true

		oweFullStackView.isHidden = true
		oweFullSeparatorView.isHidden = true

		oweOweStackView.isHidden = true
		oweOweSeparatorView.isHidden = true

		oweNextMainStackView.isHidden = true
		oweNextStackView.isHidden = true
		oweNextTitleLabel.isHidden = true
		oweNextPayButton.isHidden = true

		oweNextInsideStackView.addBlueBorders()

		loanGraphicButton.isHidden = true
		loanHistoryButton.isHidden = true
		trancheButton.isHidden = true

		loanGraphicButton.setUnderlinedText("График платежей", font: UIFont.ekibastuzBold15, color: .mainBlueColor)
		loanHistoryButton.setUnderlinedText("История платежей", font: UIFont.ekibastuzBold15, color: .mainBlueColor)
	}

	private func fillScreenData() {
		topInfoStackView.isHidden = false
		loanSummLabel.text = trancheDetails?.loan.sum.formattedWithSeparatorAsFloat
		loanDateLabel.text = trancheDetails?.loan.date.dateStringToDDMMYYYYString()
		loanCurrentDate.text = Date().dateToDDMMYYYYString()

		if trancheDetails?.owe.full != nil {
			oweFullStackView.isHidden = false
			oweFullSeparatorView.isHidden = false
			oweFullDateLabel.text = trancheDetails?.owe.full?.date?.dateStringToDDMMYYYYString()
			oweFullTeloLabel.text = trancheDetails?.owe.full?.telo?.formattedWithSeparatorAsFloat ?? "0"
			oweFullProcLabel.text = trancheDetails?.owe.full?.proc?.formattedWithSeparatorAsFloat ?? "0"
			oweFullPeniLabel.text = trancheDetails?.owe.full?.peni?.formattedWithSeparatorAsFloat ?? "0"
			oweFullSummLabel.text = trancheDetails?.owe.full?.summ?.formattedWithSeparatorAsFloat ?? "0"
		}

		if trancheDetails?.owe.owe != nil {
			oweOweStackView.isHidden = false
			oweOweSeparatorView.isHidden = false
			oweOweTeloLabel.text = trancheDetails?.owe.owe?.telo?.formattedWithSeparatorAsFloat ?? "0"
			oweOweProcLabel.text = trancheDetails?.owe.owe?.proc?.formattedWithSeparatorAsFloat ?? "0"
			oweOwePeniLabel.text = trancheDetails?.owe.owe?.peni?.formattedWithSeparatorAsFloat ?? "0"
			oweOweSummLabel.text = trancheDetails?.owe.owe?.summ?.formattedWithSeparatorAsFloat ?? "0"
		}

		if trancheDetails?.owe.next != nil
			|| (trancheDetails?.loan.graphic?.count ?? 0 > 0)
			|| (trancheDetails?.loan.history?.count ?? 0 > 0) {
			oweNextMainStackView.isHidden = false
		}

		if trancheDetails?.owe.next != nil {
			oweNextStackView.isHidden = false
			oweNextTitleLabel.isHidden = false
			oweNextPayButton.isHidden = false
			oweNextDateLabel.text = trancheDetails?.owe.next?.date?.dateStringToDDMMYYYYString()
			oweNextTeloLabel.text = trancheDetails?.owe.next?.telo?.formattedWithSeparatorAsFloat ?? "0"
			oweNextProcLabel.text = trancheDetails?.owe.next?.proc?.formattedWithSeparatorAsFloat ?? "0"
			oweNextPeniLabel.text = trancheDetails?.owe.next?.peni?.formattedWithSeparatorAsFloat ?? "0"
		}

		loanGraphicButton.isHidden = !(trancheDetails?.loan.graphic?.count ?? 0 > 0)
		loanHistoryButton.isHidden = !(trancheDetails?.loan.history?.count ?? 0 > 0)

		trancheButton.isHidden = !loanIsOpened
	}

	@objc private func onRefresh() {
		presenter.getTrancheDetails(guid: tranche.guid)
	}

	// MARK: - IBActions

	@IBAction func loanGraphicButtonAction(_ sender: Any) {
		if let graphic = trancheDetails?.loan.graphic {
			router.showPaymentsGraphic(paymentsGraphic: graphic)
		}
	}

	@IBAction func loanHistoryButtonAction(_ sender: Any) {
		if let history = trancheDetails?.loan.history {
			router.showPaymentsHistory(paymentsHistory: history)
		}
	}

	@IBAction func oweNextPayButtonAction(_ sender: Any) {
		router.showPayment()
	}

	@IBAction func trancheButtonAction(_ sender: Any) {
		router.showTranche(isSecond: true, id_form: id_form_root ?? "")
	}
}

extension TrancheDetailsViewController: TrancheDetailsViewProtocol {

	func trancheDetailsUpdated(_ trancheDetails: TrancheDetails) {
		if owesStackViewHeightConstraint != nil, owesStackViewHeightConstraint.isActive {
			owesStackViewHeightConstraint.isActive = false
			view.layoutIfNeeded()
		}
		refreshControl.endRefreshing()
		self.trancheDetails = trancheDetails
		fillScreenData()
	}
}
