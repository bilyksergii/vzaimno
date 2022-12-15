//
//  BannerItemCell.swift
//  Vzaimno
//
//  Created by Sergii Bilyk on 20.08.2021.
//

import UIKit
import Kingfisher

class BannerItemCell: UICollectionViewCell {

	//MARK: - IBOutlets

	@IBOutlet weak var bgImage: UIImageView!
	@IBOutlet weak var titleLabel: UILabel!
	@IBOutlet weak var activityIndicator: UIActivityIndicatorView!

	// MARK: - Life Cycle

	override func awakeFromNib() {
		super.awakeFromNib()

	}

	override func prepareForReuse() {
		super.prepareForReuse()

		titleLabel.text = nil
		bgImage.image = nil
	}

	// MARK: - Internal

	func setupWith(item: AccountData.Banner) {
		titleLabel.text = item.title
		titleLabel.setLineSpacing(lineSpacing: 4.0)

		if let smallLink = item.image_small {
			let url = URL(string: Constants.APIConfiguration.host + smallLink)
			activityIndicator.startAnimating()
			bgImage.kf.setImage(with: url) { [weak self] result in
				self?.activityIndicator.stopAnimating()
			}
		}
	}
}


