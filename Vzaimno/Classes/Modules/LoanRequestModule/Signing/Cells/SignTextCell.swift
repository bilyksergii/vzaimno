//
//  SignTextCell.swift
//  Vzaimno
//
//  Created by Sergii Bilyk on 21.07.2021.
//

import UIKit

class SignTextCell: UITableViewCell {

	static let cellId = "SignTextCell"

	//MARK: - IBOutlets

	@IBOutlet weak var separatorView: UIView!
	@IBOutlet weak var infoTextLabel: UILabel!

	// MARK: - Internal

	override func prepareForReuse() {
		super.prepareForReuse()

		infoTextLabel.text = nil
	}

	func setupWith(item: SigningModel.Block) {
		infoTextLabel.text = item.text
		infoTextLabel.setLineSpacing()
	}
}
