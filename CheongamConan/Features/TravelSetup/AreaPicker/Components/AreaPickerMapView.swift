//
//  AreaPickerMapView.swift
//  CheongamConan
//
//  Created by 정홍섭 on 7/16/26.
//

import SwiftUI
import NMapsMap

struct AreaPickerMapView: View {
    let trackCurrentLocation: Bool
    let polygons: [MapPolygon]
    
    @Binding var selectedAreaName: String?
    
    var body: some View {
        NaverMapView(
            coordinatorBuilder: {
                AreaPolygonCoordinator(
                    selectedAreaName: $selectedAreaName
                )
            },
            onMake: { naverMapView, coordinator in
                coordinator.connect(to: naverMapView)
                
                coordinator.update(
                    polygons: polygons,
                    trackCurrentLocation: trackCurrentLocation
                )
            },
            onUpdate: { naverMapView, coordinator in
                coordinator.connect(
                    to: naverMapView
                )
                
                coordinator.update(
                    polygons: polygons,
                    trackCurrentLocation:
                        trackCurrentLocation
                )
            }
        )
    }
}

#Preview {
    AreaPickerMapView(
        trackCurrentLocation: false,
        polygons: [],
        selectedAreaName: .constant(nil)
    )
}
