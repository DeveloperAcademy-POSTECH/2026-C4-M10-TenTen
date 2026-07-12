//
//  PermissionModel.swift
//  CheongamConan
//
//  Created by 정홍섭 on 7/12/26.
//

import Foundation
import CoreLocation
import Observation

@Observable
final class PermissionModel {
    var isSettingsAlertPresented: Bool = false
    
    private var isWaitingForAuthorizationResult: Bool = false
    private var hasCompleted: Bool = false
    
    func confirm(
        using locationService: LocationService,
        onCompleted: () -> Void
    ) {
        switch locationService.authorizationStatus {
        case .notDetermined:
            isWaitingForAuthorizationResult = true
            locationService.requestAuthorization()
            
        case .denied, .restricted:
            isSettingsAlertPresented = true
            
        case .authorizedWhenInUse, .authorizedAlways:
            completeIfNeeded(onCompleted)
            
        @unknown default:
            break
        }
    }
    
    func authorizationDidChange(
        using locationService: LocationService,
        onCompleted: () -> Void
    ) {
        switch locationService.authorizationStatus {
        case .authorizedWhenInUse, .authorizedAlways:
            isWaitingForAuthorizationResult = false
            completeIfNeeded(onCompleted)
            
        case .denied, .restricted:
            guard isWaitingForAuthorizationResult else { return }
            
            isWaitingForAuthorizationResult = false
            isSettingsAlertPresented = true
            
        case .notDetermined:
            break
        
        @unknown default:
            isWaitingForAuthorizationResult = false
        }
    }
    
    func appDidBecomeActive(
        using locationService: LocationService,
        onCompleted: () -> Void
    ) {
        locationService.refreshAuthorizationStatus()
        
        guard locationService.isAuthorized else { return }
        
        completeIfNeeded(onCompleted)
    }
    
    @MainActor
    func openSettings(using locationService: LocationService) {
        locationService.openSettings()
    }
    
    private func completeIfNeeded(_ onCompleted: () -> Void) {
        guard !hasCompleted else { return }
        
        hasCompleted = true
        onCompleted()
    }
}
