//
//  AreaPolygonCoordinator.swift
//  CheongamConan
//
//  Created by 정홍섭 on 7/16/26.
//

import SwiftUI
import NMapsMap

@MainActor
final class AreaPolygonCoordinator: NSObject, NMFMapViewOptionDelegate {
    private weak var naverMapView: NMFNaverMapView?
    
    private var selectedAreaName: Binding<String?>
    private var isTrackingCurrentLocation: Bool = false
    
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
    
    func update(polygons: [MapPolygon], trackCurrentLocation: Bool) {
        guard let naverMapView else {
            return
        }
        
        updateTracking(
            trackCurrentLocation,
            on: naverMapView
        )
        
        renderer.render(polygons: polygons, on: naverMapView.mapView) { [weak self] areaName in
            self?.selectedAreaName.wrappedValue = areaName
        }
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
