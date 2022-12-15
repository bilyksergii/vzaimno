//
//  NewStatementViewController.swift
//  Vzaimno
//
//  Created by Sergii Bilyk on 27.09.2021.
//

import UIKit
import WebKit
import CoreServices

protocol NewStatementViewProtocol: BaseViewProtocol {
	func newStatementsUpdated(_ newStatements: [NewStatement])
	func statementTextUpdated(_ data: String)
	func closeScreen()
	func updateFilesList(file: StatementFileViewModel, filesHash: String)
}

class NewStatementViewController: BaseViewController {

	// MARK: - IBOutlets

	@IBOutlet weak var mainStackView: UIStackView!

	@IBOutlet weak var statementsListTextField: TextFieldWithPicker!
	@IBOutlet weak var tranchesTextField: TextFieldWithPicker!

	@IBOutlet weak var inputsTableView: IntrinsicTableView!
	@IBOutlet weak var filesTableView: IntrinsicTableView!

	@IBOutlet weak var statementWebView: WKWebView!
	@IBOutlet weak var statementHeightConstraint: NSLayoutConstraint!

	// MARK: - Properties

	private lazy var router: NewStatementRouterProtocol = NewStatementRouter(sourceViewController: self)
	private lazy var presenter = NewStatementPresenter(view: self, router: router)

	private var newStatements: [NewStatement]?
	private var textInputs: [InputViewModel]?
	private var files = [StatementFileViewModel]()
	private var currentStatementHtml = ""
	private var filesHash: String?
	private var textEditTimer: Timer?

	// MARK: - LifeCycle

