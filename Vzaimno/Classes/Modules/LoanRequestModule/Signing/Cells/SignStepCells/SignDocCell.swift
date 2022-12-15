//
//  SignDocCell.swift
//  Vzaimno
//
//  Created by Sergii Bilyk on 22.07.2021.
//

import UIKit

class SignDocCell: UITableViewCell {

	static let cellId = "SignDocCell"

	//MARK: - IBOutlets

	@IBOutlet weak var docButton: UIButton!
	@IBOutlet weak var docSwitch: UISwitch!

	// MARK: - Properties

	private var switchValueChangedCompletion: ((Bool) -> Void)?
	private var docActionCompletion: ((String) -> Void)?
	private var item: SignDocViewModel!

	// MARK: - Life Cycle

	override func awakeFromNib() {
		super.awakeFromNib()
		docSwitch.onTintColor = UIColor.mainBlueColor
	}

	override func prepareForReuse() {
		super.prepareForReuse()
		docButton.setTitle(nil, for: .normal)
		docSwitch.isOn = false
		docSwitch.isEnabled = false
	}

	// MARK: - Internal

	func setupWith(item: SignDocViewModel,
				   switchValueChangedCompletion: ((Bool) -> Void)?,
				   docActionCompletion: ((String) -> Void)?) {
		self.item = item
		self.switchValueChangedCompletion = switchValueChangedCompletion
		self.docActionCompletion = docActionCompletion
		docSwitch.isOn = item.switchIsOn
		docSwitch.isEnabled = item.switchIsEnabled
		if item.md5 != nil {
			docButton.isEnabled = true
			docButton.setUnderlinedText(item.title, font: UIFont.ekibastuzBold15, color: .black)
		} else {
			docButton.isEnabled = false
			docButton.setLineSpacing()
			docButton.setTitle(item.title, for: .normal)
		}
	}

	// MARK: - Actions

	@IBAction func docButtonAction(_ sender: UIButton) {
		docActionCompletion?(item.md5 ?? "")
	}

	@IBAction func docSwitchAction(_ sender: UISwitch) {
		switchValueChangedCompletion?(sender.isOn)
	}
}
