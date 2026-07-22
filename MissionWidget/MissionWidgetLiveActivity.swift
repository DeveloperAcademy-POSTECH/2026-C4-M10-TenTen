//
//  MissionWidgetLiveActivity.swift
//  MissionWidget
//
//  Created by Dayoon Lee on 7/21/26.
//

import ActivityKit
import WidgetKit
import SwiftUI



struct MissionWidgetLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: MissionActivityAttributes.self) { context in
            // 잠금화면 Live Activity
            switch context.state.status {
            case .locked:
                lockedLockScreenView
            case .available:
                availableLockScreenView(
                    title: context.state.missionTitle
                )
            case .completed:
                completedLockScreenView(
                    title: context.state.missionTitle
                )
            }
        }
        dynamicIsland: { context in
            DynamicIsland {
                DynamicIslandExpandedRegion(.bottom) {
                    expandedView(state: context.state)
                }
            } compactLeading: {
                Image(systemName: symbolName(for: context.state.status))
                    .foregroundStyle(.main300)
            } compactTrailing: {
                
            } minimal: {
                Image(systemName: symbolName(for: context.state.status))
                    .foregroundStyle(.main300)
            }
        }
    }
    
}

private var lockedLockScreenView: some View {
    VStack(alignment: .leading, spacing: DSSpacing.spacing8){
        Text("여행을 더")
            .font(DSTypography.C3)
            .foregroundStyle(.grey300)
        Text("즐겁게 만들어줆 미션")
            .font(DSTypography.C1)
            .foregroundStyle(.white)
        HStack(spacing: DSSpacing.spacing4) {
            Text("잠시 후")
                .font(DSTypography.B1)
                .foregroundStyle(.main300)
            Text("미션이 공개됩니다.")
                .font(DSTypography.C1)
        }
    }
    .frame(maxWidth: .infinity, minHeight: 160, alignment: .leading)
    .padding(.horizontal, DSSpacing.contentHorizontal)
    .background(.black)
}

@ViewBuilder
private func availableLockScreenView(title: String?) ->  some View {
    VStack(alignment: .leading, spacing: DSSpacing.spacing8){
        Text("여행을 더 즐겁게 만들어줄 미션")
            .font(DSTypography.C1)
        HStack{
            if let title {
                Text(title)
                    .font(DSTypography.B1)
                    .foregroundStyle(.main300)
                Text("사진 찍기")
                    .font(DSTypography.C1)
            } else {
                Text("앱에서 미션을 확인해 보세요")
                    .font(DSTypography.C1)
            }
        }
    }
    .frame(maxWidth: .infinity, alignment: .leading)
    .padding(.horizontal, DSSpacing.contentHorizontal)
}

@ViewBuilder
private func completedLockScreenView(title: String?) -> some View {
    VStack(alignment: .leading, spacing: DSSpacing.spacing8){
        Text("여행을 더 즐겁게 만들어줄 미션")
            .font(DSTypography.C1)
        HStack{
            if let title {
                Text(title)
                    .font(DSTypography.B1)
                    .foregroundStyle(.main300)
                Text("사진 찍기 미션 완료")
                    .font(DSTypography.C1)
            } else {
                Text("미션 완료!")
                    .font(DSTypography.C1)
            }
        }
    }
    .frame(maxWidth: .infinity, alignment: .leading)
    .padding(.horizontal, DSSpacing.contentHorizontal)
}

@ViewBuilder
private func expandedView(
    state: MissionActivityAttributes.ContentState
) -> some View {
    switch state.status {
    case .locked:
        lockedExpandedView
        
    case .available:
        availableExpandedView(
            missionID: state.missionID,
            title: state.missionTitle
        )
        
    case .completed:
        completedExpandedView(
            title: state.missionTitle
        )
    }
}

