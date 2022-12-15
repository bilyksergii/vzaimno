//
//  TrancheViewController.swift
//  Vzaimno
//
//  Created by Sergii Bilyk on 30.08.2021.
//

import UIKit
import TVMaskField

protocol TrancheViewProtocol: BaseViewProtocol {
	func isInsuranceAvailableUpdated(isAvailable: Bool)
	func monthlyPaymentUpdated(monthPay: String)
	func secretQuestionsUpdated(questions: [SecretQuestion])
}

class TrancheViewController: BaseViewController {

	// MARK: - IBOutlets
	@IBOutlet weak var mainScrollView: UIScrollView!

	@IBOutlet weak var insuranceContainerView: UIStackView!
	@IBOutlet weak var insuranceButton: UIButton!
	@IBOutlet weak var insuranceEmailView: UIStackView!
	@IBOutlet weak var insuranceEmailTextField: UITextField!
	@IBOutlet weak var insuranceLabelButton: UIButton!
	@IBOutlet weak var monthlyPaymentLabel: UILabel!

	@IBOutlet weak var summTextField: UITextField!
	@IBOutlet weak var termTextField: UITextField!
	@IBOutlet weak var gracePeriodTextField: UITextField!

	@IBOutlet weak var secretQuestionContainerView: UIStackView!
	@IBOutlet weak var secretQuestionSeparator: UIView!
	@IBOutlet weak var secretQuestionPicker: TextFieldWithPicker!
	@IBOutlet weak var secretAnswerTextField: UITextField!

	@IBOutlet weak var bankCardButton: UIButton!
	@IBOutlet weak var bankAccountButton: UIButton!
	@IBOutlet weak var systemContactButton: UIButton!
	@IBOutlet weak var cashInOfficeButton: UIButton!

	@IBOutlet weak var bankCardStackView: UIStackView!
	@IBOutlet weak var bankAccountStackView: UIStackView!
	@IBOutlet weak var systemContactStackView: UIStackView!
	@IBOutlet weak var cashInOfficeStackView: UIStackView!

	@IBOutlet weak var cardNumberTextField: TVMaskTextField!
	@IBOutlet weak var cardDateTextField: TVMaskTextField!
	@IBOutlet weak var cardNameTextField: UITextField!

	@IBOutlet weak var bankAccountBankTextField: UITextField!
	@IBOutlet weak var bankAccountCorrAccountTextField: UITextField!
	@IBOutlet weak var bankAccountBikTextField: UITextField!
	@IBOutlet weak var bankAccountUserNameTextField: UITextField!
	@IBOutlet weak var bankAccountUserAccountTextField: UITextField!

	@IBOutlet weak var contactCityNameTextField: UITextField!

	@IBOutlet weak var requestButton: UIButton!

	// MARK: - Properties

	private lazy var router: TrancheRouterProtocol = TrancheRouter(sourceViewController: self)
	private lazy var presenter = TranchePresenter(view: self, router: router)

	private var isSecond = false
	private var insuranceIsSelected = false {
		didSet {
			performMonthlySummRequest()
		}
	}

	private var pWayButtons = [UIButton]()
	private var pWayViews = [UIStackView]()

	private var selectedPWay = 3
	private var textEditTimer: Timer?
	private var id_form: String!
	private var showModal: Bool!

	// MARK: - LifeCycle

