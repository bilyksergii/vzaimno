//
//  SignStepCell.swift
//  Vzaimno
//
//  Created by Sergii Bilyk on 21.07.2021.
//

import UIKit

protocol SignStepCellProtocol: AnyObject {
	func showFullScreenImage(imageLink: String)
}

class SignStepCell: UITableViewCell {

	static let cellId = "SignStepCell"

	//MARK: - IBOutlets

	@IBOutlet weak var separatorView: UIView!
	@IBOutlet weak var titleLabel: UILabel!
	@IBOutlet weak var collectionView: IntrinsicCollectionView!
	@IBOutlet weak var docsTableView: IntrinsicTableView!
	@IBOutlet weak var customsTableView: IntrinsicTableView!

	@IBOutlet weak var signStateButton: UIButton!
	@IBOutlet weak var signButton: UIButton!
	@IBOutlet weak var bottomTextLabel: UILabel!

	// MARK: - Properties

	weak var delegate: SignStepCellProtocol?

	private var switchValueChangedCompletion: ((Bool) -> Void)?
	private var docActionCompletion: ((String) -> Void)?
	private var signActionCompletion: ((String) -> Void)?

	private var mainItem: SigningModel.Block!
	private var photos: [SigningModel.Block.Photo]?
	private var docs: [SignDocViewModel]?
	private var customs: [SigningModel.Block.Custom]?

	private let itemsPerRow: CGFloat = 4
	private let sectionInsets = UIEdgeInsets(top: 10.0, left: 20.0, bottom: 10.0, right: 20.0)

	// MARK: - LifeCycle

	override func awakeFromNib() {
		super.awakeFromNib()

		signButton.layer.cornerRadius = 8

		collectionView.delegate = self
		collectionView.dataSource = self
		collectionView.register(UINib(nibName: SignPhotoCell.cellId, bundle: nil),
								forCellWithReuseIdentifier: SignPhotoCell.cellId)

		docsTableView.delegate = self
		docsTableView.dataSource = self
		docsTableView.tableFooterView = UIView()
		docsTableView.register(UINib(nibName: SignDocCell.cellId, bundle: nil),
						   forCellReuseIdentifier: SignDocCell.cellId)

		customsTableView.delegate = self
		customsTableView.dataSource = self
		customsTableView.tableFooterView = UIView()
		customsTableView.register(UINib(nibName: SignCustomCell.cellId, bundle: nil),
						   forCellReuseIdentifier: SignCustomCell.cellId)
	}

	override func prepareForReuse() {
		super.prepareForReuse()

		titleLabel.text = nil
		signStateButton.setTitle(nil, for: .normal)
		bottomTextLabel.text = nil

		mainItem = nil
		photos = nil
		docs = nil
		customs = nil
	}

	// MARK: - Internal

	func setupWith(item: SigningModel.Block,
				   switchValueChangedCompletion: ((Bool) -> Void)?,
				   docActionCompletion: ((String) -> Void)?,
				   signActionCompletion: ((String) -> Void)?) {
		mainItem = item
		self.switchValueChangedCompletion = switchValueChangedCompletion
		self.docActionCompletion = docActionCompletion
		self.signActionCompletion = signActionCompletion

		titleLabel.text = item.title

		photos = mainItem.photos
		if photos == nil || photos?.count == 0 {
			collectionView.isHidden = true
		}

		docs = mainItem.docs?.sorted(by: { $0.position < $1.position }).map { return SignDocViewModel(doc: $0) }
		if docs == nil || docs?.count == 0 {
			docsTableView.isHidden = true
		}

		customs = mainItem.customs
		if customs == nil || customs?.count == 0 {
			customsTableView.isHidden = true
		}

		if let text = item.text {
			bottomTextLabel.isHidden = false
			bottomTextLabel.text = text
		} else {
			bottomTextLabel.isHidden = true
		}

		signButton.isHidden = true
		signStateButton.isHidden = false

		if let state = item.state?.state {
			switch state {
			case .offline:
				signStateButton.setTitle("Подписано оффлайн", for: .normal)
				signStateButton.isEnabled = false
			case .online:
				signStateButton.setUnderlinedText("Подписано", font: UIFont.ekibastuzBold15, color: .mainBlueColor)
				signStateButton.isEnabled = true
			case .active:
				signStateButton.setUnderlinedText("Выделить все", font: UIFont.ekibastuzBold15, color: .mainBlueColor)
				signStateButton.isEnabled = true
			}
		}

		collectionView.reloadData()
		docsTableView.reloadData()
		customsTableView.reloadData()
	}