	static func controller() -> NewStatementViewController {
		let storyboard = UIStoryboard(name: "NewStatement", bundle: nil)
		let vc = storyboard.instantiateInitialViewController() as! NewStatementViewController
		return vc
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		configureAppearance()

		inputsTableView.dataSource = self
		inputsTableView.delegate = self
		inputsTableView.tableFooterView = UIView()
		inputsTableView.rowHeight = UITableView.automaticDimension

		filesTableView.dataSource = self
		filesTableView.delegate = self
		filesTableView.tableFooterView = UIView()
		filesTableView.rowHeight = UITableView.automaticDimension

		statementsListTextField.delegate = self

		statementWebView.navigationDelegate = self
		statementWebView.scrollView.isScrollEnabled = false

		tranchesTextField.listOfValues = presenter.userTranches?.map { $0.number }
		presenter.getNewStatementsList()
	}

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		setNavigationBarStyleLight(true)
	}

	// MARK: - Private

	private func configureAppearance() {
		hideTabBar()
		navigationItem.title = "Отправить заявление"
		addRightNavigationButton()

		mainStackView.isHidden = true
		showLoader()

		statementsListTextField.dropDownIcon = #imageLiteral(resourceName: "polygon_down")
		tranchesTextField.dropDownIcon = #imageLiteral(resourceName: "polygon_down")
	}

	private func updateInputs() {
		textInputs = newStatements?[statementsListTextField.selectedValueIndex ?? 0].textInputs.map { $0.map { return InputViewModel(input: $0) } }
	}

	@objc private func updateStatementText() {
		guard let id_statement = newStatements?[statementsListTextField.selectedValueIndex ?? 0].id,
				let loan = tranchesTextField.text else { return }

		var paramsDict = ["id_statement": id_statement,
						  "loan": loan]
		textInputs?.forEach {
			if $0.input_text != nil, !($0.input_text?.isEmpty ?? false ) {
				paramsDict["inputs[\($0.input_name)]"] = $0.input_text
			}
		}
		presenter.getStatementText(params: paramsDict)
	}

	private func updateStatementTextWithDelay() {
		textEditTimer?.invalidate()
		textEditTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateStatementText), userInfo: nil, repeats: false)
	}



	private func fillWebview(_ webView: WKWebView, with string: String) {
		webView.loadHTMLString(string, baseURL: Bundle.main.bundleURL)
	}

	private func prepareHtmlString(_ string: String?) -> String {
		return """
				<!DOCTYPE html>
				<html>
					<head>
						<meta name='viewport' content=\"width=device-width content='initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, user-scalable=no, shrink-to-fit=no' content="user-scalable=no"/>
						<link href=\"statementView.css\" rel=\"stylesheet\" type=\"text/css\"/>
					</head>
					<body>
						\(string ?? "")
					</body>
				</html>
				"""
	}

	private func adjustWebViewHeight(_ webView: WKWebView, heightConstraint constraint: NSLayoutConstraint) {
		webView.evaluateJavaScript("document.readyState", completionHandler: { (complete, error) in
			if complete != nil {
				webView.evaluateJavaScript("document.body.scrollHeight", completionHandler: { (height, error) in
					constraint.constant = height as! CGFloat
				})
			}
		})
	}

	private func validateInputs() -> Bool {
		return textInputs?.first(where: { $0.required == "1" && $0.input_text == nil }) == nil
	}

	private func showFileSourcePicker() {
		let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
		if UIImagePickerController.isSourceTypeAvailable(.camera) {
			alert.addAction(UIAlertAction(title: "Сделать фото", style: .default, handler: { [weak self] _ in
				self?.showImagePicker(sourceType: .camera)
			}))
		}
		if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
			alert.addAction(UIAlertAction(title: "Медиа библиотека", style: .default, handler: { [weak self] _ in
				self?.showImagePicker(sourceType: .photoLibrary)
			}))
		}
		alert.addAction(UIAlertAction(title: "Выбрать файл", style: .default, handler: { [weak self] _ in
			let picker = UIDocumentPickerViewController(documentTypes: [String(kUTTypeContent), String(kUTTypeArchive)], in: .import)
			picker.delegate = self
			self?.present(picker, animated: true, completion: nil)
		}))
		alert.addAction(UIAlertAction(title: "Отменить", style: .cancel, handler: nil))
		present(alert, animated: true, completion: nil)
	}

	private func showImagePicker(sourceType: UIImagePickerController.SourceType) {
		let imagePicker = UIImagePickerController()
		imagePicker.mediaTypes = [String(kUTTypeImage)]
		imagePicker.sourceType = sourceType
		imagePicker.delegate = self
		present(imagePicker, animated: true, completion: nil)
	}

	private func fileSelected(url: URL) {
		presenter.prepareFile(url: url, filesHash: filesHash)
	}

	private func ensurePathExist(_ path: String) -> Bool {
		var isDir: ObjCBool = false
		if !FileManager.default.fileExists(atPath: path, isDirectory: &isDir) || !isDir.boolValue {
			do {
				try FileManager.default.createDirectory(atPath: path, withIntermediateDirectories: true, attributes: nil)
			} catch {
				print("Unable to create path \"\(path)\": \(error)")
			}
		}
		return true
	}

	// MARK: - IBActions

	@IBAction func addFilesButtonAction(_ sender: Any) {
		showFileSourcePicker()
	}

	@IBAction func sendStatementButtonAction(_ sender: Any) {
		if validateInputs() {
			presenter.sendNewStatement(msg: currentStatementHtml, filesBundleHash: filesHash ?? "")
		} else {
			showToast(message: "Пожалуйста, заполните все необходимые поля", type: .info, position: .center)
		}
	}
}

extension NewStatementViewController: NewStatementViewProtocol {

	func newStatementsUpdated(_ newStatements: [NewStatement]) {
		self.newStatements = newStatements
		statementsListTextField.listOfValues = newStatements.map { $0.title }
		updateInputs()
		inputsTableView.reloadData()
		updateStatementText()
	}

	func statementTextUpdated(_ data: String) {
		currentStatementHtml = data
		fillWebview(statementWebView, with: prepareHtmlString(data))
	}

	func closeScreen() {
		navigationController?.popViewController(animated: true)
	}

	func updateFilesList(file: StatementFileViewModel, filesHash: String) {
		self.filesHash = filesHash
		files.append(file)
		filesTableView.reloadData()
	}
}

extension NewStatementViewController: UITextFieldDelegate {

	@objc(textFieldShouldEndEditing:)
	func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
		updateInputs()
		inputsTableView.reloadData()
		updateStatementText()
		return true
	}
}

extension NewStatementViewController: WKNavigationDelegate {

	func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
		if webView == statementWebView {
			adjustWebViewHeight(statementWebView, heightConstraint: statementHeightConstraint)
		}
		DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [weak self] in
			self?.mainStackView.isHidden = false
			self?.hideLoader()
		}
	}
}

