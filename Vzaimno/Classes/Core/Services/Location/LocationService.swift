//
//  LocationService.swift
//  Vzaimno
//
//  Created by Sergii Bilyk on 16.09.2021.
//

import UIKit
import CoreLocation

final class LocationService: NSObject {

	static let shared = LocationService()

	// MARK: - Properties

	private let locationManager = CLLocationManager()
	private let locationSettingsWasRequestedKey = "LocationService.locationSettingsWasRequestedKey"

	// MARK: - Internal

	var userLocation: (latitude: String, longitude: String)?

	func checkLocationPermissionsFrom(vc: UIViewController) {
		locationManager.delegate = self

		let status = CLLocationManager.authorizationStatus()
		switch status {
			case .authorizedAlways:
				return
			case .authorizedWhenInUse:
				locationManager.startUpdatingLocation()
			case .denied:
				promptToAllowLocationAccessViaSettingFrom(vc)
			case .notDetermined:
				locationManager.requestWhenInUseAuthorization()
			case .restricted:
				promptToAllowLocationAccessViaSettingFrom(vc)
		@unknown default:
			return
		}
	}

	func stopLocationUpdates() {
		locationManager.stopUpdatingLocation()
	}

	// MARK: - Private

	private func promptToAllowLocationAccessViaSettingFrom(_ vc: UIViewController) {
		if locationSettingsWasRequestedState {
			return
		}
		saveLocationSettingsWasRequestedState()
		let alert = UIAlertController(title: "Перейти в настройки", message: "Геоданные используются при создании фотографий в процессе заполнения заявки, без установленного разрешения вы не сможете создать заявку", preferredStyle: UIAlertController.Style.alert)

		alert.addAction(UIAlertAction(title: "Отменить", style: .default) { (alert) -> Void in

		})
		alert.addAction(UIAlertAction(title: "Настройки", style: .cancel) { (alert) -> Void in
			if let settingsUrl = URL(string: UIApplication.openSettingsURLString), UIApplication.shared.canOpenURL(settingsUrl) {
				UIApplication.shared.open(settingsUrl)
			}
		})

		vc.present(alert, animated: true)
	}

	private var locationSettingsWasRequestedState: Bool {
		return UserDefaults.standard.bool(forKey: locationSettingsWasRequestedKey)
	}

	private func saveLocationSettingsWasRequestedState() {
		UserDefaults.standard.set(true, forKey: locationSettingsWasRequestedKey)
	}
}

extension LocationService: CLLocationManagerDelegate {

	func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
		if let location = locations.last {
			userLocation = (latitude: String(location.coordinate.latitude),
							longitude: String(location.coordinate.longitude))
			print("Location latitude: \(userLocation?.latitude ?? "") longitude: \(userLocation?.longitude ?? "")")
		}
	}

	func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
		if status == .authorizedWhenInUse {
			manager.startUpdatingLocation()
		}
	}

	@objc(locationManager:didFailWithError:)
	func locationManager(_ manager: CLLocationManager, didFailWithError error: NSError) {
		print("CLLocationManager error: \(error.localizedDescription)")
	}
}
