//
//  LoanRequestViewController.swift
//  Vzaimno
//
//  Created by Sergii Bilyk on 08.07.2021.
//

import UIKit

protocol LoanRequestViewProtocol: BaseViewProtocol {

}

class LoanRequestViewController: BaseViewController {

	// MARK: - IBOutlets

	@IBOutlet weak var infoLabel: UILabel!

	@IBOutlet weak var maxSummLabel: UILabel!
	@IBOutlet weak var summLabel: UILabel!
	@IBOutlet weak var summSlider: UISlider!

	@IBOutlet weak var maxTermLabel: UILabel!
	@IBOutlet weak var termLabel: UILabel!
	@IBOutlet weak var termSlider: UISlider!

	@IBOutlet weak var requestLoanButton: UIButton!

	// MARK: - Properties

	private lazy var router: LoanRequestRouterProtocol = LoanRequestRouter(sourceViewController: self)
	private lazy var presenter = LoanRequestPresenter(view: self, router: router)

	private var summFormatter: NumberFormatter = {
		let formatter = NumberFormatter()
		formatter.numberStyle = .decimal
		formatter.groupingSeparator = " "
		return formatter
	}()

	private let initialSumm = 500000
	private let initialTerm = 24

	private var selectedSumm = ""
	private var selectedTerm = ""

	// MARK: - LifeCycle

	static func controller() -> LoanRequestViewController {
		let storyboard = UIStoryboard(name: "LoanRequest", bundle: nil)
		let vc = storyboard.instantiateInitialViewController() as! LoanRequestViewController
		return vc
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		hideTabBar()
		configureAppearance()
	}

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		setNavigationBarStyleLight(true)
		hideNavBar(false)
	}

	// MARK: - Private

	private func configureAppearance() {
		hideBackButton()
		addRightNavigationButton()
		navigationItem.title = "Заявка"

		requestLoanButton.setTitle("Заявка", for: .normal)
		requestLoanButton.layer.cornerRadius = 8

		infoLabel.text = "Какую сумму и на какой срок вы хотите получить?"
		infoLabel.setLineSpacing()

		maxSummLabel.text = "Сумма (до 1 млн.)"
		summLabel.text = "500 000 ₽"
		summSlider.minimumTrackTintColor = .mainBlueColor
		summSlider.thumbTintColor = .mainBlueColor
		summSlider.minimumValue = 100000
		summSlider.maximumValue = 1000000
		summSlider.value = Float(initialSumm)

		maxTermLabel.text = "Срок (до 4 лет)"
		termLabel.text = "24 мес."
		termSlider.minimumTrackTintColor = .mainBlueColor
		termSlider.thumbTintColor = .mainBlueColor
		termSlider.minimumValue = 12
		termSlider.maximumValue = 48
		termSlider.value = Float(initialTerm)

		selectedSumm = String(initialSumm)
		selectedTerm = String(initialTerm)
	}

	// MARK: - IBActions

	@IBAction func requestLoanButtonAction(_ sender: Any) {
		presenter.newLoanRequest(summ: selectedSumm, term: selectedTerm)
	}

	@IBAction func summSliderValueChanged(_ sender: UISlider) {
		let step: Float = 10000
		let roudedValue = Int(round(sender.value / step) * step)
		sender.value = Float(roudedValue)
		selectedSumm = String(roudedValue)
		summLabel.text = "\(summFormatter.string(from: NSNumber(value: roudedValue)) ?? "") ₽"
	}

	@IBAction func termSliderValueChanged(_ sender: UISlider) {
		let roudedValue = Int(round(sender.value))
		selectedTerm = String(roudedValue)
		termLabel.text = "\(roudedValue) мес."
	}
}

extension LoanRequestViewController: LoanRequestViewProtocol {

}
