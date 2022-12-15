//
//  TextFieldWithPicker.swift
//  Vzaimno
//
//  Created by Sergii Bilyk on 03.09.2021.
//

import UIKit

class TextFieldWithPicker: UITextField, UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate {

	// MARK: - Properties

	var listOfValues: [String]? {
		didSet {
			guard let listOfValues = listOfValues else {
				inputView = nil
				inputAccessoryView = nil
				return
			}
			setupPicker()
			tintColor = UIColor.clear
			autocorrectionType = .no
			spellCheckingType = .no

			pickerView.reloadAllComponents()
			if let text = text, let index = listOfValues.firstIndex(of: text) {
				pickerView.selectRow(index, inComponent: 0, animated: false)
			} else {
				text = listOfValues.first
				pickerView.selectRow(0, inComponent: 0, animated: false)
			}
		}
	}

	var dropDownIcon: UIImage? {
		didSet {
			guard let icon = dropDownIcon?.withRenderingMode(.alwaysTemplate) else { return }
			let iconImageView = UIImageView(image: icon)

			let iconImageWidth = iconImageView.frame.width > 10 ? 10 : iconImageView.frame.width
			let iconImageHeight = iconImageView.frame.height > 10 ? 10 : iconImageView.frame.height
			iconImageView.frame = CGRect(x: 0,
										 y: 0,
										 width: iconImageWidth + 10, // Added 10 for indention between text and icon
										 height: iconImageHeight)
			iconImageView.contentMode = .scaleAspectFit
			iconImageView.tintColor = .darkGray
			rightView = iconImageView
			rightViewMode = .always
		}
	}

	var selectedValueIndex: Int? {
		return listOfValues != nil ? pickerView.selectedRow(inComponent: 0) : nil
	}

	override public var text: String? {
		didSet {
			guard let listOfValues = listOfValues else { return }
			if let text = text, let index = listOfValues.firstIndex(of: text) {
				pickerView.selectRow(index, inComponent: 0, animated: false)
			} else if let selectedValueIndex = selectedValueIndex {
				super.text = listOfValues[selectedValueIndex]
				pickerView.selectRow(selectedValueIndex, inComponent: 0, animated: false)
			}
		}
	}

	private var pickerView = UIPickerView()

	private weak var _delegate: UITextFieldDelegate?

	override var delegate: UITextFieldDelegate? {
		get { return _delegate }
		set { _delegate = newValue }
	}

	// MARK: - Life cycle

	override func awakeFromNib() {
		super.awakeFromNib()
		super.delegate = self
	}

	// MARK: - Private

	private func setupPicker() {
		pickerView.delegate = self
		pickerView.backgroundColor = UIColor.white

		let toolBar = UIToolbar()
		toolBar.clipsToBounds = true
		toolBar.barTintColor = UIColor.mainBlueColor
		toolBar.tintColor = UIColor.white
		toolBar.isTranslucent = false


		toolBar.sizeToFit()

		let doneButton = UIBarButtonItem(title: "Готово",
										 style: .plain,
										 target: self,
										 action: #selector(acceptPicker))
		let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace,
										  target: nil,
										  action: nil)
		let cancelButton = UIBarButtonItem(title: "Отменить",
										   style: .plain,
										   target: self,
										   action: #selector(discardPicker))
		if #available(iOS 11.0, *) {
			doneButton.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white], for: .normal)
			cancelButton.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white], for: .normal)
		}

		toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
		toolBar.isUserInteractionEnabled = true

		textColor = UIColor.mainBlueColor
		font = UIFont.ekibastuzRegular17

		inputView = pickerView
		inputAccessoryView = toolBar
		tintColor = .clear
	}

	@objc private func acceptPicker() {
		if let selectedValueIndex = selectedValueIndex, let selectedItem = listOfValues?[selectedValueIndex] {
			text = selectedItem
		}
		resignFirstResponder()
		sendActions(for: .valueChanged)
	}

	@objc private func discardPicker() {
		if let text = text, let previosValueIndex = listOfValues?.firstIndex(of: text) {
			pickerView.selectRow(previosValueIndex, inComponent: 0, animated: false)
		}
		resignFirstResponder()
	}

	// MARK: - Overrides

	// Disabled edit actions if needed
	override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
		if listOfValues != nil {
			if action == #selector(UIResponderStandardEditActions.paste(_:)) {
				return false
			}
			if action == #selector(UIResponderStandardEditActions.select(_:)) {
				return false
			}
			if action == #selector(UIResponderStandardEditActions.selectAll(_:)) {
				return false
			}
		}
		return super.canPerformAction(action, withSender: sender)
	}

	// MARK: - UIPickerViewDataSource

	public func numberOfComponents(in pickerView: UIPickerView) -> Int {
		return 1
	}

	public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
		return listOfValues?.count ?? 0
	}

	public func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
		return listOfValues?[row] ?? nil
	}

	// MARK: - UITextFieldDelegate

	public func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
		if listOfValues != nil {
			isUserInteractionEnabled = false
		}
		return delegate?.textFieldShouldBeginEditing?(textField) ?? true
	}

	public func textFieldDidBeginEditing(_ textField: UITextField) {
		delegate?.textFieldDidBeginEditing?(textField)
	}

	public func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
		if listOfValues != nil {
			isUserInteractionEnabled = true
		}
		return delegate?.textFieldShouldEndEditing?(textField) ?? true
	}

	public func textFieldDidEndEditing(_ textField: UITextField) {
		delegate?.textFieldDidEndEditing?(textField)
	}

	@available(iOS 10.0, *)
	public func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
		delegate?.textFieldDidEndEditing?(textField, reason: reason)
	}

	public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
		return delegate?.textField?(textField, shouldChangeCharactersIn: range, replacementString: string) ?? false
	}

	public func textFieldShouldClear(_ textField: UITextField) -> Bool {
		return delegate?.textFieldShouldClear?(textField) ?? false
	}

	public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		return delegate?.textFieldShouldReturn?(textField) ?? false
	}
}
