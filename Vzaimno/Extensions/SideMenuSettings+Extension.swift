//
//  SideMenuSettings+Extension.swift
//  Vzaimno
//
//  Created by Sergii Bilyk on 09.09.2021.
//

import SideMenu

extension SideMenuSettings {

	static var appSettings: SideMenuSettings {
		var settings = SideMenuSettings()
		settings.presentationStyle = .menuSlideIn
		settings.menuWidth = min(323.0 / 375.0 * UIScreen.main.bounds.width, 323)
		settings.statusBarEndAlpha = 0.0
		return settings
	}
}
