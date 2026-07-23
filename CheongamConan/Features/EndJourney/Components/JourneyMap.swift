//
//  JourneyMap.swift
//  CheongamConan
//
//  Created by 정홍섭 on 7/23/26.
//

import SwiftUI
import NMapsMap

struct JourneyMapView: View {
    let journeyList: [Journey]
    
    var body: some View {
        NaverMapView(
            coordinatorBuilder: {
                Coordinator()
            },
            onMake: { naverMapView, coordinator in
                configureMap(naverMapView)
                
                updateMarkers(
                    naverMapView: naverMapView,
                    coordinator: coordinator
                )
                
                moveCamera(
                    mapView: naverMapView.mapView
                )
            },
            onUpdate: { naverMapView, coordinator in
                updateMarkers(
                    naverMapView: naverMapView,
                    coordinator: coordinator
                )
            }
        )
    }
}

private extension JourneyMapView {
    private func configureMap(_ naverMapView: NMFNaverMapView) {
        let mapView = naverMapView.mapView
        
        mapView.maxZoomLevel = 15
        mapView.minZoomLevel = 5
        
        naverMapView.showLocationButton = false
        naverMapView.showZoomControls = false
        naverMapView.showCompass = false
        naverMapView.showScaleBar = false
        
        mapView.isZoomGestureEnabled = false
        mapView.isTiltGestureEnabled = false
        mapView.isRotateGestureEnabled = false
    }
}

private extension JourneyMapView {
    func updateMarkers(
        naverMapView: NMFNaverMapView,
        coordinator: Coordinator
    ) {
        coordinator.removeMarkers()
        
        coordinator.markers = journeyList.enumerated().map { index, journey in
            let marker = NMFMarker()
            
            marker.position = NMGLatLng(
                lat: journey.latitude,
                lng: journey.longitude
            )
            
            marker.iconImage = makeMarkerImage(
                number: String(index + 1),
                isComplete: journey.isComplete
            )
            
            marker.width = 20
            marker.height = 20
            marker.anchor = CGPoint(x: 0.5, y: 0.5)
            marker.mapView = naverMapView.mapView
            
            return marker
        }
    }
    
    func makeMarkerImage(
        number: String,
        isComplete: Bool
    ) -> NMFOverlayImage {
        let color: UIColor = .main300
        let textColor: UIColor = .main50
        
        let image = UIImage.circleMarker(
            number: number,
            fillColor: color,
            textColor: textColor
        )
        
        return NMFOverlayImage(image: image)
    }
}

private extension JourneyMapView {
    func moveCamera(mapView: NMFMapView) {
        guard !journeyList.isEmpty else {
            return
        }
        
        if journeyList.count == 1,
           let journey = journeyList.first {
            let position = NMGLatLng(
                lat: journey.latitude,
                lng: journey.longitude
            )
            
            let cameraUpdate = NMFCameraUpdate(
                scrollTo: position,
                zoomTo: 15
            )
            
            mapView.moveCamera(cameraUpdate)
            return
        }
        
        let latitudes = journeyList.map(\.latitude)
        let longitudes = journeyList.map(\.longitude)
        
        guard
            let minLatitude = latitudes.min(),
            let maxLatitude = latitudes.max(),
            let minLongitude = longitudes.min(),
            let maxLongitude = longitudes.max()
        else {
            return
        }
        
        let bounds = NMGLatLngBounds(
            southWest: NMGLatLng(
                lat: minLatitude,
                lng: minLongitude
            ),
            northEast: NMGLatLng(
                lat: maxLatitude,
                lng: maxLongitude
            )
        )
        
        let cameraUpdate = NMFCameraUpdate(
            fit: bounds,
            padding: 100
        )
        
        mapView.moveCamera(cameraUpdate)
    }
}

extension JourneyMapView {
    final class Coordinator: NSObject {
        var markers: [NMFMarker] = []
        
        func removeMarkers() {
            markers.forEach {
                $0.mapView = nil
            }
            
            markers.removeAll()
        }
    }
}
