//
//  MissionLockScreenView.swift
//  CheongamConan
//
//  Created by Dayoon Lee on 7/23/26.
//

import SwiftUI
import WidgetKit

// 잠금 화면 Live Activity의 상태별 UI를 담당합니다.
struct MissionLockScreenView: View {
    let state: MissionActivityAttributes.ContentState
    
    var body: some View {
        Group {
            switch state.status {
            case .locked:
                lockedView
            case .available:
                availableView
            case .completed:
                completedView
            }
        }
        .frame(maxWidth: .infinity, maxHeight: 100, alignment: .leading)
        .padding(.vertical, DSSpacing.spacing20)
        .padding(.horizontal, DSSpacing.spacing28)
        .background(.neutralBlack)
        
        
    }
    private var lockedView: some View {
        contentLayout {
            VStack(
                alignment: .leading,
                spacing: DSSpacing.spacing8
            ) {
                header

                missionDescription(
                    highlightedText: "잠시 후",
                    trailingText: "미션이 공개됩니다."
                )
            }
        } action: {
            expandedStatusIcon(status: .locked)
        }
    }
    
    private var availableView: some View {
        contentLayout {
            VStack(
                alignment: .leading,
                spacing: DSSpacing.spacing8
            ) {
                header

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
            }
        } action: {
            // TODO: 카메라 Deep Link 구현 (새미)
            expandedStatusIcon(status: (.available))
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
    
    
    private var header: some View {
        Text("여행을 더 즐겁게 만들어줄 미션")
            .font(DSTypography.C1)
            .foregroundStyle(.white)
    }
    
    private func missionDescription(
        highlightedText: String,
        trailingText: String
    ) -> some View {
        HStack(spacing: DSSpacing.spacing4) {
            Text(highlightedText)
                .font(DSTypography.B1)
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

            Spacer(minLength: DSSpacing.spacing8)

            action()
        }

    }
}


#Preview(
    "잠금 화면",
    as: .content,
    using: MissionActivityAttributes.preview
) {
    MissionWidgetLiveActivity()
} contentStates: {
    MissionActivityAttributes.ContentState.lockedPreview
    MissionActivityAttributes.ContentState.availablePreview
    MissionActivityAttributes.ContentState.completedPreview
}
