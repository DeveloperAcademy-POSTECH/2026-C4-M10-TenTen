//
//  NaverMapView.swift
//  CheongamConan
//
//  Created by 정홍섭 on 7/13/26.
//

import SwiftUI
import UIKit
import NMapsMap

struct NaverMapView: UIViewRepresentable {
    let trackCurrentLocation: Bool
    let polygons: [MapPolygon]
    
    @Binding var selectedAreaName: String?

    init(
        trackCurrentLocation: Bool = false,
        polygons: [MapPolygon] = [],
        selectedAreaName: Binding<String?> = .constant(nil)
    ) {
        self.trackCurrentLocation = trackCurrentLocation
        self.polygons = polygons
        self._selectedAreaName = selectedAreaName
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(
            wasTrackingCurrentLocation: trackCurrentLocation,
            selectedAreaName: $selectedAreaName
        )
    }

    func makeUIView(
        context: Context
    ) -> NMFNaverMapView {
        let naverMapView = NMFNaverMapView(frame: .zero)
        let mapView = naverMapView.mapView
        
        mapView.setCustomStyleId(
            AppConfig.naverMapStyleID,
            loadHandler: {
                print("지도 스타일 로드 성공")
            },
            failHandler: { error in
                print("지도 스타일 로드 실패: \(error.localizedDescription)")
            }
        )

        context.coordinator.naverMapView =
            naverMapView

        mapView.addOptionDelegate(
            delegate: context.coordinator
        )

        naverMapView.showLocationButton = false
        mapView.logoInteractionEnabled = false
        
        naverMapView.showZoomControls = false
        mapView.isZoomGestureEnabled = true

        context.coordinator.render(
            polygons: polygons,
            on: mapView
        )

        if trackCurrentLocation {
            DispatchQueue.main.async {
                mapView.positionMode = .direction
            }
        }

        return naverMapView
    }

    func updateUIView(
        _ naverMapView: NMFNaverMapView,
        context: Context
    ) {
        let mapView = naverMapView.mapView
        let coordinator = context.coordinator

        coordinator.isTrackingEnabled =
            trackCurrentLocation

        coordinator.render(
            polygons: polygons,
            on: mapView
        )

        guard coordinator.wasTrackingCurrentLocation
                != trackCurrentLocation else {
            return
        }

        coordinator.wasTrackingCurrentLocation =
            trackCurrentLocation

        if trackCurrentLocation {
            naverMapView.showLocationButton = false
            mapView.positionMode = .direction
        } else {
            naverMapView.showLocationButton = false
            mapView.positionMode = .disabled
        }
    }

    final class Coordinator:
        NSObject,
        NMFMapViewOptionDelegate
    {
        weak var naverMapView: NMFNaverMapView?

        var wasTrackingCurrentLocation: Bool
        var isTrackingEnabled: Bool

        private var renderedPolygons: [MapPolygon] = []
        private var polygonOverlays: [NMFPolygonOverlay] = []
        
        private weak var selectedOverlay: NMFPolygonOverlay?
        private var selectedAreaName: Binding<String?>

        init(
            wasTrackingCurrentLocation: Bool,
            selectedAreaName: Binding<String?>
        ) {
            self.wasTrackingCurrentLocation = wasTrackingCurrentLocation

            self.isTrackingEnabled = wasTrackingCurrentLocation
            
            self.selectedAreaName = selectedAreaName
        }

        func mapViewOptionChanged(
            _ mapView: NMFMapView
        ) {
            guard isTrackingEnabled else {
                naverMapView?.showLocationButton = false
                return
            }

            naverMapView?.showLocationButton =
                mapView.positionMode == .normal
        }

        func render(
            polygons: [MapPolygon],
            on mapView: NMFMapView
        ) {
            guard renderedPolygons != polygons else {
                return
            }

            removePolygonOverlays()

            for polygonData in polygons {
                guard let overlay = makeOverlay(
                    from: polygonData
                ) else {
                    continue
                }

                applyDefaultStyle(to: overlay)

                overlay.userInfo = [
                    "areaName": polygonData.name
                ]

                overlay.touchHandler = { [weak self] touchedOverlay in
                    guard
                        let self,
                        let polygonOverlay =
                            touchedOverlay as? NMFPolygonOverlay,
                        let areaName =
                            touchedOverlay.userInfo["areaName"] as? String
                    else {
                        return false
                    }

                    self.select(
                        polygonOverlay,
                        areaName: areaName
                    )

                    return true
                }

                overlay.mapView = mapView
                polygonOverlays.append(overlay)
            }

            renderedPolygons = polygons
        }

        private func makeOverlay(
            from polygonData: MapPolygon
        ) -> NMFPolygonOverlay? {
            var coordinates = polygonData.exteriorRing

            guard coordinates.count >= 3 else {
                return nil
            }

            if coordinates.first == coordinates.last {
                coordinates.removeLast()
            }

            guard coordinates.count >= 3 else {
                return nil
            }

            if signedArea(coordinates) > 0 {
                coordinates.reverse()
            }

            guard let firstCoordinate = coordinates.first else {
                return nil
            }

            coordinates.append(firstCoordinate)

            let points: [NMGLatLng] = coordinates.map { coordinate in
                NMGLatLng(
                    lat: coordinate.latitude,
                    lng: coordinate.longitude
                )
            }

            return NMFPolygonOverlay(points)
        }

        private func signedArea(
            _ coordinates: [MapCoordinate]
        ) -> Double {
            guard coordinates.count >= 3 else {
                return 0
            }

            var result = 0.0

            for index in coordinates.indices {
                let nextIndex =
                    (index + 1) % coordinates.count

                let current = coordinates[index]
                let next = coordinates[nextIndex]

                result +=
                    current.longitude * next.latitude
                    - next.longitude * current.latitude
            }

            return result / 2
        }

        private func removePolygonOverlays() {
            polygonOverlays.forEach {
                $0.mapView = nil
            }

            polygonOverlays.removeAll()
            selectedOverlay = nil

            DispatchQueue.main.async {
                self.selectedAreaName.wrappedValue = nil
            }
        }
        
        private func select(
            _ overlay: NMFPolygonOverlay,
            areaName: String
        ) {
            if selectedOverlay === overlay {
                applyDefaultStyle(to: overlay)
                selectedOverlay = nil

                DispatchQueue.main.async {
                    self.selectedAreaName.wrappedValue = nil
                }

                return
            }

            if let selectedOverlay {
                applyDefaultStyle(to: selectedOverlay)
            }

            applySelectedStyle(to: overlay)
            selectedOverlay = overlay

            DispatchQueue.main.async {
                self.selectedAreaName.wrappedValue = areaName
            }
        }

        private func applyDefaultStyle(
            to overlay: NMFPolygonOverlay
        ) {
            overlay.fillColor =
                UIColor.systemBlue.withAlphaComponent(0.18)

            overlay.outlineColor =
                UIColor.systemBlue.withAlphaComponent(0.8)

            overlay.outlineWidth = 1
        }

        private func applySelectedStyle(
            to overlay: NMFPolygonOverlay
        ) {
            overlay.fillColor =
                UIColor.systemBlue.withAlphaComponent(0.4)

            overlay.outlineColor =
                UIColor.systemBlue

            overlay.outlineWidth = 2
        }
    }
}
