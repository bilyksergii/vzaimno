//
//  WebDocViewController.swift
//  Vzaimno
//
//  Created by Sergii Bilyk on 28.06.2021.
//

import UIKit
import WebKit

class WebDocViewController: BaseViewController {

	//MARK: - IBOutlets

	@IBOutlet weak var containerWebView: UIView!
	@IBOutlet weak var closeButton: UIButton!

	//MARK: - Properties

	private var webView: WKWebView!
	private var url: URL?
	private var htmlString: String?
	private var isLoading = false
	private var navTitle: String?

	// MARK: - lifeCycle

	static func controller(url: URL? = nil, htmlString: String? = nil, navTitle: String? = nil) -> WebDocViewController {
		let storyboard = UIStoryboard(name: "WebView", bundle: nil)
		let vc = storyboard.instantiateInitialViewController() as! WebDocViewController
		vc.url = url
		vc.htmlString = htmlString
		vc.navTitle = navTitle
		return vc
	}

	override func viewDidLoad() {
		super.viewDidLoad()

		hideNavBar(false)
		addRightNavigationButton()
		navigationItem.title = navTitle
		closeButton.isHidden = navTitle != nil  //SideMenu mode, close button is hidden.
		webView = createWebView()
	}

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		if let url = url {
			loadUrl(url)
		}

		if let htmlString = htmlString {
			loadHtmlString(htmlString)
		}
	}

	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		hideNavBar(true)
	}

	// MARK: - Private

	@discardableResult
	private func createWebView(withConfiguration configuration: WKWebViewConfiguration? = nil) -> WKWebView {
		let webView = WKWebView(frame: containerWebView.bounds, configuration: configuration ?? WKWebViewConfiguration())
		webView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
		containerWebView.addSubview(webView)
		webView.navigationDelegate = self
		webView.uiDelegate = self
		webView.allowsLinkPreview = false
		webView.configuration.dataDetectorTypes = .phoneNumber
		return webView
	}

	private func loadUrl(_ url: URL) {
		let request = URLRequest(url: url)
		self.webView.load(request)
	}

	private func loadHtmlString( _ htmlString: String) {
		webView.loadHTMLString(htmlString, baseURL: Bundle.main.bundleURL)
	}

	// MARK: - IBActions

	@IBAction func closeButtonAction(_ sender: Any) {
		dismiss(animated: true, completion: nil)
	}
}

extension WebDocViewController: WKNavigationDelegate, WKUIDelegate {

	// MARK: - WKNavigationDelegate

	func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Swift.Void) {
		if self.url != nil {
			if let url = navigationAction.request.url, url != self.url, !isLoading {
				UIApplication.shared.open(url)
				decisionHandler(.cancel)
			} else {
				decisionHandler(.allow)
			}
			return
		}
		if htmlString != nil {
			if let url = navigationAction.request.url, url != Bundle.main.bundleURL, !isLoading {
				UIApplication.shared.open(url)
				decisionHandler(.cancel)
			} else {
				decisionHandler(.allow)
			}
			return
		}

		if let url = navigationAction.request.url, (url.scheme == "tel" || url.scheme == "mailto") {
			UIApplication.shared.open(url)
			decisionHandler(.cancel)
		} else {
			decisionHandler(.allow)
		}
	}

	func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
		showLoader()
		isLoading = true
	}

	func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
		hideLoader()
		isLoading = false
	}

	@objc(webView:didFail:withError:)
	func webView(_ webView: WKWebView, didFail navigation: WKNavigation, withError error: NSError) {
		hideLoader()
		showToast(message: error.localizedDescription, type: .error)
	}

	// MARK: - WKUIDelegate

	func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
		webView.load(navigationAction.request)
		return nil
	}
}
