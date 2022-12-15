//
//  SignCustomCell.swift
//  Vzaimno
//
//  Created by Sergii Bilyk on 22.07.2021.
//

import UIKit

class SignCustomCell: UITableViewCell {

	static let cellId = "SignCustomCell"

	//MARK: - IBOutlets

	@IBOutlet weak var customTextlabel: UILabel!
	@IBOutlet weak var customSwitch: UISwitch!

	//MARK: - Properties

	private var switchValueChangedCompletion: ((Bool) -> Void)?

	//MARK: - LifeCycle

	override func awakeFromNib() {
		super.awakeFromNib()

		customSwitch.onTintColor = UIColor.mainBlueColor
	}

	override func prepareForReuse() {
		super.prepareForReuse()

		customTextlabel.text = nil
		customSwitch.isOn = false
		customSwitch.isEnabled = false
	}

	// MARK: - Internal

	func setupWith(item: SigningModel.Block.Custom, switchValueChangedCompletion: ((Bool) -> Void)?) {
		self.switchValueChangedCompletion = switchValueChangedCompletion

		customTextlabel.text = item.text
		customSwitch.isOn = item.value == 1
		customSwitch.isEnabled = item.is_active
	}

	// MARK: - Actions

	@IBAction func customSwitchAction(_ sender: UISwitch) {
		switchValueChangedCompletion?(sender.isOn)
	}
}
