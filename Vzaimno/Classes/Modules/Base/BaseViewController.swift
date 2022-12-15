//
//  BaseViewController.swift
//  Vzaimno
//
//  Created by Sergii Bilyk on 26.06.2021.
//

import UIKit
import Toast_Swift
import SideMenu

class BaseViewController: UIViewController {

	@IBOutlet weak var activityIndicatorView: UIActivityIndicatorView?

	// MARK: - Properties

	private lazy var router: BaseRouterProtocol = BaseRouter(sourceViewController: self)
	lazy var basePresenter = BasePresenter(view: self, router: router)

	// MARK: - LifeCycle

	override func viewDidLoad() {
		super.viewDidLoad()
		configureUI()
	}

	// MARK: - Public

	public func addPanGestureToPresentMenu() {
		SideMenuManager.default.addPanGestureToPresent(toView: view)
		SideMenuManager.default.addScreenEdgePanGesturesToPresent(toView: view, forMenu: .left)
	}

	public func addRightNavigationButton(isWhite: Bool = false) {
		let button = UIButton()
		button.frame = CGRect(x: 0, y: 0, width: 36, height: 36)
		button.setImage(UIImage(named: isWhite ? "logoSmallWhite" : "logoSmall"), for: .normal)
		button.addTarget(self, action: #selector(rightNavigationButtonAction), for: .touchUpInside)
		let menuItem = UIBarButtonItem(customView: button)
		navigationItem.rightBarButtonItem = menuItem
	}

	public func addLeftMenuButton() {
		let button = UIButton()
		button.frame = CGRect(x: 0, y: 0, width: 36, height: 36)
		button.setImage(UIImage(named: "menuButton"), for: .normal)
		button.addTarget(self, action: #selector(leftMenuButtonAction), for: .touchUpInside)
		let menuItem = UIBarButtonItem(customView: button)
		navigationItem.leftBarButtonItem = menuItem
	}

	@objc public func rightNavigationButtonAction(_ sender: UIButton) {
		//Must be overridden in child viewController
		#warning("TODO: Add right Navigation Button Action")
	}

	@objc public func leftMenuButtonAction(_ sender: UIButton) {
		let vc = SideMenuViewController.controller()
		vc.settings = SideMenuSettings.appSettings
		SideMenuManager.default.leftMenuNavigationController = vc
		present(vc, animated: true, completion: nil)
	}

	public func hideBackButton() {
		navigationItem.setHidesBackButton(true, animated: true)
	}

	public func hideNavBar(_ isHidden: Bool) {
		navigationController?.setNavigationBarHidden(isHidden, animated: true)
	}

	public func setNavigationBarStyleLight(_ isLight: Bool) {
		guard let navBar = navigationController?.navigationBar else { return }
		navBar.titleTextAttributes = [.font: UIFont(name: "Ekibastuz-Heavy", size: 17) as Any, NSAttributedString.Key.foregroundColor: isLight ? UIColor.black : UIColor.white]
		navBar.barTintColor = isLight ? .black : .white
		navBar.tintColor = isLight ? .darkGray : .white
		navBar.backgroundColor = isLight ? .clear : .black
		navBar.barStyle = isLight ? .default : .black
	}

	public func setNavigationBarStyleBlue() {
		guard let navBar = navigationController?.navigationBar else { return }
		navBar.titleTextAttributes = [.font: UIFont(name: "Ekibastuz-Heavy", size: 17) as Any, NSAttributedString.Key.foregroundColor: UIColor.white]
		navBar.barTintColor = UIColor.mainBlueColor
		navBar.tintColor = .white
		navBar.backgroundColor = .clear
		navBar.barStyle = .black
	}

	public func hideTabBar(_ isHiden: Bool = true) {
		tabBarController?.tabBar.isHidden = isHiden
	}

	// MARK: - Private

	private func configureUI() {
		view.backgroundColor = .white
		activityIndicatorView?.color = .gray
		activityIndicatorView?.hidesWhenStopped = true
	}
}

extension BaseViewController: BaseViewProtocol {

	func showToastMessage(_ message: String, type: ToastType, position: ToastPosition, duration: TimeInterval) {
		showToast(message: message, type: type, position: position, duration: duration)
	}

	@objc func showLoader() {
		activityIndicatorView?.startAnimating()
	}

	func hideLoader() {
		activityIndicatorView?.stopAnimating()
	}
}
