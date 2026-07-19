//
//  AreaPolygonCoordinator.swift
//  CheongamConan
//
//  Created by 정홍섭 on 7/16/26.
//

import SwiftUI
import NMapsMap
import CoreLocation

@MainActor
final class AreaPolygonCoordinator: NSObject, NMFMapViewOptionDelegate {
    private weak var naverMapView: NMFNaverMapView?
    
    private var selectedAreaName: Binding<String?>
    private var isTrackingCurrentLocation: Bool = false
    private var hasCenteredCurrentLocation: Bool = false
    
    private let renderer = AreaPolygonRenderer()
    
    init(selectedAreaName: Binding<String?>) {
        self.selectedAreaName = selectedAreaName
    }
    
    func connect(to naverMapView: NMFNaverMapView) {
        guard self.naverMapView !== naverMapView else {
            return
        }
        
        self.naverMapView = naverMapView
        
        naverMapView.mapView.addOptionDelegate(delegate: self)
    }
    
    func update(polygons: [MapPolygon], currentLocation: CLLocation?, trackCurrentLocation: Bool) {
        guard let naverMapView else {
            return
        }
        
        if let currentLocation {
            updateCurrentLocation(
                currentLocation,
                on: naverMapView.mapView
            )
        }
        
        updateTracking(
            trackCurrentLocation,
            on: naverMapView
        )
        
        renderer.render(polygons: polygons, on: naverMapView.mapView) { [weak self] areaName in
            self?.selectedAreaName.wrappedValue = areaName
        }
    }
    
    private func updateCurrentLocation(_ location: CLLocation, on mapView: NMFMapView) {
        let coordinate = NMGLatLng(
            lat: location.coordinate.latitude,
            lng: location.coordinate.longitude
        )
        
        let locationOverlay = mapView.locationOverlay
        
        locationOverlay.location = coordinate
        locationOverlay.hidden = false
        
        guard !hasCenteredCurrentLocation else {
            return
        }
        
        let cameraUpdate = NMFCameraUpdate(
            scrollTo: coordinate,
            zoomTo: 15
        )
        
        mapView.moveCamera(cameraUpdate)
        
        hasCenteredCurrentLocation = true
    }
    
    func mapViewOptionChanged(_ mapView: NMFMapView) {
        guard isTrackingCurrentLocation else {
            naverMapView?.showLocationButton = false
            return
        }
        
        naverMapView?.showLocationButton = mapView.positionMode == .normal
    }
}

private extension AreaPolygonCoordinator{
    func updateTracking(_ isEnabled: Bool, on naverMapView: NMFNaverMapView) {
        guard isTrackingCurrentLocation != isEnabled else {
            return
        }
        
        isTrackingCurrentLocation = isEnabled
        
        naverMapView.mapView.positionMode = isEnabled ? .direction : .disabled
    }
}
