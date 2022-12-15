//
//  SignPhotoCell.swift
//  Vzaimno
//
//  Created by Sergii Bilyk on 22.07.2021.
//

import UIKit
import Kingfisher

class SignPhotoCell: UICollectionViewCell {

	static let cellId = "SignPhotoCell"

	//MARK: - IBOutlets

	@IBOutlet weak var frameView: UIView!
	@IBOutlet weak var titleLabel: UILabel!
	@IBOutlet weak var photoImage: UIImageView!
	@IBOutlet weak var activityIndicator: UIActivityIndicatorView!

	// MARK: - Properties


	// MARK: - Life Cycle

	override func awakeFromNib() {
		super.awakeFromNib()

		frameView.layer.borderWidth = 1
		frameView.layer.cornerRadius = 8
		frameView.layer.borderColor = UIColor.lightGray.cgColor
	}

	override func prepareForReuse() {
		super.prepareForReuse()

		photoImage.image = nil
	}

	// MARK: - Internal

	func setupWith(item: SigningModel.Block.Photo) {
		titleLabel.text = item.title_android

		let url = URL(string: Constants.APIConfiguration.host + item.full_path)
		activityIndicator.startAnimating()
		photoImage.kf.setImage(with: url) { [weak self] result in
			self?.activityIndicator.stopAnimating()
		}
	}
}
