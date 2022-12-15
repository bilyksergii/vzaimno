//
//  DateInputCell.swift
//  Vzaimno
//
//  Created by Sergii Bilyk on 28.09.2021.
//

import UIKit
import TVMaskField

class DateInputCell: UITableViewCell {

	//MARK: - IBOutlets

	@IBOutlet weak var checkboxButton: UIButton!
	@IBOutlet weak var titleLabel: UILabel!
	@IBOutlet weak var inputDateTextField: TVMaskTextField!
	@IBOutlet weak var inputSeparatorView: UIView!

	// MARK: - Properties

	private var expandActionCompletion: (() -> Void)?
	private var textChangedCompletion: (() -> Void)?
	private var checkboxButtonIsSelected = false
	private var item: InputViewModel!

	// MARK: - Life Cycle

	override func awakeFromNib() {
		super.awakeFromNib()
		titleLabel.setLineSpacing(lineSpacing: 3.0)
		inputDateTextField.delegate = self
	}

	override func prepareForReuse() {
		super.prepareForReuse()
		titleLabel.text = nil
		inputDateTextField.text = nil
		checkboxButton.isSelected = false
		checkboxButton.isUserInteractionEnabled = true
	}

	// MARK: - Internal

	func setupWith(item: InputViewModel, expandActionCompletion: (() -> Void)?, textChangedCompletion: (() -> Void)?) {
		self.item = item
		self.expandActionCompletion = expandActionCompletion
		self.textChangedCompletion = textChangedCompletion
		titleLabel.text = item.title
		checkboxButtonIsSelected = item.isExpanded
		checkboxButton.isSelected = item.isExpanded
		inputDateTextField.isHidden = !item.isExpanded
		inputSeparatorView.isHidden = !item.isExpanded
		if item.required == "1" {
			changeButtonState(isSelected: true)
			checkboxButton.isUserInteractionEnabled = false
		}
	}

	//MARK: - Private

	private func changeButtonState(isSelected: Bool) {
		checkboxButton.isSelected = isSelected
		inputDateTextField.isHidden = !isSelected
		inputSeparatorView.isHidden = !isSelected
		item.isExpanded = isSelected
		expandActionCompletion?()
	}

	//MARK: - IBActions

	@IBAction func checkboxButtonAction(_ sender: Any) {
		checkboxButtonIsSelected = !checkboxButtonIsSelected
		changeButtonState(isSelected: checkboxButtonIsSelected)
	}
}

extension DateInputCell: UITextFieldDelegate {

	func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
		let textFieldText: NSString = (textField.text ?? "") as NSString
		item.input_text = textFieldText.replacingCharacters(in: range, with: string)
		textChangedCompletion?()
		return true
	}
}
