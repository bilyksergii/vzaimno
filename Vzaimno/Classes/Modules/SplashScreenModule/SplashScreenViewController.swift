//
//  SplashScreenViewController.swift
//  Vzaimno
//
//  Created by Sergii Bilyk on 26.06.2021.
//

import UIKit

protocol SplashScreenProtocol: BaseViewProtocol {

}

class SplashScreenViewController: BaseViewController {

	//MARK: - Properties

	private lazy var router: SplashScreenRouterProtocol = SplashScreenRouter(sourceViewController: self)
	private lazy var presenter: SplashScreenPresenterProtocol = SplashPresenter(view: self, router: router)

	// MARK: - lifeCycle

	static func controller() -> UIViewController {
		let sb = UIStoryboard(name: "SplashScreen", bundle: nil)
		let vc = sb.instantiateInitialViewController()!
		return vc
	}

	override func viewDidLoad() {
		super.viewDidLoad()

		presenter.checkToken()
	}

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)

		hideNavBar(true)
	}
}

extension SplashScreenViewController: SplashScreenProtocol {}
