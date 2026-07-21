//
//  JourneyView.swift
//  CheongamConan
//
//  Created by Dayoon Lee on 7/18/26.
//

import SwiftUI
import SwiftData

@MainActor
struct JourneyView: View {
    let area: String
    let category: String
    
    @Environment(LocationService.self) private var locationService
    @Environment(NotificationService.self) private var notificationService
    @Environment(\.modelContext) private var modelContext
    
    @State private var model: JourneyModel
    @State private var destinationModel = DestinationModel()
    @State private var cameraSubQuest: SubQuest?
    @State private var isShowDestinationArrivalAlert = false
    @State private var isShowArrivalView = false
    @State private var journeySession: JourneySession?
    
    init(
        area: String,
        category: String,
        journeySession: JourneySession? = nil,
        initialDestination: RecommendedPlace? = nil
    ) {
        self.area = area
        self.category = category
        
        _journeySession = State(
            initialValue: journeySession
        )
        
        _model = State(
            initialValue: JourneyModel(
                destination: initialDestination
                ?? journeySession?.destination
            )
        )
    }
    
    var body: some View {
        Group {
            if let destination = model.destination {
                journeyContent(destination: destination)
            }
        }
        .task {
            await loadDestinationIfNeeded()
        }
        .fullScreenCover(item: $cameraSubQuest) { subQuest in
            cameraPicker(for: subQuest)
        }
        .navigationBarBackButtonHidden()
        .customAlert(
            isPresented: $isShowDestinationArrivalAlert,
            title: "목적지에 도착하셨나요?",
            content: "\(model.destination?.name ?? "")(이)가 아니어도 괜찮아요",
            primaryButtonTitle: "도착했어요",
            secondaryButtonTitle: "가는 중이에요",
            primaryAction: {
                moveToArrival()
            },
            secondaryAction: {}
        )
        .navigationDestination(isPresented: $isShowArrivalView) {
            ArrivalPlaceSelectionView()
        }
    }
    
    private func journeyContent(destination: RecommendedPlace) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            destinationHeader(destination: destination)
                .padding(.leading)
            
            destinationMap(destination: destination)
                .padding(.top, DSSpacing.spacing8)
            
            SubQuestCard(
                state: subQuestCardState,
                onCameraTap: { subQuest in
                    cameraSubQuest = subQuest
                }
            )
            .padding(.top, DSSpacing.spacing48)
            
            destinationArrivalButton
                .padding(.top, DSSpacing.spacing28)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.top, DSSpacing.spacing52)
        .padding(.bottom, DSSpacing.spacing20)
        .padding(.horizontal, DSSpacing.contentHorizontal)
    }
    
    private func destinationHeader(destination: RecommendedPlace) -> some View {
        VStack(alignment: .leading, spacing: DSSpacing.spacing4) {
            Text("오늘 이곳을 찾아 떠나는 거 어때요?")
                .font(DSTypography.C2)
            
            Text(destination.name)
                .font(DSTypography.H3)
            
            Text(destination.roadAddress)
                .font(DSTypography.C3)
                .foregroundStyle(.grey600)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    private func destinationMap(destination: RecommendedPlace) -> some View {
        NaverMapView(
            coordinatorBuilder: {
                DestinationmapCoordinator()
            },
            onMake: { naverMapView, coordinator in
                coordinator.update(
                    name: destination.name,
                    latitude: destination.latitude,
                    longitude: destination.longitude,
                    on: naverMapView
                )
            },
            onUpdate: { naverMapView, coordinator in
                coordinator.update(
                    name: destination.name,
                    latitude: destination.latitude,
                    longitude: destination.longitude,
                    on: naverMapView
                )
            }
        )
        .frame(maxWidth: .infinity)
        .aspectRatio(
            362.0 / 369.0,
            contentMode: .fill
        )
        .clipShape(
            RoundedRectangle(
                cornerRadius: DSRadius.standard
            )
        )
    }
    
    private var destinationArrivalButton: some View {
        Button {
            isShowDestinationArrivalAlert = true
        } label: {
            Text("목적지 도착")
                .font(DSTypography.B1)
                .foregroundStyle(.neutralWhite)
                .frame(maxWidth: .infinity)
                .padding(.vertical, DSSpacing.spacing16)
                .background(.main300)
                .clipShape(
                    RoundedRectangle(
                        cornerRadius: DSRadius.standard
                    )
                )
        }
    }
    
    private var subQuestCardState: SubQuestCard.State {
        guard let subQuest = model.trackingModel.activeSubQuest else {
            return .locked
        }
        
        if subQuest.isCompleted {
            return .completed(subQuest)
        }
        
        return .active(subQuest)
    }
    
    private func loadDestinationIfNeeded() async {
        if model.destination == nil {
            if let savedDestination = journeySession?.destination {
                model.updateDestination(savedDestination)
            } else {
                await destinationModel.loadOrRecommend(
                    area: area,
                    category: category,
                    modelContext: modelContext
                )
                
                guard let destination = destinationModel.recommendedPlace else {
                    return
                }
                
                model.updateDestination(destination)
            }
        }
        
        guard let destination = model.destination else {
            return
        }
        
        createJourneySessionIfNeeded(
            destination: destination
        )
        
        model.startJourneyIfNeeded(
            locationService: locationService,
            notificationService: notificationService
        )
    }
    private func cameraPicker(
        for subQuest: SubQuest
    ) -> some View {
        CameraPicker(
            onCapture: {
                model.trackingModel.completeSubQuest(
                    id: subQuest.id
                )
                cameraSubQuest = nil
            },
            onCancel: {
                cameraSubQuest = nil
            }
        )
    }
    
    private func createJourneySessionIfNeeded(
        destination: RecommendedPlace
    ) {
        guard journeySession == nil else { return }
        
        let session = JourneySession(
            area: area,
            category: category,
            destination: destination
        )
        
        modelContext.insert(session)
        
        try? modelContext.save()
        journeySession = session
    }
    
    private func moveToArrival() {
        guard let journeySession else { return }
        
        guard journeySession.phase == .journey else {
            return
        }
        
        journeySession.arrive()
        
        try? modelContext.save()
        isShowArrivalView = true
    }
}

#Preview {
    JourneyView(
        area: "포항시 지곡동",
        category: "카페",
        initialDestination: .preview
    )
    .environment(LocationService())
    .environment(NotificationService())
}