	static func controller(isSecond: Bool = false, id_form: String, showModal: Bool = false) -> TrancheViewController {
		let storyboard = UIStoryboard(name: "Tranche", bundle: nil)
		let vc = storyboard.instantiateInitialViewController() as! TrancheViewController
		vc.isSecond = isSecond
		vc.id_form = id_form
		vc.showModal = showModal
		return vc
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		hideTabBar()
		presenter.isInsuranceAvailable()
		configureAppearance()
		createPWayArrays()
		setSelectedPWay(index: selectedPWay - 1, needToScrollDown: false)
		if !isSecond {
			presenter.getSecretQuestions()
		}
		if showModal {
			presenter.checkPaymentResult()
		}
	}

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		setNavigationBarStyleLight(true)
	}

	// MARK: - Private

	private func configureAppearance() {
		addRightNavigationButton()
		navigationItem.title = "Заявка на транш"

		insuranceContainerView.isHidden = true
		insuranceEmailView.isHidden = true
		monthlyPaymentLabel.isHidden = true
		insuranceLabelButton.setUnderlinedText("Оформить страховку", font: UIFont.ekibastuzRegular13, color: .black)

		if isSecond {
			secretQuestionContainerView.isHidden = true
			secretQuestionSeparator.isHidden = true
		} else {
			secretQuestionPicker.dropDownIcon = #imageLiteral(resourceName: "polygon_down")
		}
		setRequestPhoneButtonState(isEnabled: false)
		gracePeriodTextField.text = "0"
	}

	private func createPWayArrays() {
		pWayButtons = [cashInOfficeButton, bankAccountButton, bankCardButton, systemContactButton]
		pWayViews = [cashInOfficeStackView, bankAccountStackView, bankCardStackView, systemContactStackView]
	}

	private func setSelectedPWay(index: Int, needToScrollDown: Bool = true) {
		selectedPWay = index + 1
		let selectedButton = pWayButtons[index]
		pWayButtons.forEach { $0.isSelected = $0 == selectedButton ? true : false }
		let selectedView = pWayViews[index]
		pWayViews.forEach { $0.isHidden = $0 == selectedView ? false : true }
		performMonthlySummRequest()
		setRequestPhoneButtonState(isEnabled: checkFormIsFilled())
		if needToScrollDown {
			DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: { [weak self] in
				self?.scrollToBottom()
			})
		}
	}

	private func scrollToBottom() {
		let bottomOffset = CGPoint(x: 0, y: mainScrollView.contentSize.height - mainScrollView.bounds.size.height)
		mainScrollView.setContentOffset(bottomOffset, animated: true)
	}

	private func setRequestPhoneButtonState(isEnabled: Bool) {
		requestButton.isEnabled = isEnabled
		requestButton.backgroundColor = isEnabled ? UIColor.mainBlueColor : UIColor.lightGray
	}

	private func checkFormIsFilled() -> Bool {
		if (summTextField.text ?? "").isEmpty
			|| (termTextField.text ?? "").isEmpty
			|| (gracePeriodTextField.text ?? "").isEmpty {
			return false
		}

		if insuranceIsSelected {
			if (insuranceEmailTextField.text ?? "").isEmpty {
				return false
			}
		}

		if secretQuestionContainerView.isHidden == false {
			if (secretAnswerTextField.text ?? "").isEmpty {
				return false
			}
		}

		if bankCardButton.isSelected == true {
			if (cardNumberTextField.text ?? "").isEmpty
				|| (cardDateTextField.text ?? "").isEmpty
				|| (cardNameTextField.text ?? "").isEmpty {
				return false
			}
		}

		if bankAccountButton .isSelected == true {
			if (bankAccountBankTextField.text ?? "").isEmpty
				|| (bankAccountCorrAccountTextField.text ?? "").isEmpty
				|| (bankAccountBikTextField.text ?? "").isEmpty
				|| (bankAccountUserNameTextField.text ?? "").isEmpty
				|| (bankAccountUserAccountTextField.text ?? "").isEmpty {
				return false
			}
		}

		if systemContactButton.isSelected == true {
			if (contactCityNameTextField.text ?? "").isEmpty {
				return false
			}
		}
		return true
	}

	private func prepareAddDataJSON() -> String {
		switch selectedPWay {
		case 1:
			return "{}"
		case 2:
			return encodeDictToJSON(dict: ["param1": (bankAccountBankTextField.text ?? ""),
										   "param2": (bankAccountCorrAccountTextField.text ?? ""),
										   "param3": (bankAccountBikTextField.text ?? ""),
										   "param4": (bankAccountUserNameTextField.text ?? ""),
										   "param5": (bankAccountUserAccountTextField.text ?? "")])
		case 3:
			return encodeDictToJSON(dict: ["param1": (cardNumberTextField.text ?? "").onlyNumbers,
										   "param2": (cardDateTextField.text ?? "").onlyNumbers,
										   "param3": (cardNameTextField.text ?? "")])
		case 4:
			return encodeDictToJSON(dict: ["param1": contactCityNameTextField.text ?? ""])
		default:
			return ""
		}
	}

	@objc private func performMonthlySummRequest() {
		if !((summTextField.text ?? "").isEmpty)
		   && !((termTextField.text ?? "").isEmpty)
		   && !((gracePeriodTextField.text ?? "").isEmpty) {
			presenter.getMounthPay(summ: summTextField.text?.replacingOccurrences(of: " ", with: "") ?? "",
								   term: termTextField.text ?? "",
								   lgot: gracePeriodTextField.text ?? "",
								   id_form_root: id_form,
								   wantInsurance: insuranceIsSelected ? "1" : "0",
								   pay_way: String(selectedPWay))
		}
	}

	// MARK: - IBActions

	@IBAction func insuranceButtonAction(_ sender: Any) {
		insuranceButton.isSelected = insuranceIsSelected ? false : true
		insuranceIsSelected = !insuranceIsSelected
		insuranceEmailView.isHidden = !insuranceIsSelected
		setRequestPhoneButtonState(isEnabled: checkFormIsFilled())
	}

	@IBAction func insuranceLabelButtonAction(_ sender: Any) {
		guard let url =  URL(string: Constants.insuranceInfoUrlString) else { return }
		router.showWebViewScreen(url: url, htmlString: nil, moveCloseButton: false)
	}

	@IBAction func bankCardButtonAction(_ sender: Any) {
		setSelectedPWay(index: 2)
	}

	@IBAction func bankAccountButtonAction(_ sender: Any) {
		setSelectedPWay(index: 1)
	}

	@IBAction func systemContactButtonAction(_ sender: Any) {
		setSelectedPWay(index: 3)
	}

	@IBAction func cashInOfficeButtonAction(_ sender: Any) {
		setSelectedPWay(index: 0)
	}

	@IBAction func requestButtonAction(_ sender: Any) {
		presenter.trancheRequest(summ: summTextField.text?.replacingOccurrences(of: " ", with: "") ?? "",
								 term: termTextField.text ?? "",
								 lgot: gracePeriodTextField.text ?? "",
								 pWay: String(selectedPWay),
								 addData: prepareAddDataJSON(),
								 is_second: isSecond ? "true" : "false",
								 insurance: insuranceIsSelected ? "1" : "0",
								 email: insuranceEmailView.isHidden == false ?
									insuranceEmailTextField.text : nil,
								 question_id: secretQuestionContainerView.isHidden == false ? String((secretQuestionPicker.selectedValueIndex ?? 0) + 1) : nil,
								 secret_answer: secretAnswerTextField.text)
	}
}

