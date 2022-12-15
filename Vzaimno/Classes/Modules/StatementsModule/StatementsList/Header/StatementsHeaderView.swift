//
//  StatementsHeaderView.swift
//  Vzaimno
//
//  Created by Sergii Bilyk on 22.09.2021.
//

import UIKit

class StatementsHeaderView: UITableViewHeaderFooterView {

	//MARK: - IBOutlets

	@IBOutlet weak var titleLabel: UILabel!

	// MARK: - Life Cycle

	override func awakeFromNib() {
		super.awakeFromNib()
		contentView.backgroundColor = .white
		titleLabel.text = "Ваши заявления"
	}
}
