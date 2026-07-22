//
//  MissionWidgetLiveActivity.swift
//  MissionWidget
//
//  Created by Dayoon Lee on 7/21/26.
//

import ActivityKit
import SwiftUI
import WidgetKit

// Live Activity의 표시 영역을 구성하고 각 View를 연결합니다.
struct MissionWidgetLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(
            for: MissionActivityAttributes.self
        ) { context in
            MissionLockScreenView(state: context.state)
                .activityBackgroundTint(.black)
                .activitySystemActionForegroundColor(.white)
        } dynamicIsland: { context in
            DynamicIsland {
                DynamicIslandExpandedRegion(.bottom) {
                    MissionDynamicIslandExpandedView(
                        state: context.state
                    )
                }
            } compactLeading: {
                MissionActivityStatusIcon(
                    status: context.state.status
                )
            } compactTrailing: {
                // trailing 영역은 기획에서 제외된다
                EmptyView()
            } minimal: {
                MissionActivityStatusIcon(
                    status: context.state.status
                )
            }
        }
    }
}