extension TrancheViewController: TrancheViewProtocol {

	func isInsuranceAvailableUpdated(isAvailable: Bool) {
		insuranceContainerView.isHidden = !isAvailable
	}

	func monthlyPaymentUpdated(monthPay: String) {
		monthlyPaymentLabel.isHidden = false
		monthlyPaymentLabel.text = "Ежемесячный платеж: \(monthPay) руб."
	}

	func secretQuestionsUpdated(questions: [SecretQuestion]) {
		secretQuestionPicker.listOfValues = questions.map { $0.text }
	}
}

extension TrancheViewController: UITextFieldDelegate {

	func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {

		if textField == secretAnswerTextField {
			return range.location < 50
		}

		if textField == summTextField || textField == termTextField || textField == gracePeriodTextField {
			textEditTimer?.invalidate()
			textEditTimer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(performMonthlySummRequest), userInfo: nil, repeats: false)
		}

		if ((summTextField.text ?? "").isEmpty)
			|| ((termTextField.text ?? "").isEmpty)
			|| ((gracePeriodTextField.text ?? "").isEmpty) {
			monthlyPaymentLabel.isHidden = true
		}
		setRequestPhoneButtonState(isEnabled: checkFormIsFilled())
		return true
	}

	func textFieldDidEndEditing(_ textField: UITextField) {
		if textField == termTextField {
			if Int(textField.text ?? "") ?? 0 < 24 {
				termTextField.text = "24"
				performMonthlySummRequest()
			}
		}
		if textField == summTextField {
			summTextField.text = summTextField.text?.formattedWithSeparatorAsFloat
		}

		setRequestPhoneButtonState(isEnabled: checkFormIsFilled())
	}
}
