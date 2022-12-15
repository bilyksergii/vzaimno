//
//  UploadPhotoViewController.swift
//  Vzaimno
//
//  Created by Sergii Bilyk on 13.07.2021.
//

import UIKit

protocol UploadPhotoViewProtocol: BaseViewProtocol {
	func updatePhotos(text: String?, photos: [Photo])
}

class UploadPhotoViewController: BaseViewController {

	private struct Section {
		let name: String
		let items: [Photo]
	}

	// MARK: - IBOutlets

	@IBOutlet weak var headTextLabel: UILabel!
	@IBOutlet weak var sendPhotoButton: UIButton!
	@IBOutlet weak var collectionView: UICollectionView!

	// MARK: - Properties

	private lazy var router: UploadPhotoRouterProtocol = UploadPhotoRouter(sourceViewController: self)
	lazy var presenter = UploadPhotoPresenter(view: self, router: router)

	private let refreshControl = UIRefreshControl()

	private var headText: String?
	private var photos: [Photo]!
	private var sections = [Section]()
	private var needToHighlightCells = false

	private let itemsPerRow: CGFloat = 4
	private let sectionInsets = UIEdgeInsets(top: 10.0, left: 20.0, bottom: 10.0, right: 20.0)
	private var fromAccount = false

	// MARK: - LifeCycle

	static func controller(fromAccount: Bool, text: String?, photos: [Photo]?) -> UploadPhotoViewController {
		let storyboard = UIStoryboard(name: "UploadPhoto", bundle: nil)
		let vc = storyboard.instantiateInitialViewController() as! UploadPhotoViewController
		vc.headText = text
		vc.photos = photos ?? [Photo]()
		vc.fromAccount = fromAccount
		return vc
	}

	override func viewDidLoad() {
		super.viewDidLoad()

		if !fromAccount {
			hideBackButton()
		}

		refreshControl.addTarget(self, action: #selector(onRefresh), for: .valueChanged)
		collectionView.addSubview(refreshControl)

		prepareViewModelSections()
		configureAppearance()

		collectionView.delegate = self
		collectionView.dataSource = self

		hideTabBar()
	}

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		hideNavBar(false)
		setNavigationBarStyleLight(true)
		LocationService.shared.checkLocationPermissionsFrom(vc: self)
	}

	override func viewDidDisappear(_ animated: Bool) {
		super.viewDidDisappear(animated)
		LocationService.shared.stopLocationUpdates()
	}

	override func showLoader() {
		if !refreshControl.isRefreshing {
			activityIndicatorView?.startAnimating()
		}
	}

	// MARK: - Private

	private func configureAppearance() {
		addRightNavigationButton()
		navigationItem.title = "Заявка"

		headTextLabel.text = preparedHeadText()
		headTextLabel.setLineSpacing()

		sendPhotoButton.setTitle("Отправить фотографии", for: .normal)
		sendPhotoButton.layer.cornerRadius = 8
	}

	private func preparedHeadText() -> String? {
		return headText?.replacingOccurrences(of: "\\n", with: "\n")
	}

	private func prepareViewModelSections() {
		let firstSection = Section(name: "Документы", items: photos.filter({ $0.image_group == 1 }))
		let secondSection = Section(name: "Фото автомобиля", items: photos.filter({ $0.image_group == 2 }))
		let thirdSection = Section(name: "Прочее", items: photos.filter({ $0.image_group == 3 }))
		sections = [firstSection, secondSection, thirdSection]
	}

	private func requiredPhotoNotUploaded() -> Bool {
		return photos.filter( { $0.required == true && $0.file_path == nil }).count > 0
	}

	private func reloadCollectionView() {
		prepareViewModelSections()
		collectionView.reloadData()
	}

	@objc private func onRefresh() {
		if fromAccount {
			presenter.updatePhotos()
		} else {
			presenter.updateCurrentScreen()
		}
	}

	// MARK: - IBActions

	@IBAction func sendPhotoButtonAction(_ sender: Any) {
		if requiredPhotoNotUploaded() {
			showToast(message: "Для начала загрузите все обзательные фотографии", type: .info, position: .center)
			needToHighlightCells = true
		} else {
			needToHighlightCells = false
			presenter.makeFotoIsUploadedRequest()
		}
		reloadCollectionView()
	}
}

extension UploadPhotoViewController: UploadPhotoViewProtocol {

	func updatePhotos(text: String?, photos: [Photo]) {
		refreshControl.endRefreshing()
		self.headText = text
		self.photos = photos
		reloadCollectionView()
		headTextLabel.text = preparedHeadText()
	}
}

extension UploadPhotoViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

	// MARK: - UICollectionViewDataSource

	func numberOfSections(in collectionView: UICollectionView) -> Int {
		return sections.count
	}

	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return sections[section].items.count
	}

	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoItemCell", for: indexPath) as? PhotoItemCell else { return UICollectionViewCell() }

		let mode: PhotoItemCell.Mode = needToHighlightCells ? .required : .normal
		cell.setupWith(item: sections[indexPath.section].items[indexPath.row], mode: mode)
		return cell
	}

	func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
		switch kind {
		case UICollectionView.elementKindSectionHeader:
			guard let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "PhotoHeaderView", for: indexPath) as? PhotoHeaderView else { return UICollectionReusableView() }
			headerView.titleLabel.text = sections[indexPath.section].name
			headerView.separatorView.isHidden = indexPath.section == 0
			return headerView
		default:
			return UICollectionReusableView()
		}
	}

	// MARK: - UICollectionViewDelegate

	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		let photoItem = sections[indexPath.section].items[indexPath.row]
		router.showCameraView(photo: photoItem, type: String(photoItem.id))
	}

	// MARK: - UICollectionViewDelegateFlowLayout

	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
		let availableWidth = view.frame.width - paddingSpace
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
