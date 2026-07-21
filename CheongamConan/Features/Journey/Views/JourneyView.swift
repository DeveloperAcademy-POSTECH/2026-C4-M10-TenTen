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
    @Environment(MissionActivityManager.self) private var missionActivityManager
    @Environment(\.modelContext) private var modelContext
    
    // 여행 및 미션 저장 로직
    @State private var model: JourneyModel
    @State private var missionStorageModel = MissionStorageModel()
    
    // 현재 진행중인 여행
    @State private var journeySession: JourneySession?
    
    // 목적지 조회
    @State private var destinationModel = DestinationModel()
    
    // 카메라 (미션 인증)
    @State private var cameraSubQuest: SubQuest?
    @State private var missionCompletionError: Error?
    
    // 화면 전환 및 alert
    @State private var isShowDestinationArrivalAlert = false
    @State private var isShowArrivalView = false
    
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
        .onChange(
            of: model.trackingModel.activeSubQuest // activeSubQuest의 값이 변경되면 Live Activity 의 상태도 변경
        ) { _, subQuest in
            guard let subQuest else {
                return
            }
            
            Task {
                if subQuest.isCompleted {
                    await missionActivityManager.completeMission(
                        missionID: subQuest.id
                    )
                } else {
                    await missionActivityManager.showMission(
                        missionID: subQuest.id,
                        title: subQuest.title
                    )
                }
            }
        }
#endif
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
        
        await startMissionActivity(for: destination)
        
        model.startJourneyIfNeeded(
            locationService: locationService,
            notificationService: notificationService,
            missionStorageModel: missionStorageModel,
            modelContext: modelContext
        )
    }
    
    private func startMissionActivity(
        for destination: RecommendedPlace
    ) async {
        do {
            try await missionActivityManager.start(
                destinationID: destination.id
            )
        } catch {
            print("Live Activity 시작 실패:", error)
        }
    }
    
    private func cameraPicker(
        for subQuest: SubQuest
    ) -> some View {
        CameraPicker(
            onCapture: { image in
                Task { @MainActor in
                    do {
                        try await model.completeSubQuest(
                            subQuest,
                            image: image,
                            missionStorageModel: missionStorageModel,
                            modelContext: modelContext
                        )
                        missionCompletionError = nil
                        cameraSubQuest = nil
                    } catch {
                        missionCompletionError = error
                        cameraSubQuest = nil
                    }
                }
            },
            onCancel: {
                cameraSubQuest = nil
            },
            onFailure: { error in
                missionCompletionError = error
                cameraSubQuest = nil
            }
        )
        .ignoresSafeArea()
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
    
    #if DEBUG
    private var debugSubQuestControls: some View {
        VStack(alignment: .trailing) {
            Button("Live Activity 시작") {
                startLiveActivityForDebug()
            }
            
            Button("5초 후 퀘스트 발생") {
                model.trackingModel.triggerSubQuestForDebug(
                    after: .seconds(5)
                )
            }
            
            Button("10초 후 퀘스트 발생") {
                model.trackingModel.triggerSubQuestForDebug(
                    after: .seconds(10)
                )
            }
            
            Button("퀘스트 리셋") {
                model.trackingModel.resetSubQuestForDebug()
            }
        }
    }
    
    private func startLiveActivityForDebug() {
        guard let destination = model.destination else {
            return
        }
        
        Task {
            await startMissionActivity(for: destination)
        }
    }
    #endif
}

#Preview {
    JourneyView(
        area: "포항시 지곡동",
        category: "카페",
        initialDestination: .preview
    )
    .environment(LocationService())
    .environment(NotificationService())
    .environment(MissionActivityManager())
}
