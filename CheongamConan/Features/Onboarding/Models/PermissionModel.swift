//
//  PermissionModel.swift
//  CheongamConan
//
//  Created by 정홍섭 on 7/12/26.
//

import Foundation
import CoreLocation
import Observation

@MainActor
@Observable
final class PermissionModel {
    var isLocationSettingsAlertPresented: Bool = false

    private var hasStartedPermissionFlow = false // 사용자가 확인 버튼을 눌러 권한 흐름이 시작되었는지
    private var isWaitingForLocationAuthorizationResult: Bool = false
    private var isRequestingNotificationAuthorization: Bool = false
    private var hasCompleted: Bool = false
    
    func confirm(
        using locationService: LocationService,
        notificationService: NotificationService,
        onCompleted: () -> Void
    ) async {
        guard !hasCompleted else {
            return
        }

        hasStartedPermissionFlow = true

        switch locationService.authorizationStatus {
        case .notDetermined:
            isWaitingForLocationAuthorizationResult = true
            locationService.requestAuthorization()
            
        case .denied, .restricted:
            isLocationSettingsAlertPresented = true
            
        case .authorizedWhenInUse, .authorizedAlways:
            await requestNotificationAndComplete(
                using: notificationService,
                onCompleted: onCompleted
            )
            
        @unknown default:
            break
        }
    }
    
    func locationAuthorizationDidChange(
        using locationService: LocationService,
        notificationService: NotificationService,
        onCompleted: () -> Void
    ) async {
        guard hasStartedPermissionFlow, !hasCompleted else { return }
        switch locationService.authorizationStatus {
        case .authorizedWhenInUse, .authorizedAlways:
            isWaitingForLocationAuthorizationResult = false
            await requestNotificationAndComplete(
                using: notificationService,
                onCompleted: onCompleted
            )
            
        case .denied, .restricted:
            guard isWaitingForLocationAuthorizationResult else { return }
            
            isWaitingForLocationAuthorizationResult = false
            isLocationSettingsAlertPresented = true
            
        case .notDetermined:
            break
        
        @unknown default:
            isWaitingForLocationAuthorizationResult = false
        }
    }
    
    func appDidBecomeActive(
        using locationService: LocationService,
        notificationService: NotificationService,
        onCompleted: () -> Void
    ) async {
        guard hasStartedPermissionFlow, !hasCompleted else { return }
        locationService.refreshAuthorizationStatus()
        
        guard locationService.isAuthorized else { return }
        
        await requestNotificationAndComplete(
            using: notificationService,
            onCompleted: onCompleted
        )
    }
    
    func openSettings(using locationService: LocationService) {
        locationService.openSettings()
    }

    // 알림 권한 요청이 끝나면 온보딩 완료
    private func requestNotificationAndComplete(
        using notificationService: NotificationService,
        onCompleted: () -> Void
    ) async {
        guard !hasCompleted, !isRequestingNotificationAuthorization else {
            return
        }

        isRequestingNotificationAuthorization = true

        // 알림은 선택 권한이므로 결과와 관계없이 온보딩 완료
        _ = await notificationService.requestAuthorization()

        isRequestingNotificationAuthorization = false
        completeIfNeeded(onCompleted)
    }

    private func completeIfNeeded(_ onCompleted: () -> Void) {
        guard !hasCompleted else { return }
        
        hasCompleted = true
        onCompleted()
    }
}
