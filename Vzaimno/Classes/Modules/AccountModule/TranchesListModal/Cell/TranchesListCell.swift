//
//  TranchesListCell.swift
//  Vzaimno
//
//  Created by Sergii Bilyk on 11.09.2021.
//

import UIKit

class TranchesListCell: UITableViewCell {

	//MARK: - IBOutlets

	@IBOutlet weak var titleLabel: UILabel!

	// MARK: - Life Cycle

	override func awakeFromNib() {
		super.awakeFromNib()

	}

	override func prepareForReuse() {
		super.prepareForReuse()
		titleLabel.text = nil
	}

	// MARK: - Internal

	func setupWith(item: AccountData.Loan.Tranche) {
		titleLabel.text = item.number
	}
}
