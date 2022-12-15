//
//  PhotoItemCell.swift
//  Vzaimno
//
//  Created by Sergii Bilyk on 14.07.2021.
//

import UIKit
import Kingfisher

class PhotoItemCell: UICollectionViewCell {

	enum Mode {
		case normal
		case required
	}

	//MARK: - IBOutlets

	@IBOutlet weak var frameView: UIView!
	@IBOutlet weak var titleLabel: UILabel!
	@IBOutlet weak var placeholderImage: UIImageView!
	@IBOutlet weak var photoImage: UIImageView!
	@IBOutlet weak var activityIndicator: UIActivityIndicatorView!

	// MARK: - Properties

	private var item: Photo!

	// MARK: - Life Cycle

	override func awakeFromNib() {
		super.awakeFromNib()

		frameView.layer.borderWidth = 1
		frameView.layer.cornerRadius = 8
		placeholderImage.isHidden = true
	}

	override func prepareForReuse() {
		super.prepareForReuse()

		placeholderImage.isHidden = true
		placeholderImage.image = nil
		photoImage.image = nil
	}

	// MARK: - Internal

	func setupWith(item: Photo, mode: Mode) {
		self.item = item
		titleLabel.text = item.title

		setMode(mode: mode)

		if let photoLink = item.file_path {
			let url = URL(string: Constants.APIConfiguration.host + photoLink)
			activityIndicator.startAnimating()
			photoImage.kf.setImage(with: url) { [weak self] result in
				self?.activityIndicator.stopAnimating()
			}
		} else {
			setPlaceholderImage()
		}
	}

	// MARK: - Private

	private func setPlaceholderImage() {
		placeholderImage.isHidden = false
		placeholderImage.tintColor = .lightGray
		switch item.id {
		case 9:
			placeholderImage.image = #imageLiteral(resourceName: "avtoFront")
		case 10: placeholderImage.image = #imageLiteral(resourceName: "avtoLeftSide")
			placeholderImage.tintColor = .lightGrayColor
		case 11:
			placeholderImage.image = #imageLiteral(resourceName: "avtoRightSide")
			placeholderImage.tintColor = .lightGrayColor
		case 12:
			placeholderImage.image = #imageLiteral(resourceName: "avtoBack")
		case 13, 14, 15, 16, 17:
			placeholderImage.image = #imageLiteral(resourceName: "avtoSteeringWheel")
			placeholderImage.tintColor = .darkGrayColor
		default: placeholderImage.image = #imageLiteral(resourceName: "photoPlaceholder")
		}
	}

	private func setMode(mode: Mode) {
		if item.required == true && item.file_path == nil && mode == .required {
			frameView.layer.borderColor = UIColor.red.cgColor
			titleLabel.textColor = .red
		} else {
			frameView.layer.borderColor = UIColor.lightGray.cgColor
			titleLabel.textColor = .black
		}
	}
}
