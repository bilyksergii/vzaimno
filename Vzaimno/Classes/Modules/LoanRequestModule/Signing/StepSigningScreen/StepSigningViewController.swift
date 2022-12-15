//
//  StepSigningViewController.swift
//  Vzaimno
//
//  Created by Sergii Bilyk on 13.08.2021.
//

import UIKit
import TVMaskField

protocol StepSigningViewProtocol: BaseViewProtocol {
	func showResultMessage(text: String, isError: Bool)
	func showWrongCode(text: String)
}

class StepSigningViewController: BaseViewController {

	// MARK: - IBOutlets

	@IBOutlet weak var infoLabel: UILabel!
	@IBOutlet weak var timerLabel: UILabel!
	@IBOutlet weak var codeTextField: TVMaskTextField!
	@IBOutlet weak var smsCodeContainerView: UIView!
	@IBOutlet weak var signButton: UIButton!

	// MARK: - Properties

	private lazy var router: StepSigningRouterProtocol = StepSigningRouter(sourceViewController: self)
	private lazy var presenter = StepSigningPresenter(view: self, router: router)

	private var completion: (() -> Void)?
	private var infoText: String?
	private var id_form: String?
	private var step: String?

	private var countDownTimer: Timer!
	private let maxTimerCounter = 300
	private var timerCounter = 300

	private let signButtonTitle = "Подписать"
	private let signButtonResultTitle = "Продолжить"


	// MARK: - LifeCycle

	static func controller(infoText: String, id_form: String, step: String, completion: (() -> Void)?) -> StepSigningViewController {
		let storyboard = UIStoryboard(name: "StepSigning", bundle: nil)
		let vc = storyboard.instantiateInitialViewController() as! StepSigningViewController
		vc.infoText = infoText
		vc.id_form = id_form
		vc.step = step
		vc.completion = completion
		return vc
	}

	override func viewDidLoad() {
		super.viewDidLoad()

		configureAppearance()
		codeTextField.delegate = self
		startCountDownTimer()
	}

	// MARK: - Private

	private func configureAppearance() {
		view.backgroundColor = UIColor(white: 0.1, alpha: 0.5)

		signButton.isEnabled = false
		signButton.backgroundColor = UIColor.lightGray
		infoLabel.text = infoText
		signButton.setTitle(signButtonTitle, for: .normal)
		signButton.layer.cornerRadius = 8
	}

	private func setSignButtonState(isEnabled: Bool) {
		signButton.isEnabled = isEnabled
		signButton.backgroundColor = isEnabled ? UIColor.mainBlueColor : UIColor.lightGray
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
			dismissSelf()
		}
	}

	private func dismissSelf() {
		dismiss(animated: true) { [weak self] in
			self?.completion?()
		}
	}

	// MARK: - IBActions

	@IBAction func signButtonAction(_ sender: UIButton) {
		switch sender.titleLabel?.text {
		case signButtonTitle:
			presenter.stepSign(step: step ?? "", id_form: id_form ?? "", smsCode: codeTextField.text?.onlyNumbers ?? "")
		case signButtonResultTitle:
			dismissSelf()
		default:
			return
		}

	}
}

extension StepSigningViewController: UITextFieldDelegate {

	func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
		let newText = (((textField.text ?? "").onlyNumbers) + string)
		if newText.count > 4 {
			return false
		}
		setSignButtonState(isEnabled: newText.count == 4 && !string.isEmpty)
		return true
	}
}

extension StepSigningViewController: StepSigningViewProtocol {

	func showResultMessage(text: String, isError: Bool) {
		timerLabel.isHidden = true
		countDownTimer.invalidate()
		smsCodeContainerView.isHidden = true
		infoLabel.text = text
		signButton.setTitle(signButtonResultTitle, for: .normal)
		if isError {
			infoLabel.textColor = UIColor.redToastColor
		}
	}

	func showWrongCode(text: String) {
		infoLabel.text = text
		codeTextField.text = ""
		setSignButtonState(isEnabled: false)
	}
}
