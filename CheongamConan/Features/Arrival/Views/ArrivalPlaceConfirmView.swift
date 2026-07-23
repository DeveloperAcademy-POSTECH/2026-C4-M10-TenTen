//
//  ArrivalPlaceConfirmView.swift
//  CheongamConan
//
//  Created by 정홍섭 on 7/19/26.
//

import SwiftUI
import SwiftData

struct ArrivalPlaceConfirmView: View {
    let place: String
    
    @Environment(MissionActivityManager.self)
    private var missionActivityManager
    @Environment(\.modelContext) private var modelContext
    @Environment(LocationService.self) private var locationService
    
    @State private var model = ArrivalPlaceSelectionModel()
    @State private var confirmModel = ArrivalPlaceConfirmModel()
    
    @State private var isShowRerecommendAlert: Bool = false
    @State private var isShowEndJourneyAlert: Bool = false
    
    @State private var isPresentedEndJourneyView: Bool = false
    
    private var isRecommendedPlace: Bool {
        model.recommendedPlace?.name == place
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: DSSpacing.spacing4) {
            Text(place)
                .font(DSTypography.H1)
                .foregroundStyle(isRecommendedPlace ? .main100 : .main300)
            
            Text("도착")
                .font(DSTypography.H3)
                .foregroundStyle(isRecommendedPlace ? .main100 : .main300)
            
            Spacer()
            
            HStack(spacing: DSSpacing.spacing12) {
                Button {
                    Task {
                        await missionActivityManager.end()
                    }
                    isShowEndJourneyAlert = true
                } label: {
                    Text("여행 종료하기")
                        .font(DSTypography.B2)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, DSSpacing.spacing16)
                        .foregroundStyle(isRecommendedPlace ? .main50 : .main300)
                }
                .overlay(
                    RoundedRectangle(cornerRadius: DSRadius.standard)
                        .inset(by: 1)
                        .stroke(
                            isRecommendedPlace ? .main50 : .main300,
                            lineWidth: 2
                        )
                )
                
                Button {
                    isShowRerecommendAlert = true
                } label: {
                    Text("다음 목적지 받기")
                }
                .buttonStyle(
                    DSButtonStyle(
                        backgroundColor: isRecommendedPlace ? .main100 : .main300,
                        foregroundColor: isRecommendedPlace ? .main300 : .neutralWhite,
                        font: DSTypography.B2
                    )
                )
            }
        }
        .padding(.horizontal, DSSpacing.contentHorizontal)
        .padding(.vertical, DSSpacing.spacing20)
        .background(isRecommendedPlace ? .main300 : .main100)
        .task {
            model.loadRecommendPlace(modelContext: modelContext)
        }
        .customAlert(
            isPresented: $isShowEndJourneyAlert,
            title: "여행을 종료하시겠어요?",
            primaryButtonTitle: "네",
            secondaryButtonTitle: "아니오",
            primaryAction: {
                try? confirmModel.endJourney(modelContext: modelContext)
                locationService.stopUpdatingLocation()
                
                isPresentedEndJourneyView = true
            },
            secondaryAction: {},
        )
        .navigationDestination(isPresented: $isPresentedEndJourneyView) {
            EndJourneyView()
        }
        .customAlert(
            isPresented: $isShowRerecommendAlert,
            title: "다음 목적지도 추천해드릴까요?",
            primaryButtonTitle: "네",
            secondaryButtonTitle: "아니오",
            primaryAction: {},
            secondaryAction: {},
        )
    }
}

#Preview {
    ArrivalPlaceConfirmView(place: "소디스")
        .environment(MissionActivityManager())
        .environment(LocationService())
}
