//
//  StatementsCell.swift
//  Vzaimno
//
//  Created by Sergii Bilyk on 22.09.2021.
//

import UIKit

class StatementsCell: UITableViewCell {

	//MARK: - IBOutlets

	@IBOutlet weak var numberLabel: UILabel!
	@IBOutlet weak var dateLabel: UILabel!
	@IBOutlet weak var answerDateLabel: UILabel!
	@IBOutlet weak var statusLabel: UILabel!

	// MARK: - Life Cycle

	override func awakeFromNib() {
		super.awakeFromNib()
	}

	override func prepareForReuse() {
		super.prepareForReuse()
		numberLabel.text = nil
		dateLabel.text = nil
		answerDateLabel.text = nil
		statusLabel.text = nil
	}

	// MARK: - Internal

	func setupWith(item: Statement) {
		numberLabel.text = "№" + (item.number ?? "")
		dateLabel.text = item.date
		answerDateLabel.text = item.answer_date
		statusLabel.text = item.status
	}
}
