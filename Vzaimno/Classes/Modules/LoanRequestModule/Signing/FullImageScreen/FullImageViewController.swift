//
//  FullImageViewController.swift
//  Vzaimno
//
//  Created by Sergii Bilyk on 22.07.2021.
//

import UIKit

class FullImageViewController: BaseViewController {

	//MARK: - IBOutlets

	@IBOutlet weak var photoImageView: UIImageView!

	//MARK: - Properties

	private var imageLink: String?

	// MARK: - lifeCycle

	static func controller(imageLink: String) -> FullImageViewController {
		let storyboard = UIStoryboard(name: "FullImage", bundle: nil)
		let vc = storyboard.instantiateInitialViewController() as! FullImageViewController
		vc.imageLink = imageLink
		return vc
	}

	override func viewDidLoad() {
		super.viewDidLoad()

		view.backgroundColor = UIColor(white: 0.1, alpha: 0.5)

		if let imageLink = imageLink {
			let url = URL(string: Constants.APIConfiguration.host + imageLink)
			showLoader()
			photoImageView.kf.setImage(with: url) { [weak self] result in
				self?.hideLoader()
			}
		}
	}

	// MARK: - IBActions

	@IBAction func closeButtonAction(_ sender: Any) {
		dismiss(animated: true, completion: nil)
	}
}
