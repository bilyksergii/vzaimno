//
//  PhotoUploadedViewController.swift
//  Vzaimno
//
//  Created by Sergii Bilyk on 19.07.2021.
//

import UIKit

class PhotoUploadedViewController: UIViewController {

	// MARK: - IBOutlets

	@IBOutlet weak var infoLabel: UILabel!
	@IBOutlet weak var closeButton: UIButton!

	// MARK: - Properties

	private var infoText: String?

	// MARK: - LifeCycle

	static func controller(infoText: String) -> PhotoUploadedViewController {
		let storyboard = UIStoryboard(name: "PhotoUploaded", bundle: nil)
		let vc = storyboard.instantiateInitialViewController() as! PhotoUploadedViewController
		vc.infoText = infoText
		return vc
	}

	override func viewDidLoad() {
		super.viewDidLoad()

		configureAppearance()
	}

	// MARK: - Private

	private func configureAppearance() {
		view.backgroundColor = UIColor(white: 0.1, alpha: 0.5)
		infoLabel.text = infoText
		closeButton.setTitle("Продолжить", for: .normal)
		closeButton.layer.cornerRadius = 8
	}

	// MARK: - IBActions

	@IBAction func closeButtonAction(_ sender: Any) {
		dismiss(animated: true, completion: nil)
	}
}
