//
//  PaymentResultViewController.swift
//  Vzaimno
//
//  Created by Sergii Bilyk on 06.10.2021.
//

import UIKit

class PaymentResultViewController: UIViewController {

	// MARK: - IBOutlets

	@IBOutlet weak var infoLabel: UILabel!
	@IBOutlet weak var closeButton: UIButton!

	// MARK: - Properties

	private var paymentResult: PaymentResult!

	// MARK: - LifeCycle

	static func controller(paymentResult: PaymentResult) -> PaymentResultViewController {
		let storyboard = UIStoryboard(name: "PaymentResult", bundle: nil)
		let vc = storyboard.instantiateInitialViewController() as! PaymentResultViewController
		vc.paymentResult = paymentResult
		return vc
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		configureAppearance()
	}

	// MARK: - Private

	private func configureAppearance() {
		view.backgroundColor = UIColor(white: 0.1, alpha: 0.5)
		closeButton.setTitle("Продолжить", for: .normal)
		closeButton.layer.cornerRadius = 8

		switch paymentResult {
		case .success:
			infoLabel.text = """
							Спасибо!

							Ваш платёж принят!

							Данные по займу обновятся
							в ближайшее время.
							"""
		case .error:
			infoLabel.text = """
							Уважаемый клиент!

							К сожалению произошла ошибка,
							повторите пожалуйста процесс оплаты.

							Спасибо!
							"""
		default:
			return
		}
	}

	// MARK: - IBActions

	@IBAction func closeButtonAction(_ sender: Any) {
		dismiss(animated: true)
	}
}
