//
//  TextViewInputCell.swift
//  Vzaimno
//
//  Created by Sergii Bilyk on 28.09.2021.
//

import UIKit

class TextViewInputCell: UITableViewCell {

	//MARK: - IBOutlets

	@IBOutlet weak var checkboxButton: UIButton!
	@IBOutlet weak var titleLabel: UILabel!
	@IBOutlet weak var inputTextView: UITextView!
	@IBOutlet weak var inputSeparatorView: UIView!
	@IBOutlet weak var inputTextViewHeightConstraint: NSLayoutConstraint!

	// MARK: - Properties

	private var expandActionCompletion: (() -> Void)?
	private var textChangedCompletion: (() -> Void)?
	private var checkboxButtonIsSelected = false
	private var item: InputViewModel!

	// MARK: - Life Cycle

	override func awakeFromNib() {
		super.awakeFromNib()
		titleLabel.setLineSpacing(lineSpacing: 3.0)
		inputTextView.delegate = self
	}

	override func prepareForReuse() {
		super.prepareForReuse()
		inputTextView.text = nil
		titleLabel.text = nil
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
		inputTextView.isHidden = !item.isExpanded
		inputSeparatorView.isHidden = !item.isExpanded
		if item.required == "1" {
			changeButtonState(isSelected: true)
			checkboxButton.isUserInteractionEnabled = false
		}
	}

	//MARK: - Private

	private func changeButtonState(isSelected: Bool) {
		checkboxButton.isSelected = isSelected
		inputTextView.isHidden = !isSelected
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

extension TextViewInputCell: UITextViewDelegate {

	func textViewDidChange(_ textView: UITextView) {
		textView.setLineSpacing()
		let fixedWidth = textView.frame.size.width
		textView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
		let newSize = textView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
		var newFrame = textView.frame
		newFrame.size = CGSize(width: max(newSize.width, fixedWidth), height: newSize.height)
		textView.frame = newFrame;
		inputTextViewHeightConstraint.constant = newFrame.size.height
		item.input_text = textView.text
		expandActionCompletion?()
		textChangedCompletion?()
	}
}
