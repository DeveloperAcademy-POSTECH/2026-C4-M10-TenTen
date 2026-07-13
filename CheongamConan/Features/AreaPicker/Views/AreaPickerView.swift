//
//  AreaPickerView.swift
//  CheongamConan
//
//  Created by 정홍섭 on 7/12/26.
//

import SwiftUI
import CoreLocation

struct AreaPickerView: View {
    @Environment(LocationService.self)
    private var locationService
    
    @State
    private var model = AreaPickerModel()
    
    @State
    private var selectedAreaName: String?
    
    var body: some View {
        ZStack(alignment: .bottom) {
            NaverMapView(
                trackCurrentLocation:
                    locationService.isAuthorized,
                polygons: model.polygons,
                selectedAreaName: $selectedAreaName
            )
            .ignoresSafeArea()
            
            if let selectedAreaName {
                Text(selectedAreaName)
                    .font(.headline)
            }
        }
        .task {
            locationService.requestCurrentLocation()
        }
        .task(
            id: locationService.currentLocation?.timestamp
        ) {
            guard let coordinate =
                    locationService.currentLocation?.coordinate else {
                return
            }
            
            await model.loadAreas(
                around: coordinate
            )
        }
    }
}
#Preview {
    AreaPickerView()
        .environment(LocationService())
}
