//
//  TrancheRequestApprovedViewController.swift
//  Vzaimno
//
//  Created by Sergii Bilyk on 05.09.2021.
//

import UIKit

class TrancheRequestApprovedViewController: UIViewController {

	// MARK: - IBOutlets

	@IBOutlet weak var infoLabel: UILabel!
	@IBOutlet weak var closeButton: UIButton!

	// MARK: - Properties

	private var completion: (() -> Void)?

	// MARK: - LifeCycle

	static func controller(completion: (() -> Void)?) -> TrancheRequestApprovedViewController {
		let storyboard = UIStoryboard(name: "TrancheRequestApproved", bundle: nil)
		let vc = storyboard.instantiateInitialViewController() as! TrancheRequestApprovedViewController
		vc.completion = completion
		return vc
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		configureAppearance()
	}

	// MARK: - Private

	private func configureAppearance() {
		view.backgroundColor = UIColor(white: 0.1, alpha: 0.5)
		infoLabel.text = "Заявка подтверждена! Мы скоро свяжемся с Вами."
		closeButton.setTitle("Продолжить", for: .normal)
		closeButton.layer.cornerRadius = 8
	}

	// MARK: - IBActions

	@IBAction func closeButtonAction(_ sender: Any) {
		dismiss(animated: true) { [weak self] in
			self?.completion?()
		}
	}
}
