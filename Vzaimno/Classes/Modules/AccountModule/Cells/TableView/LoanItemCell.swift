//
//  LoanItemCell.swift
//  Vzaimno
//
//  Created by Sergii Bilyk on 20.08.2021.
//

import UIKit

class LoanItemCell: UITableViewCell {

	//MARK: - IBOutlets

	@IBOutlet weak var titleLabel: UILabel!
	@IBOutlet weak var summLabel: UILabel!
	@IBOutlet weak var statusLabel: UILabel!

	// MARK: - Life Cycle

	override func awakeFromNib() {
		super.awakeFromNib()
	}

	override func prepareForReuse() {
		super.prepareForReuse()
		titleLabel.text = nil
		summLabel.text = nil
		statusLabel.text = nil
	}

	// MARK: - Internal

	func setupWith(item: AccountData.Loan) {
		titleLabel.text = item.title_number
		summLabel.text = "₽\(item.summ.formattedWithSeparator)"
		statusLabel.text = item.is_opened ? "Открыт" : "Закрыт"
		statusLabel.textColor = item.is_opened ? UIColor.mainBlueColor : .darkGray
	}
}
