//
//  LoansHeaderView.swift
//  Vzaimno
//
//  Created by Sergii Bilyk on 20.08.2021.
//

import UIKit

class LoansHeaderView: UITableViewHeaderFooterView {

	//MARK: - IBOutlets

	@IBOutlet weak var separatorView: UIView!
	@IBOutlet weak var titleLabel: UILabel!
	@IBOutlet weak var poligonImageView: UIImageView!

	// MARK: - Properties

	var tapCompletion: (() -> Void)?

	// MARK: - Life Cycle

	override func awakeFromNib() {
		super.awakeFromNib()

		separatorView.backgroundColor = UIColor.init(hex: 0xF7F8FA)
		contentView.backgroundColor = .white

		addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapHeader)))
	}

	//MARK: - Internal

	func setCollapsed(_ collapsed: Bool) {
		poligonImageView.rotate(collapsed ? .pi : 0.0)
	}

	//MARK: - Private

	@objc private func tapHeader(gestureRecognizer: UITapGestureRecognizer) {
		tapCompletion?()
	}
}
