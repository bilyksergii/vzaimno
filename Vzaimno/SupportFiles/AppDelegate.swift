//
//  AppDelegate.swift
//  Vzaimno
//
//  Created by Sergii Bilyk on 24.06.2021.
//

import UIKit
import IQKeyboardManagerSwift
import SideMenu
import Firebase

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

	var window: UIWindow?

	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
		FirebaseApp.configure()

		setupKeyboard()
		setupSideMenu()
		configureNavigationBarAppearance()
		configureBarButtonItemApperance()

		NotificationCenter.default.addObserver(self, selector: #selector(didLogout), name: .didLogout, object: nil)

		return true
	}

	func applicationDidEnterBackground(_ application: UIApplication) {
		IQKeyboardManager.shared.resignFirstResponder()
	}

	func applicationDidBecomeActive(_ application: UIApplication) {
		let topMostVC = window?.rootViewController?.topmostViewController()

		if let vc = topMostVC as? SigningViewController {
			vc.presenter.checkPaymentResult()
		}

		if topMostVC is AuthViewController ||
			topMostVC is SmsCodeViewController ||
			topMostVC is CameraViewController ||
			topMostVC is SigningViewController ||
			topMostVC is TrancheViewController ||
			topMostVC is TrancheDetailsViewController ||
			topMostVC is PaymentsGraphicViewController ||
			topMostVC is PaymentsHistoryViewController ||
			topMostVC is WebDocViewController ||
			topMostVC is StatementsViewController ||
			topMostVC is StatementViewController ||
			topMostVC is NewStatementViewController {
			return
		}

		configureRootViewController()
	}

	func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
		guard userActivity.activityType == NSUserActivityTypeBrowsingWeb,
			let url = userActivity.webpageURL,
			  let _ = URLComponents(url: url, resolvingAgainstBaseURL: true) else {
			return false
		}
		UniversalLinkService.shared.cheduleLink(url: url)
		return true
	}

	// MARK: - Private

	@objc private func didLogout() {
		SecureService.shared.clear()
		CacheService.shared.clearCaches()
		configureRootViewController()
	}

	private func setupKeyboard() {
		let keyboardManager = IQKeyboardManager.shared
		keyboardManager.enableAutoToolbar = true
		keyboardManager.shouldResignOnTouchOutside = true
		keyboardManager.layoutIfNeededOnUpdate = true
		keyboardManager.enable = true
		keyboardManager.keyboardDistanceFromTextField = 140
		keyboardManager.toolbarDoneBarButtonItemText = "Готово"
	}

	private func setupSideMenu() {
		let vc = SideMenuViewController.controller()
		vc.settings = SideMenuSettings.appSettings
		SideMenuManager.default.leftMenuNavigationController = vc
	}

	private func configureRootViewController() {
		let viewController = SplashScreenViewController.controller()
		window = UIWindow(frame: UIScreen.main.bounds)
		window?.rootViewController = viewController
		window?.backgroundColor = .black
		window?.makeKeyAndVisible()
	}

	private func configureNavigationBarAppearance() {
		let appearance = UINavigationBar.appearance()
		appearance.shadowImage = UIImage()
		appearance.titleTextAttributes = [.font: UIFont(name: "Ekibastuz-Heavy", size: 17) as Any, .foregroundColor: UIColor.black]
		appearance.barTintColor = .black
		appearance.tintColor = .darkGray
		appearance.isTranslucent = true
		appearance.backgroundColor = .white
		appearance.setBackgroundImage(UIImage(), for: .default)
		appearance.layer.masksToBounds = false
		let backIcon = UIImage(named: "back")?.withRenderingMode(.alwaysTemplate)
		appearance.backIndicatorImage = backIcon
		appearance.backIndicatorTransitionMaskImage = backIcon
	}

	private func configureBarButtonItemApperance() {
		let apperance = UIBarButtonItem.appearance()
		apperance.setBackButtonTitlePositionAdjustment(UIOffset(horizontal: -1000, vertical: 2), for: .default)
	}
}

