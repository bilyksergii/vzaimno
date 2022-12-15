//
//  StatementsFileCell.swift
//  Vzaimno
//
//  Created by Sergii Bilyk on 24.09.2021.
//

import UIKit

class StatementsFileCell: UITableViewCell {

	//MARK: - IBOutlets

	@IBOutlet weak var fileNameLabel: UILabel!

	// MARK: - Life Cycle

	override func awakeFromNib() {
		super.awakeFromNib()
	}

	override func prepareForReuse() {
		super.prepareForReuse()
		fileNameLabel.text = ""
	}

	// MARK: - Internal

	func setupWith(item: Statement.File) {
		fileNameLabel.text = item.name_user
		fileNameLabel.setUnderlinedText(item.name_user ?? "", font: UIFont.ekibastuzBold15, color: UIColor.mainBlueColor)
	}
}
