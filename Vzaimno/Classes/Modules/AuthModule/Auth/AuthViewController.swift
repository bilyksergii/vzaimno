//
//  AuthViewController.swift
//  Vzaimno
//
//  Created by Sergii Bilyk on 26.06.2021.
//

import UIKit
import TVMaskField
import IQKeyboardManagerSwift

protocol AuthViewProtocol: BaseViewProtocol {

}

class AuthViewController: BaseViewController {

	// MARK: - IBOutlets

	@IBOutlet weak var logoImageView: UIImageView!
	@IBOutlet weak var infoLabel: UILabel!
	@IBOutlet weak var phoneInfoLabel: UILabel!
	@IBOutlet weak var phoneMaskTextField: TVMaskTextField!
	@IBOutlet weak var phonePrefixLabel: UILabel!
	@IBOutlet weak var checkMarkImage: UIImageView!
	@IBOutlet weak var checkBoxButton: UIButton!
	@IBOutlet weak var webLinkButton: UIButton!
	@IBOutlet weak var confirmPhoneButton: UIButton!
	@IBOutlet weak var logoTrailingConstraint: NSLayoutConstraint!
	@IBOutlet weak var logoCenterConstraint: NSLayoutConstraint!

	// MARK: - Properties

	private lazy var router: AuthRouterProtocol = AuthRouter(sourceViewController: self)
	private lazy var presenter = AuthPresenter(view: self, router: router)

	private var checkBoxButtonIsSelected = true {
		didSet {
			setConfirmPhoneButtonState()
		}
	}

	private var phoneWasNotFilled = true {
		didSet {
			setConfirmPhoneButtonState()
		}
	}

	// MARK: - LifeCycle

	static func controller() -> AuthViewController {
		let storyboard = UIStoryboard(name: "Auth", bundle: nil)
		let vc = storyboard.instantiateInitialViewController() as! AuthViewController
		return vc
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		phoneMaskTextField.delegate = self
		configureAppearance()
	}

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		IQKeyboardManager.shared.enableAutoToolbar = false
		hideNavBar(true)
	}

	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		phoneMaskTextField.resignFirstResponder()
	}

	// MARK: - Private

	private func configureAppearance() {
		checkBoxButton.isSelected = checkBoxButtonIsSelected
		checkMarkImage.isHidden = true
		phonePrefixLabel.text = "+7"
		infoLabel.text = "Введите номер телефона, мы отправим вам СМС код для подтверждения"
		infoLabel.setLineSpacing()
		phoneInfoLabel.text = "Номер телефона"

		confirmPhoneButton.isEnabled = false
		confirmPhoneButton.backgroundColor = UIColor.lightGray
		confirmPhoneButton.setTitle("Подтвердить телефон", for: .normal)
		confirmPhoneButton.layer.cornerRadius = 8

		webLinkButton.setUnderlinedText("Соглашение на обработку персональных данных", font: UIFont.ekibastuzRegular13, color: .black)
	}

	private func setConfirmPhoneButtonState() {
		let isEnabled = checkBoxButtonIsSelected && !phoneWasNotFilled
		confirmPhoneButton.isEnabled = isEnabled
		confirmPhoneButton.backgroundColor = isEnabled ? UIColor.mainBlueColor : UIColor.lightGray
	}

	private func animateLogoToSmall() {
		UIView.animate(withDuration: 0.5) { [weak self] in
			self?.logoTrailingConstraint.constant = 170
			self?.logoCenterConstraint.constant = 20
		}
	}

	private func animateLogoToBig() {
		UIView.animate(withDuration: 0.5) { [weak self] in
			self?.logoTrailingConstraint.constant = 32
			self?.logoCenterConstraint.constant = -165
		}
	}

	// MARK: - Actions

	@IBAction func checkBoxButtonAction(_ sender: Any) {
		checkBoxButtonIsSelected = !checkBoxButtonIsSelected
		checkBoxButton.isSelected = checkBoxButtonIsSelected
	}

	@IBAction func webLinkButtonAction(_ sender: Any) {
		guard let url =  URL(string: Constants.agreementUrlString) else { return }
		router.showWebViewScreen(url: url, htmlString: nil, moveCloseButton: false)
	}

	@IBAction func confirmPhoneButtonAction(_ sender: Any) {
		phoneMaskTextField.resignFirstResponder()
		let phone = "\(phonePrefixLabel.text ?? "")\(phoneMaskTextField.text ?? "")".onlyNumbers
		presenter.getSmsPass(phone: phone)
	}
}

extension AuthViewController: AuthViewProtocol {}

extension AuthViewController: UITextFieldDelegate {

	func textFieldDidBeginEditing(_ textField: UITextField) {
		animateLogoToSmall()
	}

	func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
		animateLogoToBig()
	}

	func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {

		guard let newText = (textField.text as NSString?)?.replacingCharacters(in: range, with: string).onlyNumbers else { return false }
		if newText.count <= 9 {
			phoneWasNotFilled = true
			checkMarkImage.isHidden = phoneWasNotFilled
			return true
		} else {
			phoneWasNotFilled = false
			checkMarkImage.isHidden = phoneWasNotFilled
			return false
		}
	}
}
