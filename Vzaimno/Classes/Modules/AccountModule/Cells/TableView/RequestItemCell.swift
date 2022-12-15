//
//  RequestItemCell.swift
//  Vzaimno
//
//  Created by Sergii Bilyk on 20.08.2021.
//

import UIKit

class RequestItemCell: UITableViewCell {

	//MARK: - IBOutlets

	@IBOutlet weak var titleLabel: UILabel!
	@IBOutlet weak var statusLabel: UILabel!

	// MARK: - Life Cycle

	override func awakeFromNib() {
		super.awakeFromNib()

	}

	override func prepareForReuse() {
		super.prepareForReuse()

		titleLabel.text = nil
		statusLabel.text = nil
	}

	// MARK: - Internal

	func setupWith(item: AccountData.OrderData) {
		titleLabel.text = "Заявка на ₽" + item.summ.formattedWithSeparatorAsFloat
		statusLabel.text = item.status
		let textColor = UIColor.hexStringToUIColor(hex: item.text_color)
		statusLabel.textColor = textColor
	}
}
