//
//  MainTabBarViewController.swift
//  Vzaimno
//
//  Created by Sergii Bilyk on 16.08.2021.
//

import UIKit

class MainTabBarViewController: UITabBarController {

	// MARK: - LifeCycle

	static func controller() -> MainTabBarViewController {
		let storyboard = UIStoryboard(name: "MainTabBar", bundle: nil)
		let vc = storyboard.instantiateInitialViewController() as! MainTabBarViewController
		return vc
	}

	override func viewDidLoad() {
		super.viewDidLoad()

		navigationController?.setNavigationBarHidden(true, animated: true)

		tabBar.layer.shadowColor = UIColor.lightGray.cgColor
		tabBar.layer.shadowOpacity = 0.5
		tabBar.layer.shadowOffset = CGSize.zero
		tabBar.layer.shadowRadius = 5
		tabBar.layer.borderColor = UIColor.clear.cgColor
		tabBar.layer.borderWidth = 0
		tabBar.clipsToBounds = false
		tabBar.backgroundColor = UIColor.white
		UITabBar.appearance().shadowImage = UIImage()
		UITabBar.appearance().backgroundImage = UIImage()
	}
}
