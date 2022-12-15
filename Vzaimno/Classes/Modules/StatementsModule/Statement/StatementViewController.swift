//
//  StatementViewController.swift
//  Vzaimno
//
//  Created by Sergii Bilyk on 23.09.2021.
//

import UIKit
import WebKit

class StatementViewController: BaseViewController {

	// MARK: - IBOutlets

	@IBOutlet weak var mainStackView: UIStackView!

	@IBOutlet weak var statementWebView: WKWebView!
	@IBOutlet weak var statementHeightConstraint: NSLayoutConstraint!

	@IBOutlet weak var statusLabel: UILabel!

	@IBOutlet weak var answerWebView: WKWebView!
	@IBOutlet weak var answerHeightConstraint: NSLayoutConstraint!
	@IBOutlet weak var answerContainerStackView: UIStackView!
	@IBOutlet weak var answerSeparatorView: UIView!

	@IBOutlet weak var filesContainerStackView: UIStackView!
	@IBOutlet weak var filesSeparatorView: UIView!
	@IBOutlet weak var filesTableView: IntrinsicTableView!

	// MARK: - Properties

	private var statement: Statement?

	// MARK: - LifeCycle

	static func controller(statement: Statement) -> StatementViewController {
		let storyboard = UIStoryboard(name: "Statement", bundle: nil)
		let vc = storyboard.instantiateInitialViewController() as! StatementViewController
		vc.statement = statement
		return vc
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		mainStackView.isHidden = true
		statementWebView.navigationDelegate = self
		statementWebView.scrollView.isScrollEnabled = false
		answerWebView.navigationDelegate = self
		answerWebView.scrollView.isScrollEnabled = false
		filesTableView.delegate = self
		filesTableView.dataSource = self

		configureAppearance()
		fillStatement()
		showLoader()
	}

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		setNavigationBarStyleLight(true)
	}

	// MARK: - Private

	private func configureAppearance() {
		hideTabBar()
		navigationItem.title = "Заявление №\(statement?.number ?? "")"
		addRightNavigationButton()

		let answerIsEmpty = (statement?.answer?.isEmpty) != nil
		answerContainerStackView.isHidden = answerIsEmpty
		answerSeparatorView.isHidden = answerIsEmpty

		let noFiles = statement?.files?.count == 0
		filesContainerStackView.isHidden = noFiles
		filesSeparatorView.isHidden = noFiles
	}

	private func fillStatement() {
		statusLabel.text = statement?.status
		fillWebview(statementWebView, with: prepareHtmlString(statement?.statement))
		fillWebview(answerWebView, with: prepareHtmlString(statement?.answer))
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
}

extension StatementViewController: WKNavigationDelegate {

	func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
		if webView == statementWebView {
			adjustWebViewHeight(statementWebView, heightConstraint: statementHeightConstraint)
		}
		if webView == answerWebView {
			adjustWebViewHeight(answerWebView, heightConstraint: answerHeightConstraint)
		}
		DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) { [weak self] in
			self?.hideLoader()
			self?.mainStackView.isHidden = false
		}
	}
}

extension StatementViewController: UITableViewDelegate, UITableViewDataSource {

	// MARK: - UITableViewDataSource

	func numberOfSections(in tableView: UITableView) -> Int {
		return 1
	}

	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return statement?.files?.count ?? 0
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		if	let fileItem = statement?.files?[indexPath.row],
			let cell = tableView.dequeueReusableCell(withIdentifier: "StatementsFileCell", for: indexPath) as? StatementsFileCell {
			cell.setupWith(item: fileItem)
			return cell
		}
		return UITableViewCell()
	}

	// MARK: - UITableViewDelegate

	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		if let file = statement?.files?[indexPath.row] {
			if let url = URL(string: Constants.APIConfiguration.host + (file.path_file ?? "") + (file.name_hash ?? "")) {
				UIApplication.shared.open(url)
			}
		}
	}
}
