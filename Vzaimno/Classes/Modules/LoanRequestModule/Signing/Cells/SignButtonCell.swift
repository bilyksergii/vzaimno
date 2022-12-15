//
//  SignButtonCell.swift
//  Vzaimno
//
//  Created by Sergii Bilyk on 21.07.2021.
//

import UIKit

class SignButtonCell: UITableViewCell {

	static let cellId = "SignButtonCell"

	//MARK: - IBOutlets

	@IBOutlet weak var separatorView: UIView!
	@IBOutlet weak var actionButton: UIButton!

	//MARK: - Properties

	var item: SigningModel.Block!
	var completion: ((ButtonAction?) -> Void)?

	//MARK: - Life Cycle

	override func awakeFromNib() {
		super.awakeFromNib()

		actionButton.layer.cornerRadius = 8
	}

	override func prepareForReuse() {
		super.prepareForReuse()
		
		actionButton.setTitle(nil, for: .normal)
	}

	// MARK: - Internal

	func setupWith(item: SigningModel.Block, completion: @escaping ((ButtonAction?) -> Void)) {
		self.completion = completion
		self.item = item
		actionButton.setTitle(item.button_text, for: .normal)
	}

	@IBAction func actionButtonAction(_ sender: Any) {
		completion?(item?.action)
	}
}
