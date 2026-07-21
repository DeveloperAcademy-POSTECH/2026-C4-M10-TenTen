//
//  DestinationmapCoordinator.swift
//  CheongamConan
//
//  Created by 정홍섭 on 7/20/26.
//

import Foundation
import NMapsMap

final class DestinationmapCoordinator: NSObject {
    private let marker = NMFMarker()
    private var displayedPlaceKey: String?
    
    func update(name: String, latitude: Double, longitude: Double, on naverMapView: NMFNaverMapView) {
        let placeKey = "\(name)-\(latitude)-\(longitude)"
        let position = NMGLatLng(lat: latitude, lng: longitude)
        
        updateMarker(name: name, position: position, mapView: naverMapView.mapView)
        
        guard displayedPlaceKey != placeKey else { return }
        
        displayedPlaceKey = placeKey
        
        moveCamera(to: position, mapView: naverMapView.mapView)
    }
    
    private func updateMarker(name: String, position: NMGLatLng, mapView: NMFMapView) {
        marker.position = position
        marker.captionText = name
        marker.mapView = mapView
    }
    
    private func moveCamera(to position: NMGLatLng, mapView: NMFMapView) {
        let cameraUpdate = NMFCameraUpdate(
            scrollTo: position,
            zoomTo: 14.5
        )
        
        cameraUpdate.animation = .easeIn
        cameraUpdate.animationDuration = 0.5
        
        mapView.moveCamera(cameraUpdate)
    }
}