	// MARK: - Actions

	@IBAction func signStateButtonAction(_ sender: Any) {
		if mainItem.state?.state == .active {
			docs?.forEach { $0.switchIsOn = true }
			docsTableView.reloadData()
			signButton.isHidden = false
			signStateButton.isHidden = true
		}
	}

	@IBAction func signButtonAction(_ sender: Any) {
		signActionCompletion?(mainItem.step ?? "")
	}
}

extension SignStepCell: UITableViewDataSource, UITableViewDelegate {

	// MARK: - UITableViewDataSource

	func numberOfSections(in tableView: UITableView) -> Int {
		return 1
	}

	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		if tableView == docsTableView {
			return docs?.count ?? 0
		}
		if tableView == customsTableView {
			return customs?.count ?? 0
		}
		return 0
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		if tableView == docsTableView {
			guard let cell = tableView.dequeueReusableCell(withIdentifier: SignDocCell.cellId, for: indexPath) as? SignDocCell, let docItem = docs?[indexPath.row] else { return UITableViewCell() }

			if let state = mainItem.state?.state {
				switch state {
				case .offline, .online:
					docItem.switchIsOn = true
					docItem.switchIsEnabled = false
				case .active:
					docItem.switchIsEnabled = true
				}
			}
			cell.setupWith(item: docItem, switchValueChangedCompletion: { [weak self] switchIsOn in
				if self?.mainItem.state?.state == .active {
					self?.docs?[indexPath.row].switchIsOn = switchIsOn
					if self?.docs?.filter({ $0.switchIsOn == false }).count == 0 {
						self?.signButton.isHidden = false
						self?.signStateButton.isHidden = true
					} else {
						self?.signButton.isHidden = true
						self?.signStateButton.isHidden = false
					}
				}
			}, docActionCompletion: { [weak self] md5 in
				self?.docActionCompletion?(md5)
			})
			return cell
		}
		if tableView == customsTableView {
			guard let cell = tableView.dequeueReusableCell(withIdentifier: SignCustomCell.cellId, for: indexPath) as? SignCustomCell, let customItem = customs?[indexPath.row] else { return UITableViewCell() }
			cell.setupWith(item: customItem, switchValueChangedCompletion: { [weak self] value in
				self?.switchValueChangedCompletion?(value)
			})
			return cell
		}
		return UITableViewCell()
	}
}

extension SignStepCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

	// MARK: - UICollectionViewDataSource
	
	func numberOfSections(in collectionView: UICollectionView) -> Int {
		return 1
	}

	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return photos?.count ?? 0
	}

	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SignPhotoCell.cellId, for: indexPath) as? SignPhotoCell, let photoItem = photos?[indexPath.row] else { return UICollectionViewCell() }
		cell.setupWith(item: photoItem)
		return cell
	}

	// MARK: - UICollectionViewDelegate

	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		if let photoItem = photos?[indexPath.row] {
			delegate?.showFullScreenImage(imageLink: photoItem.full_path)
		}
	}

	// MARK: - UICollectionViewDelegateFlowLayout

	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
		let availableWidth = contentView.frame.width - paddingSpace
		let widthPerItem = availableWidth / itemsPerRow
		return CGSize(width: widthPerItem, height: widthPerItem * 1.5)
	}

	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
		return sectionInsets
	}

	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
		return sectionInsets.left
	}
}
