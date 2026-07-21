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
            switch context.state.status {
            case .locked:
                Label("미션 준비 중", systemImage: "lock.fill")
            case .available:
                Label(
                    context.state.missionTitle ?? "새로운 미션",
                    systemImage: "camera.fill"
                )
            case .completed:
                Label(
                    context.state.missionTitle ?? "미션 완료",
                    systemImage: "checkmark.circle.fill"
                )
            }
        } dynamicIsland: { context in
            DynamicIsland {
                // Expanded UI goes here.  Compose the expanded UI through
                // various regions, like leading/trailing/center/bottom
                DynamicIslandExpandedRegion(.leading) {
                    Text("Leading")
                }
                DynamicIslandExpandedRegion(.trailing) {
                    Text("Trailing")
                }
                DynamicIslandExpandedRegion(.bottom) {
                    switch context.state.status {
                    case .locked:
                        Label("미션 준비 중", systemImage: "lock.fill")
                    case .available:
                        Label(
                            context.state.missionTitle ?? "새로운 미션",
                            systemImage: "camera.fill"
                        )
                    case .completed:
                        Label(
                            context.state.missionTitle ?? "미션 완료",
                            systemImage: "checkmark.circle.fill"
                        )
                    }
                }
            } compactLeading: {
                Image(
                    systemName: context.state.status == .completed
                    ? "checkmark.circle.fill"
                    : "figure.walk"
                )
            } compactTrailing: {
                Image(
                    systemName: context.state.status == .locked
                    ? "lock.fill"
                    : "camera.fill"
                )
            } minimal: {
                Image(
                    systemName: context.state.status == .completed
                    ? "checkmark.circle.fill"
                    : "figure.walk"
                )
            }
            .keylineTint(Color.red)
        }
    }
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
            missionTitle: "횡단보도의 신호등 사진 찍기",
            status: .available
        )
    }
    
    fileprivate static var completed: MissionActivityAttributes.ContentState {
        MissionActivityAttributes.ContentState(
            missionID: UUID(),
            missionTitle: "횡단보도의 신호등 사진 찍기",
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
    .locked
}

#Preview(
    "Dynamic Island - compact",
    as: .dynamicIsland(.compact),
    using: MissionActivityAttributes.preview
) {
    MissionWidgetLiveActivity()
} contentStates: {
    .locked
}

#Preview(
    "Dynamic Island - expanded",
    as: .dynamicIsland(.expanded),
    using: MissionActivityAttributes.preview
) {
    MissionWidgetLiveActivity()
} contentStates: {
    .locked
}