private var lockedExpandedView: some View {
    HStack(spacing: DSSpacing.spacing12) {
        VStack(
            alignment: .leading,
            spacing: DSSpacing.spacing8
        ) {
            Text("여행을 더 즐겁게 만들어줄 미션")
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
        
        Spacer(minLength: DSSpacing.spacing8)
        
        Image(systemName: symbolName(for: .locked))
            .font(.title2)
            .foregroundStyle(.main300)
            .frame(width: 60, height: 60)
            .background(.main600)
            .clipShape(Circle())
    }
    .frame(maxWidth: .infinity)
    .padding(.horizontal, DSSpacing.spacing16)
}

@ViewBuilder
private func availableExpandedView(
    missionID: UUID?,
    title: String?
) -> some View {
    HStack(spacing: DSSpacing.spacing12) {
        VStack(
            alignment: .leading,
            spacing: DSSpacing.spacing8
        ) {
            Text("여행을 더 즐겁게 만들어줄 미션")
                .font(DSTypography.C1)
                .foregroundStyle(.white)
            
            if let title {
                HStack(spacing: DSSpacing.spacing4) {
                    Text(title)
                        .font(DSTypography.B1)
                        .foregroundStyle(.main300)
                        .lineLimit(1)
                        .minimumScaleFactor(0.75)
                    
                    Text("사진 찍기")
                        .font(DSTypography.C1)
                        .foregroundStyle(.white)
                        .fixedSize()
                }
            } else {
                Text("앱에서 미션을 확인해 보세요")
                    .font(DSTypography.C1)
                    .foregroundStyle(.white)
            }
        }
        
        Spacer(minLength: DSSpacing.spacing8)
        
        if let missionID,
           let cameraURL = cameraURL(missionID: missionID) {
            Link(destination: cameraURL) {
                Image(systemName: "camera.fill")
                    .font(.title2)
                    .foregroundStyle(.main300)
                    .frame(width: 60, height: 60)
                    .background(.main600)
                    .clipShape(Circle())
            }
        }
    }
    .frame(maxWidth: .infinity)
    .padding(.horizontal, DSSpacing.spacing16)
}

private func cameraURL(
    missionID: UUID
) -> URL? {
    URL(
        string: "tenten://mission/\(missionID)/camera"
    )
}

private func symbolName(
    for status: MissionActivityAttributes.Status
) -> String {
    switch status {
    case .locked:
        return "lock.fill"

    case .available:
        return "camera.fill"

    case .completed:
        return "checkmark"
    }
}

private func completedExpandedView(
    title: String?
) -> some View {
    HStack(spacing: DSSpacing.spacing12) {
        VStack(
            alignment: .leading,
            spacing: DSSpacing.spacing8
        ) {
            Text("미션을 완료했어요")
                .font(DSTypography.C1)
                .foregroundStyle(.white)
            
            if let title {
                HStack(spacing: DSSpacing.spacing4) {
                    Text(title)
                        .font(DSTypography.B1)
                        .foregroundStyle(.main300)
                        .lineLimit(1)
                        .minimumScaleFactor(0.75)

                    Text("사진 찍기")
                        .font(DSTypography.C1)
                        .foregroundStyle(.white)
                        .fixedSize()
                }
            }
        }
        
        Spacer(minLength: DSSpacing.spacing8)
        
        Image(systemName: symbolName(for: .completed))
            .font(.title2.bold())
            .foregroundStyle(.main300)
            .frame(width: 60, height: 60)
            .background(.main600)
            .clipShape(Circle())
    }
    .frame(maxWidth: .infinity)
    .padding(.horizontal, DSSpacing.spacing16)
}

extension MissionActivityAttributes {
    fileprivate static var preview: MissionActivityAttributes {
        MissionActivityAttributes(
            destinationID: UUID()
        )
    }
}

extension MissionActivityAttributes.ContentState {
    fileprivate static var locked: MissionActivityAttributes.ContentState {
        MissionActivityAttributes.ContentState(
            missionID: nil,
            missionTitle: nil,
            status: .locked
        )
     }
     
    fileprivate static var available: MissionActivityAttributes.ContentState {
        MissionActivityAttributes.ContentState(
            missionID: UUID(),
            missionTitle: "횡단보도의 신호등",
            status: .available
        )
    }
    
    fileprivate static var completed: MissionActivityAttributes.ContentState {
        MissionActivityAttributes.ContentState(
            missionID: UUID(),
            missionTitle: "횡단보도의 신호등",
            status: .completed
        )
    }
}

#Preview("잠금화면", as: .content, using: MissionActivityAttributes.preview) {
   MissionWidgetLiveActivity()
} contentStates: {
    MissionActivityAttributes.ContentState.locked
    MissionActivityAttributes.ContentState.available
    MissionActivityAttributes.ContentState.completed
}

#Preview(
    "Dynamic Island - minimal",
    as: .dynamicIsland(.minimal),
    using: MissionActivityAttributes.preview
) {
    MissionWidgetLiveActivity()
} contentStates: {
    MissionActivityAttributes.ContentState.locked
    MissionActivityAttributes.ContentState.available
    MissionActivityAttributes.ContentState.completed
}

#Preview(
    "Dynamic Island - compact",
    as: .dynamicIsland(.compact),
    using: MissionActivityAttributes.preview
) {
    MissionWidgetLiveActivity()
} contentStates: {
    MissionActivityAttributes.ContentState.locked
    MissionActivityAttributes.ContentState.available
    MissionActivityAttributes.ContentState.completed
}

#Preview(
    "Dynamic Island - expanded",
    as: .dynamicIsland(.expanded),
    using: MissionActivityAttributes.preview
) {
    MissionWidgetLiveActivity()
} contentStates: {
    MissionActivityAttributes.ContentState.locked
    MissionActivityAttributes.ContentState.available
    MissionActivityAttributes.ContentState.completed
}
