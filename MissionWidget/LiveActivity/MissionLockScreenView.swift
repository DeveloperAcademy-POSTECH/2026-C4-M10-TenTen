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
        VStack(alignment: .leading, spacing: DSSpacing.spacing8) {
            Text("여행을 더")
                .font(DSTypography.C3)
                .foregroundStyle(.grey300)

            Text("즐겁게 만들어줄 미션")
                .font(DSTypography.C1)
                .foregroundStyle(.white)

            HStack(spacing: DSSpacing.spacing4) {
                Text("잠시 후")
                    .font(DSTypography.B1)
                    .foregroundStyle(.main300)

                Text("미션이 공개됩니다.")
                    .font(DSTypography.C1)
                    .foregroundStyle(.white)
            }
        }
        .frame(maxWidth: .infinity, minHeight: 160, alignment: .leading)
        .padding(.horizontal, DSSpacing.contentHorizontal)
        .background(.black)
    }
    
    private var availableView: some View {
        VStack(alignment: .leading, spacing: DSSpacing.spacing8) {
            Text("여행을 더 즐겁게 만들어줄 미션")
                .font(DSTypography.C1)
                .foregroundStyle(.white)

            HStack(spacing: DSSpacing.spacing4) {
                if let title = state.missionTitle {
                    Text(title)
                        .font(DSTypography.B1)
                        .foregroundStyle(.main300)

                    Text("사진 찍기")
                        .font(DSTypography.C1)
                        .foregroundStyle(.white)
                } else {
                    Text("앱에서 미션을 확인해 보세요")
                        .font(DSTypography.C1)
                        .foregroundStyle(.white)
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, DSSpacing.contentHorizontal)
    }
    
    private var completedView: some View {
        VStack(alignment: .leading, spacing: DSSpacing.spacing8) {
            Text("여행을 더 즐겁게 만들어줄 미션")
                .font(DSTypography.C1)
                .foregroundStyle(.white)

            HStack(spacing: DSSpacing.spacing4) {
                if let title = state.missionTitle {
                    Text(title)
                        .font(DSTypography.B1)
                        .foregroundStyle(.main300)

                    Text("사진 찍기 미션 완료")
                        .font(DSTypography.C1)
                        .foregroundStyle(.white)
                } else {
                    Text("미션 완료!")
                        .font(DSTypography.C1)
                        .foregroundStyle(.white)
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, DSSpacing.contentHorizontal)
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
