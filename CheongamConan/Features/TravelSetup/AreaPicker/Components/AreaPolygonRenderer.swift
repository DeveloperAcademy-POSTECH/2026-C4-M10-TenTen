//
//  AreaPolygonRenderer.swift
//  CheongamConan
//
//  Created by 정홍섭 on 7/16/26.
//

import UIKit
import NMapsMap

@MainActor
final class AreaPolygonRenderer {
    private var renderedPolygons: [MapPolygon] = []
    private var overlays: [NMFPolygonOverlay] = []
    
    private weak var selectedOverlay: NMFPolygonOverlay?
    
    func render(
        polygons: [MapPolygon],
        on mapView: NMFMapView,
        onSelectionChanged: @escaping (String?) -> Void
    ) {
        guard renderedPolygons != polygons else { return }
        
        removeAll()
        
        for polygon in polygons {
            guard let overlay = makeOverlay(from: polygon) else {
                continue
            }
            
            applyDefaultStyle(to: overlay)
            
            overlay.touchHandler = {
                [weak self] touchedOverlay in
                
                guard
                    let self,
                    let polygonOverlay = touchedOverlay as? NMFPolygonOverlay
                else {
                    return false
                }
                
                select(polygonOverlay, areaName: polygon.name, onSelectionChanged: onSelectionChanged)
                
                return true
            }
            
            overlay.mapView = mapView
            overlays.append(overlay)
        }
        
        renderedPolygons = polygons
    }
    
    private func removeAll() {
        overlays.forEach {
            $0.mapView = nil
        }
        
        overlays.removeAll()
        selectedOverlay = nil
    }
}

private extension AreaPolygonRenderer {
    func select(
        _ overlay: NMFPolygonOverlay,
        areaName: String,
        onSelectionChanged: (String?) -> Void
    ) {
        if selectedOverlay === overlay {
            applyDefaultStyle(to: overlay)
            
            selectedOverlay = nil
            onSelectionChanged(nil)
            
            return
        }
        
        if let selectedOverlay {
            applyDefaultStyle(to: selectedOverlay)
        }
        
        applySelectedStyle(to: overlay)
        
        selectedOverlay = overlay
        onSelectionChanged(areaName)
    }
    
    func makeOverlay(from polygon: MapPolygon) -> NMFPolygonOverlay? {
        var coordinates = polygon.exteriorRing
        
        guard coordinates.count >= 3 else {
            return nil
        }
        
        if coordinates.first == coordinates.last {
            coordinates.removeLast()
        }
        
        guard coordinates.count >= 3 else {
            return nil
        }
        
        if signedArea(of: coordinates) > 0 {
            coordinates.reverse()
        }
        
        guard let firstCoordinate = coordinates.first else {
            return nil
        }
        
        coordinates.append(firstCoordinate)
        
        let points = coordinates.map {
            NMGLatLng(lat: $0.latitude, lng: $0.longitude)
        }
        
        return NMFPolygonOverlay(points)
    }
    
    func signedArea(of coordinates: [MapCoordinate]) -> Double {
        guard coordinates.count >= 3 else {
            return 0
        }
        
        var area = 0.0
        
        for index in coordinates.indices {
            let nextIndex = (index + 1) % coordinates.count
            let current = coordinates[index]
            let next = coordinates[nextIndex]
            
            area += current.longitude * next.latitude - next.longitude * current.latitude
        }
        
        return area / 2
    }
    
    func applyDefaultStyle(to overlay: NMFPolygonOverlay) {
        overlay.fillColor = .grey250.withAlphaComponent(0.56)
        
        overlay.outlineColor = .grey300
        
        overlay.outlineWidth = 2
    }
    
    func applySelectedStyle(to overlay: NMFPolygonOverlay) {
        overlay.fillColor = .main300.withAlphaComponent(0.56)
        
        overlay.outlineColor = .grey300
        
        overlay.outlineWidth = 2
    }
}
