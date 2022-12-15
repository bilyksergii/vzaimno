//
//  PaymentsHistoryCell.swift
//  Vzaimno
//
//  Created by Sergii Bilyk on 15.09.2021.
//

import UIKit

class PaymentsHistoryCell: UITableViewCell {

	//MARK: - IBOutlets

	@IBOutlet weak var dateLabel: UILabel!
	@IBOutlet weak var summLabel: UILabel!
	@IBOutlet weak var teloLabel: UILabel!
	@IBOutlet weak var procLabel: UILabel!

	// MARK: - Life Cycle

	override func awakeFromNib() {
		super.awakeFromNib()

	}

	override func prepareForReuse() {
		super.prepareForReuse()
		dateLabel.text = nil
		summLabel.text = nil
		teloLabel.text = nil
		procLabel.text = nil
	}

	// MARK: - Internal

	func setupWith(item: TrancheDetails.Loan.History) {
		dateLabel.text = item.date?.dateStringToDDMMYYYYString()
		summLabel.text = item.summ?.formattedWithSeparatorAsFloat
		teloLabel.text = item.telo?.formattedWithSeparatorAsFloat
		procLabel.text = item.proc?.formattedWithSeparatorAsFloat
	}
}
