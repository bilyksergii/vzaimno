//
//  IntrinsicTableView.swift
//  Vzaimno
//
//  Created by Sergii Bilyk on 22.07.2021.
//

import UIKit

final class IntrinsicTableView: UITableView {

	override var contentSize: CGSize {
		didSet {
			invalidateIntrinsicContentSize()
		}
	}

	override var intrinsicContentSize: CGSize {
		layoutIfNeeded()
		return CGSize(width: UIView.noIntrinsicMetric, height: contentSize.height)
	}
}
