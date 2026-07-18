//
//  JourneyTrackingView.swift
//  CheongamConan
//
//  Created by Dayoon Lee on 7/13/26.
//

import SwiftUI

@MainActor
struct JourneyTrackingView: View {
    @Environment(LocationService.self) private var locationService

    // When in Use 권한은 온보딩에서 처리
    // TODO: 화면 최초 진입 시 Always 위치 권한 승격 흐름 연결
    @State private var trackingModel: JourneyTrackingModel
    @State private var cameraSubQuest: SubQuest? // 현재 카메라로 인증 중인 퀘스트, nil이면 카메라 닫힘

    init() {
        _trackingModel = State(
            initialValue: JourneyTrackingModel()
        )
    }
    
    init(trackingModel: JourneyTrackingModel) {
        _trackingModel = State(
            initialValue: trackingModel
        )
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                destinationHeader
                    .padding(.leading)
                mapPlaceHolder
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
            .padding(.top, DSSpacing.spacing48)
            .padding(.bottom, DSSpacing.spacing56)
            .padding(.horizontal, DSSpacing.contentHorizontal)
        }
        .onAppear {
            connectLocationService()
        }
        .fullScreenCover(item: $cameraSubQuest) { subQuest in
                cameraPicker(for: subQuest)
            }
    }

    private var destinationHeader: some View {
        VStack(alignment: .leading, spacing: DSSpacing.spacing4) {
            Text("오늘 이곳을 찾아 떠나는 거 어때요?")
                .font(DSTypography.C2)
            // TODO: 목적지 정보 추가
            Text("목적지 이름")
                .font(DSTypography.H3)
            Text("목적지 주소")
                .font(DSTypography.C3)
                .foregroundStyle(.grey600)
        }
        .frame(
            maxWidth: .infinity,
            alignment: .leading
        )

    }
    
    private var mapPlaceHolder: some View {
        RoundedRectangle(cornerRadius: DSRadius.standard)
            .fill(.grey200)
            .aspectRatio(contentMode: .fit)
            .overlay {
                Image(systemName: "map")
                    .font(.largeTitle)
            }
    }
    
    private var destinationArrivalButton: some View {
        Button {
            // - TODO: 목적지 도착
        } label: {
            Text("목적지 도착")
                .font(DSTypography.B1)
                .foregroundStyle(.neutralWhite)
                .frame(maxWidth: .infinity)
                .padding(.vertical, DSSpacing.spacing16)
                .background(.main300)
                .clipShape(RoundedRectangle(cornerRadius: DSRadius.standard))
        }
    }

    private func cameraPicker(
        for subQuest: SubQuest
    ) -> some View {
        CameraPicker(
            onCapture: {
                // - TODO: CameraPicker가 촬영한 이미지를 반환할 수 있도록 변경, 촬영한 이미지를 여행 단위 상태에 보관
                trackingModel.completeSubQuest(id: subQuest.id)
                cameraSubQuest = nil
            },
            onCancel: {
                cameraSubQuest = nil
            }
        )
    }

    private var subQuestCardState: SubQuestCard.State {
        guard let subQuest = trackingModel.activeSubQuest else {
            return .locked
        }
        if subQuest.isCompleted {
            return .completed(subQuest)
        }
        return .active(subQuest)
    }

    private func connectLocationService() {
        let model = trackingModel

        locationService.onLocationsReceived = { [weak model] locations in
            model?.receive(locations)
        }
    }
    
}

#if DEBUG
private extension SubQuest {
    static var completedPreview: SubQuest {
        var subQuest = SubQuest.movementExample()
        subQuest.isCompleted = true
        return subQuest
    }
}
#endif

#Preview("Locked") {
    JourneyTrackingView(
        trackingModel: .preview()
    )
        .environment(LocationService())
}

#Preview("Active") {
    JourneyTrackingView(
        trackingModel: .preview(
            activeSubQuest: .movementExample()
        )
    )
    .environment(LocationService())
}

#Preview("Completed") {
    JourneyTrackingView(
        trackingModel: .preview(
            activeSubQuest: .completedPreview
        )
    )
    .environment(LocationService())
}