extension NewStatementViewController: UITableViewDataSource, UITableViewDelegate {

	// MARK: - UITableViewDataSource

	func numberOfSections(in tableView: UITableView) -> Int {
		return 1
	}

	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		if tableView == inputsTableView {
			return textInputs?.count ?? 0
		}
		if tableView == filesTableView {
			return files.count
		}
		return 0
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		if tableView == inputsTableView {
			guard let item = textInputs?[indexPath.row] else { return UITableViewCell() }
			switch item.type {
			case .text:
				if let cell = tableView.dequeueReusableCell(withIdentifier: "TextInputCell", for: indexPath) as? TextInputCell {
					cell.setupWith(item: item, expandActionCompletion: {
						UIView.setAnimationsEnabled(false)
						tableView.beginUpdates()
						tableView.endUpdates()
					}, textChangedCompletion: { [weak self] in
						self?.updateStatementTextWithDelay()
					})
					return cell
				}
			case .date:
				if let cell = tableView.dequeueReusableCell(withIdentifier: "DateInputCell", for: indexPath) as? DateInputCell {
					cell.setupWith(item: item, expandActionCompletion: {
						UIView.setAnimationsEnabled(false)
						tableView.beginUpdates()
						tableView.endUpdates()
					}, textChangedCompletion: { [weak self] in
						self?.updateStatementTextWithDelay()
					})
					return cell
				}
			case .textarea:
				if let cell = tableView.dequeueReusableCell(withIdentifier: "TextViewInputCell", for: indexPath) as? TextViewInputCell {
					cell.setupWith(item: item, expandActionCompletion: {
						UIView.setAnimationsEnabled(false)
						tableView.beginUpdates()
						tableView.endUpdates()
					}, textChangedCompletion: { [weak self] in
						self?.updateStatementTextWithDelay()
					})
					return cell
				}
			}
		}
		if tableView == filesTableView {
			let file = files[indexPath.row]
			if let cell = tableView.dequeueReusableCell(withIdentifier: "NewStatementFileCell", for: indexPath) as? NewStatementFileCell {
				cell.setupWith(item: file)
				return cell
			}
		}
		return UITableViewCell()
	}

	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return UITableView.automaticDimension
	}

	func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
		return UITableView.automaticDimension
	}

	// MARK: - UITableViewDelegate

	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		if tableView == filesTableView {
			let file = files[indexPath.row]
			if let url = URL(string: Constants.APIConfiguration.host + "/files/statement/" + (file.fname_hash)) {
				UIApplication.shared.open(url)
			}
		}
	}
}

// MARK: - UIImagePickerControllerDelegate

extension NewStatementViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {

	func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
		var url: URL?
		if #available(iOS 11.0, *) {
			if let imageUrl = info[.imageURL] as? URL {
				print("Found imageUrl")
				url = imageUrl
			} else if let mediaUrl = info[.mediaURL] as? URL {
				print("Found mediaUrl")
				url = mediaUrl
			}
		}
		if url == nil,
			let image = (info[.editedImage] ?? info[.originalImage]) as? UIImage,
			let imageUrl = saveImageToTemp(image) {
			url = imageUrl
		}
		picker.dismiss(animated: true) {
			if let url = url {
				print("✅ Picked media at '\(url)'")
				self.fileSelected(url: url)
			} else {
				print("❌ Can't find picked media")
			}
		}
	}

	private func saveImageToTemp(_ image: UIImage) -> URL? {
		var tempUrl = URL(fileURLWithPath: NSTemporaryDirectory())
		guard ensurePathExist(tempUrl.path), let imageData = image.jpegData(compressionQuality: 1) else { return nil }
		tempUrl.appendPathComponent(UUID().uuidString)
		tempUrl.appendPathExtension("jpg")
		do {
			try imageData.write(to: tempUrl)
			return tempUrl
		} catch {
			print(error.localizedDescription)
			return nil
		}
	}
}

// MARK: - UIDocumentPickerDelegate

extension NewStatementViewController: UIDocumentPickerDelegate {
	func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentAt url: URL) {
		fileSelected(url: url)
	}
}
