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
    let routePoints: [JourneyRoutePoint]
    
    init(
        journeyList: [Journey],
        routePoints: [JourneyRoutePoint] = []
    ) {
        self.journeyList = journeyList
        self.routePoints = routePoints
    }
    
    
    var body: some View {
        NaverMapView(
            coordinatorBuilder: {
                Coordinator()
            },
            onMake: { naverMapView, coordinator in
                configureMap(naverMapView)
                
                updateRoutePath(
                    naverMapView: naverMapView,
                    coordinator: coordinator
                )
                
                updateMarkers(
                    naverMapView: naverMapView,
                    coordinator: coordinator
                )
                
                moveCamera(
                    mapView: naverMapView.mapView
                )
            },
            onUpdate: { naverMapView, coordinator in
                updateRoutePath(
                    naverMapView: naverMapView,
                    coordinator: coordinator
                )
                
                updateMarkers(
                    naverMapView: naverMapView,
                    coordinator: coordinator
                )
                
                moveCamera(
                    mapView: naverMapView.mapView
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
        let routeCoordinates:
        [(latitude: Double, longitude: Double)] =
        routePoints.map {
            (
                latitude: $0.latitude,
                longitude: $0.longitude
            )
        }
        
        let destinationCoordinates:
        [(latitude: Double, longitude: Double)] =
        journeyList.map {
            (
                latitude: $0.latitude,
                longitude: $0.longitude
            )
        }
        
        let allCoordinates =
        routeCoordinates + destinationCoordinates
        
        guard !allCoordinates.isEmpty else {
            return
        }
        
        if allCoordinates.count == 1,
           let coordinate = allCoordinates.first {
            let position = NMGLatLng(
                lat: coordinate.latitude,
                lng: coordinate.longitude
            )
            
            let cameraUpdate = NMFCameraUpdate(
                scrollTo: position,
                zoomTo: 15
            )
            
            mapView.moveCamera(cameraUpdate)
            return
        }
        
        let latitudes = allCoordinates.map(\.latitude)
        let longitudes = allCoordinates.map(\.longitude)
        
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
        var routePath: NMFPath?
        
        func removeMarkers() {
            markers.forEach {
                $0.mapView = nil
            }
            
            markers.removeAll()
        }
        
        func removeRoutePath() {
            routePath?.mapView = nil
            routePath = nil
        }
    }
}

private extension JourneyMapView {
    func updateRoutePath(
        naverMapView: NMFNaverMapView,
        coordinator: Coordinator
    ) {
        coordinator.removeRoutePath()
        
        let coordinates = routePoints.map { point in
            NMGLatLng(
                lat: point.latitude,
                lng: point.longitude
            )
        }
        
        guard coordinates.count >= 2 else { return }
        
        let routePath = NMFPath()
        
        routePath.path = NMGLineString(
            points: coordinates
        )
        
        routePath.width = 4
        routePath.outlineWidth = 0
        
        routePath.color = .main300
        routePath.outlineColor = .clear
        
        routePath.mapView = naverMapView.mapView
        
        coordinator.routePath = routePath
    }
}
