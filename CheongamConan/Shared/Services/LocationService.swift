//
//  LocationService.swift
//  CheongamConan
//
//  Created by 정홍섭 on 7/12/26.
//

import Foundation
import Observation
import CoreLocation
import UIKit

@Observable
final class LocationService: NSObject {
    private let locationManager = CLLocationManager()

    private(set) var authorizationStatus: CLAuthorizationStatus
    private(set) var currentLocation: CLLocation?
    private(set) var locationError: Error?
    private(set) var isRequestingLocation: Bool = false

    override init() {
        authorizationStatus = locationManager.authorizationStatus

        super.init()

        locationManager.delegate = self

        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.distanceFilter = 10
    }

    var isAuthorized: Bool {
        switch authorizationStatus {
        case .authorizedWhenInUse, .authorizedAlways:
            return true

        default:
            return false
        }
    }

    func requestAuthorization() {
        guard authorizationStatus == .notDetermined else {
            return
        }

        locationManager.requestWhenInUseAuthorization()
    }

    func refreshAuthorizationStatus() {
        authorizationStatus =
            locationManager.authorizationStatus
    }

    @MainActor
    func openSettings() {
        guard let url = URL(
            string: UIApplication.openSettingsURLString
        ) else {
            return
        }

        UIApplication.shared.open(url)
    }

    // 현위치를 한 번만 요청
    func requestCurrentLocation() {
        guard isAuthorized, !isRequestingLocation else {
            return
        }

        isRequestingLocation = true
        locationError = nil

        locationManager.requestLocation()
    }

    // 위치를 계속 추적
    func startUpdatingLocation() {
        guard isAuthorized else {
            return
        }

        locationError = nil
        locationManager.startUpdatingLocation()
    }

    // 위치 추적 중지
    func stopUpdatingLocation() {
        locationManager.stopUpdatingLocation()
    }
}

extension LocationService: CLLocationManagerDelegate {
    func locationManagerDidChangeAuthorization(
        _ manager: CLLocationManager
    ) {
        authorizationStatus = manager.authorizationStatus

        switch authorizationStatus {
        case .authorizedWhenInUse, .authorizedAlways:
            requestCurrentLocation()

        case .denied, .restricted:
            manager.stopUpdatingLocation()

            isRequestingLocation = false
            currentLocation = nil

        case .notDetermined:
            break

        @unknown default:
            break
        }
    }

    func locationManager(
        _ manager: CLLocationManager,
        didUpdateLocations locations: [CLLocation]
    ) {
        guard let location = locations.last,
              location.horizontalAccuracy >= 0 else {
            return
        }

        currentLocation = location
        locationError = nil
        isRequestingLocation = false
    }

    func locationManager(
        _ manager: CLLocationManager,
        didFailWithError error: Error
    ) {
        locationError = error
        isRequestingLocation = false
    }
}
