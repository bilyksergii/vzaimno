//
//  SideMenuCell.swift
//  Vzaimno
//
//  Created by Sergii Bilyk on 10.09.2021.
//

import UIKit

class SideMenuCell: UITableViewCell {

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

	func setupWith(item: SideMenuViewModel) {
		titleLabel.text = item.title
	}
}
