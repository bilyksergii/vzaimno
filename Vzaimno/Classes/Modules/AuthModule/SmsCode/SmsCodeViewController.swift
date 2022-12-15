//
//  SmsCodeViewController.swift
//  Vzaimno
//
//  Created by Sergii Bilyk on 30.06.2021.
//

import UIKit
import TVMaskField
import IQKeyboardManagerSwift

protocol SmsCodeViewProtocol: BaseViewProtocol {
	func wrongCodeMessageIsHidden(_ isHidden: Bool)
}

class SmsCodeViewController: BaseViewController {

	// MARK: - IBOutlets

	@IBOutlet weak var titleLabel: UILabel!
	@IBOutlet weak var timerLabel: UILabel!
	@IBOutlet weak var codeTextField: TVMaskTextField!
	@IBOutlet weak var wrongCodeLabel: UILabel!
	@IBOutlet weak var infoLabel: UILabel!
	@IBOutlet weak var requestSMSButton: UIButton!

	// MARK: - Properties

	private lazy var router: SmsCodeRouterProtocol = SmsCodeRouter(sourceViewController: self)
	private lazy var presenter = SmsCodePresenter(view: self, router: router)

	private var phone: String!
	private var countDownTimer: Timer!
	private let maxTimerCounter = 60
	private var timerCounter = 60

	// MARK: - LifeCycle

	static func controller(phone: String) -> SmsCodeViewController {
		let storyboard = UIStoryboard(name: "SmsCode", bundle: nil)
		let vc = storyboard.instantiateInitialViewController() as! SmsCodeViewController
		vc.phone = phone
		return vc
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		configureAppearance()
		startCountDownTimer()
	}

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		hideNavBar(false)
	}

	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		IQKeyboardManager.shared.enableAutoToolbar = true
	}

	// MARK: - Private

	private func configureAppearance() {
		addRightNavigationButton()
		navigationItem.title = "Подтверждение телефона"

		codeTextField.delegate = self
		codeTextField.becomeFirstResponder()
		titleLabel.text = "Введите полученный код из СМС."
		wrongCodeLabel.text = "Вы ввели не верный СМС код"
		wrongCodeLabel.isHidden = true
		infoLabel.text = "Код является Вашим согласием на обработку персональных данных."

		requestSMSButton.setUnderlinedText("Запросить СМС повторно",
										   font: UIFont.ekibastuzBold15,
										   color: .mainBlueColor)
		requestSMSButton.isHidden = true
	}

	private func startCountDownTimer() {
		timerCounter = maxTimerCounter
		timerLabel.text = setTimerLabel(seconds: timerCounter)
		countDownTimer = Timer.scheduledTimer(timeInterval: 1,
											  target: self,
											  selector: #selector(self.changeTimerTitle),
											  userInfo: nil,
											  repeats: true)
	}

	private func setTimerLabel(seconds: Int) -> String {
		let dateFormat = DateFormat()
		return dateFormat.getStringTimeFromSeconds(time: dateFormat.secondsToMinutesSeconds(seconds: seconds))
	}

	@objc private func changeTimerTitle() {
		if timerCounter != 0 {
			timerCounter -= 1
			timerLabel.text = setTimerLabel(seconds: timerCounter)
		} else {
			countDownTimer.invalidate()
			requestSMSButton.isHidden = false
		}
	}

	// MARK: - IBActions

	@IBAction func requestSMSAction(_ sender: Any) {
		startCountDownTimer()
		requestSMSButton.isHidden = true
		codeTextField.text = ""
		presenter.getSmsPass(phone: phone)
	}

}

extension SmsCodeViewController: SmsCodeViewProtocol {

	func wrongCodeMessageIsHidden(_ isHidden: Bool) {
		wrongCodeLabel.isHidden = isHidden
	}
}

extension SmsCodeViewController: UITextFieldDelegate {

	func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
		let newText = (((textField.text ?? "").onlyNumbers) + string)
		if newText.count == 5 && !string.isEmpty {
			presenter.loginWith(phone: phone, code: newText)
		}
		return true
	}
}
