//
//  NewStatementFileCell.swift
//  Vzaimno
//
//  Created by Sergii Bilyk on 04.10.2021.
//

import UIKit

class NewStatementFileCell: UITableViewCell {

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

	func setupWith(item: StatementFileViewModel) {
		fileNameLabel.text = item.fname_user
		fileNameLabel.setUnderlinedText(item.fname_user, font: UIFont.ekibastuzBold15, color: UIColor.mainBlueColor)
	}
}
