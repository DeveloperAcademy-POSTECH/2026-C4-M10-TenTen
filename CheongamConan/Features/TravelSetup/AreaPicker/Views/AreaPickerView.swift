//
//  AreaPickerView.swift
//  CheongamConan
//
//  Created by 정홍섭 on 7/12/26.
//

import SwiftUI
import CoreLocation

struct AreaPickerView: View {
    let setupModel: TravelSetupModel
    
    @Environment(LocationService.self) private var locationService
    
    @State private var model = AreaPickerModel()
    @State private var selectedAreaName: String?
    @State private var isCategoryPresented = false
    
    var body: some View {
        ZStack(alignment: .bottom) {
            NaverMapView(
                trackCurrentLocation: locationService.isAuthorized,
                polygons: model.polygons,
                selectedAreaName: $selectedAreaName
            )
            .ignoresSafeArea()
            
            VStack(spacing: 20) {
                if let selectedAreaName {
                    Text(selectedAreaName)
                        .font(.headline)
                }
                
                Button("선택하기") {
                    guard let selectedAreaName else {
                        return
                    }
                    
                    setupModel.selectArea(selectedAreaName)
                    isCategoryPresented = true
                }
                .disabled(selectedAreaName == nil)
            }
        }
        .navigationBarBackButtonHidden()
        .navigationDestination(
            isPresented: $isCategoryPresented
        ) {
            CategoryView(setupModel: setupModel)
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
    AreaPickerView(setupModel: TravelSetupModel())
        .environment(LocationService())
}

