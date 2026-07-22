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
    
    private var selectedAreaText: String {
        guard let selectedAreaName else {
            return "지역을 선택해 주세요"
        }
        
        return AreaNameFormatter.format(selectedAreaName)
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            VStack(alignment: .leading, spacing: 21) {
                Text("오늘은 어느 지역을\n여행하고 싶으신가요?")
                    .font(DSTypography.H4)
                    .foregroundStyle(.neutralBlack)
                
                AreaPickerMapView(
                    currentLocation: locationService.currentLocation,
                    trackCurrentLocation: locationService.isAuthorized,
                    polygons: model.polygons,
                    selectedAreaName: $selectedAreaName
                )
                .cornerRadius(DSRadius.standard)
                .frame(maxWidth: .infinity, maxHeight: 369)
            }
            
            Spacer()
            
            VStack(alignment: .leading, spacing: DSSpacing.spacing52) {
                VStack(alignment: .leading, spacing: DSSpacing.spacing4) {
                    Text("현재 선택지")
                        .font(DSTypography.B2)
                        .foregroundStyle(.grey700)
                    
                    Text(selectedAreaText)
                        .font(DSTypography.H2)
                }
                
                Button("선택하기") {
                    guard let selectedAreaName else {
                        return
                    }
                    
                    setupModel.selectArea(selectedAreaName)
                    isCategoryPresented = true
                }
                .buttonStyle(
                    DSButtonStyle(
                        backgroundColor: .main300,
                        foregroundColor: .neutralWhite
                    )
                )
                .disabled(selectedAreaName == nil)
            }
            
        }
        .padding(.top, 67)
        .padding(.bottom, 20)
        .padding(.horizontal, DSSpacing.contentHorizontal)
        .navigationBarBackButtonHidden()
        .navigationDestination(
            isPresented: $isCategoryPresented
        ) {
            CategoryView(setupModel: setupModel)
        }
        .task {
            locationService.requestCurrentLocation()
        }
        .task(id: locationService.currentLocation?.timestamp) {
            await model.locationDidChange(locationService.currentLocation)
        }
    }
}

#Preview {
    AreaPickerView(setupModel: TravelSetupModel())
        .environment(LocationService())
}

