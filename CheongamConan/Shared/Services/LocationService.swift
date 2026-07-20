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

/// Core Location 권한과 위치 업데이트를 관리한다
/// 여행 경로 저장, 서브 퀘스트 조건 판단은 담당하지 않는다
@MainActor
@Observable
final class LocationService: NSObject {
    private let locationManager = CLLocationManager()

    private var wantsBackgroundLocationUpdates = false

    private(set) var authorizationStatus: CLAuthorizationStatus
    private(set) var currentLocation: CLLocation?
    private(set) var locationError: Error?
    private(set) var isUpdatingLocation = false
    private(set) var isRequestingCurrentLocation = false

    // 수신한 위치 묶음을 여행 추적 모델에 전달한다
    // 현재는 하나의 소비자만 등록할 수 있다
    var onLocationsReceived: (([CLLocation]) -> Void)?
    
    override init() {
        authorizationStatus = locationManager.authorizationStatus

        super.init()

        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        // 10m 이상의 이동이 발생하면 업데이트를 요청
        // 실제로 정확히 10m마다 전달되는 것은 보장하지 않는다
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

    func requestAlwaysAuthorization() {
        guard authorizationStatus == .authorizedWhenInUse else {
            return
        }

        locationManager.requestAlwaysAuthorization()
    }

    func refreshAuthorizationStatus() {
        authorizationStatus =
            locationManager.authorizationStatus
    }

    // 사용자가 앱 설정에서 위치 권한을 변경할 수 있도록 설정 화면을 연다
    func openSettings() {
        guard let url = URL(
            string: UIApplication.openSettingsURLString
        ) else {
            return
        }

        UIApplication.shared.open(url)
    }

    // 연속 위치 추적을 시작하지 않고 현재 위치를 한 번 요청한다
    // 결과는 delegate의 didUpdateLocations에서 비동기로 전달된다
    func requestCurrentLocation() {
        guard isAuthorized, !isRequestingCurrentLocation else {
            return
        }

        isRequestingCurrentLocation = true
        locationError = nil

        locationManager.requestLocation()
    }

    // 여행 세션 동안 Standard Location Updates를 시작한다
    func startUpdatingLocation(
        allowsBackgroundUpdates: Bool = false
    ) {
        guard isAuthorized else {
            return
        }
        wantsBackgroundLocationUpdates = allowsBackgroundUpdates
        isUpdatingLocation = true

        updateBackgroundLocationConfiguration()
        locationManager.startUpdatingLocation()
    }

    // 여행 종료 또는 위치 권한 철회시 Standard Location Updates를 중지한다
    func stopUpdatingLocation() {
        isUpdatingLocation = false
        wantsBackgroundLocationUpdates = false
        locationManager.stopUpdatingLocation()
        updateBackgroundLocationConfiguration()
    }

    private func updateBackgroundLocationConfiguration() {
        let canUseBackgroundUpdates =
        wantsBackgroundLocationUpdates &&
        authorizationStatus == .authorizedAlways

        locationManager.allowsBackgroundLocationUpdates = canUseBackgroundUpdates

        locationManager.showsBackgroundLocationIndicator = canUseBackgroundUpdates
    }
}

extension LocationService: CLLocationManagerDelegate {
    // Core Location이 위치 권한 상태 변경을 전달할 때 호출된다
    func locationManagerDidChangeAuthorization(
        _ manager: CLLocationManager
    ) {
        authorizationStatus = manager.authorizationStatus
        
        switch authorizationStatus {
        case .authorizedAlways, .authorizedWhenInUse:
            updateBackgroundLocationConfiguration()

        case .denied, .restricted:
            stopUpdatingLocation()
        
        case .notDetermined:
            break
            
        @unknown default:
            break
        }
    }

    // Core Location이 한 번에 전달한 위치 묶음을 처리한다
    // 최신 위치는 UI 상태에 보관하고, 전체 배열은 경로 기록용으로 전달한다
    func locationManager(
        _ manager: CLLocationManager,
        didUpdateLocations locations: [CLLocation]
    ) {
        isRequestingCurrentLocation = false // 위치 수신 시 일회성 요청 상태 종료
        self.currentLocation = currentLocation
        locationError = nil
        onLocationsReceived?(locations)

        guard let currentLocation = locations.last else {
            return
        }
        self.currentLocation = currentLocation
        locationError = nil

        onLocationsReceived?(locations)
    }
    
    // 오류가 발생한 경우, 즉시 추적을 종료하지 않고 상태만 기록한다
    func locationManager(
        _ manager: CLLocationManager,
        didFailWithError error: Error
    ) {
        locationError = error
        isRequestingCurrentLocation = false
    }
}

