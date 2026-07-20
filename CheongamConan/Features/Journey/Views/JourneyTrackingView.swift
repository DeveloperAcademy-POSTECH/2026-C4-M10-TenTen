//
//  JourneyTrackingView.swift
//  CheongamConan
//
//  Created by Dayoon Lee on 7/13/26.
//

import SwiftUI

@MainActor
struct JourneyTrackingView: View {
    let destination: RecommendedPlace

    @State private var cameraSubQuest: SubQuest? // 현재 카메라로 인증 중인 퀘스트, nil이면 카메라 닫힘

    @Bindable var trackingModel: JourneyTrackingModel

    init(
        destination: RecommendedPlace,
        trackingModel: JourneyTrackingModel
    ) {
        self.destination = destination
        _trackingModel = Bindable(
            wrappedValue: trackingModel
        )
    }

    var body: some View {
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
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.top, DSSpacing.spacing48)
        .padding(.bottom, DSSpacing.spacing56)
        .padding(.horizontal, DSSpacing.contentHorizontal)
        .fullScreenCover(item: $cameraSubQuest) { subQuest in
            cameraPicker(for: subQuest)
        }
    }

    private var destinationHeader: some View {
        VStack(alignment: .leading, spacing: DSSpacing.spacing4) {
            Text("오늘 이곳을 찾아 떠나는 거 어때요?")
                .font(DSTypography.C2)
            Text(destination.name)
                .font(DSTypography.H3)
            Text(destination.roadAddress)
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
            .frame(maxWidth: .infinity)
            .aspectRatio(362.0 / 369.0, contentMode: .fill)
            .overlay {
                Image(systemName: "map")
                    .font(.largeTitle)
            }
    }
    
    private var destinationArrivalButton: some View {
        Button {
            // TODO: 목적지 도착
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
                // TODO: CameraPicker가 촬영한 이미지를 반환할 수 있도록 변경, 촬영한 이미지를 여행 단위 상태에 보관
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
        destination: .preview,
        trackingModel: .preview()
    )
        .environment(LocationService())
}

#Preview("Active") {
    JourneyTrackingView(
        destination: .preview,
        trackingModel: .preview(
            activeSubQuest: .movementExample()
        )
    )
    .environment(LocationService())
}

#Preview("Completed") {
    JourneyTrackingView(
        destination: .preview,
        trackingModel: .preview(
            activeSubQuest: .completedPreview
        )
    )
    .environment(LocationService())
}
