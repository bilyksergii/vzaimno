//
//  TextInputCell.swift
//  Vzaimno
//
//  Created by Sergii Bilyk on 28.09.2021.
//

import UIKit

class TextInputCell: UITableViewCell {

	//MARK: - IBOutlets

	@IBOutlet weak var checkboxButton: UIButton!
	@IBOutlet weak var titleLabel: UILabel!
	@IBOutlet weak var inputTextField: UITextField!
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
		inputTextField.delegate = self
	}

	override func prepareForReuse() {
		super.prepareForReuse()
		titleLabel.text = nil
		inputTextField.text = nil
		checkboxButton.isSelected = false
		checkboxButton.isUserInteractionEnabled = true
	}

	// MARK: - Internal

	func setupWith(item: InputViewModel, expandActionCompletion: (() -> Void)?, textChangedCompletion: (() -> Void)?) {
		self.item = item
		self.expandActionCompletion = expandActionCompletion
		self.textChangedCompletion = textChangedCompletion
		titleLabel.text = item.title
		inputTextField.placeholder = item.placeholder
		checkboxButtonIsSelected = item.isExpanded
		checkboxButton.isSelected = item.isExpanded
		inputTextField.isHidden = !item.isExpanded
		inputSeparatorView.isHidden = !item.isExpanded
		if item.required == "1" {
			changeButtonState(isSelected: true)
			checkboxButton.isUserInteractionEnabled = false
		}
	}

	//MARK: - Private

	private func changeButtonState(isSelected: Bool) {
		checkboxButton.isSelected = isSelected
		inputTextField.isHidden = !isSelected
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

extension TextInputCell: UITextFieldDelegate {

	func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
		let textFieldText: NSString = (textField.text ?? "") as NSString
		item.input_text = textFieldText.replacingCharacters(in: range, with: string)
		textChangedCompletion?()
		return true
	}
}
