//
//  MissionDynamicIslandExpandedView.swift
//  MissionWidget
//
//  Created by Dayoon Lee on 7/23/26.
//

import SwiftUI
import WidgetKit

// Dynamic Island를 길게 눌렀을 때 표시되는 Expanded UI를 담당합니다.
struct MissionDynamicIslandExpandedView: View {
    let state: MissionActivityAttributes.ContentState
    
    var body: some View {
        switch state.status {
        case .locked:
            lockedView
        case .available:
            availableView
        case .completed:
            completedView
        }
    }
    
    private var lockedView: some View {
        verticalContentLayout {
            missionDescription(
                highlightedText: "잠시 후",
                trailingText: "미션이 공개됩니다."
            )
        } action: {
            actionLabel(
                title: "잠금 해제중",
                spacing: DSSpacing.spacing8
            ) {
                MissionActivityStatusIcon(
                    status: .locked,
                    presentation: .expanded
                )
            }
        }
    }
    
    private var availableView: some View {
        verticalContentLayout {
            if let title = state.missionTitle {
                missionDescription(
                    highlightedText: title,
                    trailingText: "사진 찍기"
                )
            } else {
                Text("앱에서 미션을 확인해 보세요")
                    .font(DSTypography.C1)
                    .foregroundStyle(.white)
            }
        } action: {
            availableCameraAction
        }
    }
    
    private var completedView: some View {
        contentLayout {
            VStack(
                alignment: .leading,
                spacing: DSSpacing.spacing8
            ) {
                Text("미션을 완료했어요")
                    .font(DSTypography.C1)
                    .foregroundStyle(.white)

                if let title = state.missionTitle {
                    missionDescription(
                        highlightedText: title,
                        trailingText: "사진 찍기"
                    )
                }
            }
        } action: {
            expandedStatusIcon(status: .completed)
        }
    }
    
    private var expandedHeader: some View {
        Text("여행을 더\n즐겁게 만들어줄 미션")
            .font(DSTypography.C3)
            .foregroundStyle(.grey300)
            .fixedSize(horizontal: false, vertical: true)
    }
    
    @ViewBuilder
    private var availableCameraAction: some View {
        if let missionID = state.missionID,
           let cameraURL = MissionActivityDeepLink.camera(
               missionID: missionID
           ) {
            Link(destination: cameraURL) {
                cameraActionLabel
            }
        }
    }

    private var cameraActionLabel: some View {
        actionLabel(title: "카메라 열기", spacing: 7) {
            Image("Camera")
                .resizable()
                .scaledToFit()
                .frame(width: 28, height: 28)
        }
    }
    
    private func missionDescription(
        highlightedText: String,
        trailingText: String
    ) -> some View {
        HStack(spacing: DSSpacing.spacing4) {
            Text(highlightedText)
                .font(DSTypography.H5)
                .foregroundStyle(.main300)
                .lineLimit(1)
                .minimumScaleFactor(0.75)
            
            Text(trailingText)
                .font(DSTypography.C1)
                .foregroundStyle(.white)
                .fixedSize()
        }
    }
    
    private func expandedStatusIcon(
        status: MissionActivityAttributes.Status
    ) -> some View {
        MissionActivityStatusIcon(status: status)
            .font(.title2.bold())
            .frame(width: 60, height: 60)
            .background(.main600)
            .clipShape(Circle())
    }
    
    private func contentLayout<Content: View, Action: View>(
        @ViewBuilder content: () -> Content,
        @ViewBuilder action: () -> Action
    ) -> some View {
        HStack(spacing: DSSpacing.spacing12) {
            content()
            
            Spacer(minLength: DSSpacing.spacing12)
            
            action()
        }
        .frame(maxWidth: .infinity)
        .padding(.horizontal, DSSpacing.spacing16)
    }
    
    private func verticalContentLayout<
        MissionContent: View,
        Action: View
    >(
        @ViewBuilder missionContent: () -> MissionContent,
        @ViewBuilder action: () -> Action
    ) -> some View {
        VStack(
            alignment: .leading,
            spacing: 14
        ) {
            VStack(
                alignment: .leading,
                spacing: DSSpacing.spacing4
            ) {
                expandedHeader
                missionContent()
            }
            
            action()
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, DSSpacing.spacing24)
        .padding(.bottom, DSSpacing.spacing12)
    }
    
    private func actionLabel<Icon: View>(
        title: String,
        spacing: CGFloat,
        @ViewBuilder icon: () -> Icon
    ) -> some View {
        HStack(spacing: spacing) {
            icon()
            
            Text(title)
                .font(DSTypography.B2)
                .foregroundStyle(.main300)
        }
        .padding(.vertical, DSSpacing.spacing4)
        .frame(maxWidth: .infinity, minHeight: 40)
        .background(.main600)
        .clipShape(Capsule())
    }
}

#Preview(
    "Dynamic Island - Expanded",
    as: .dynamicIsland(.expanded),
    using: MissionActivityAttributes.preview
) {
    MissionWidgetLiveActivity()
} contentStates: {
    MissionActivityAttributes.ContentState.lockedPreview
    MissionActivityAttributes.ContentState.availablePreview
    MissionActivityAttributes.ContentState.completedPreview
}
