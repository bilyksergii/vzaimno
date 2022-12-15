//
//  ShareService.swift
//  Vzaimno
//
//  Created by Sergii Bilyk on 11.08.2021.
//

import UIKit

protocol ShareServiceProtocol {
	func share(url: URL, fromViewController viewController: BaseViewController)
}

final class ShareService: ShareServiceProtocol {

	static let shared = ShareService()

	func share(url: URL, fromViewController viewController: BaseViewController) {
		let activityViewController = UIActivityViewController(activityItems: [url], applicationActivities: nil)
		activityViewController.completionWithItemsHandler = { (activity, isSuccess, _, error) in
			if isSuccess, let activity = activity {
				let message: String? = {
					switch activity {
					case .copyToPasteboard:
						return "Скопировано в буфер"
					default:
						return nil
					}
				}()
				if let message = message {
					viewController.showToast(message: message, type: .info)
				}
			} else if activity == .openInIBooks, !isSuccess {
				viewController.showToast(message: "Ошибка шаринга файла", type: .error)
			} else if let error = error, (error as NSError).code != NSUserCancelledError {
				viewController.showToast(message: "Ошибка шаринга файла", type: .error)
			}
		}
		viewController.present(activityViewController, animated: true)
	}
}
