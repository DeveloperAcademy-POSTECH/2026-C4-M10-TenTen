//
//  MissionActivityAttributes+Preview.swift
//  MissionWidget
//
//  Created by Dayoon Lee on 7/23/26.
//

import Foundation
import WidgetKit

extension MissionActivityAttributes {
    static var preview: Self {
        MissionActivityAttributes(destinationID: UUID())
    }
}

extension MissionActivityAttributes.ContentState {
    static var lockedPreview: Self {
        MissionActivityAttributes.ContentState(
            missionID: nil,
            missionTitle: nil,
            status: .locked
        )
    }

    static var availablePreview: Self {
        MissionActivityAttributes.ContentState(
            missionID: UUID(),
            missionTitle: "횡단보도의 신호등",
            status: .available
        )
    }

    static var completedPreview: Self {
        MissionActivityAttributes.ContentState(
            missionID: UUID(),
            missionTitle: "횡단보도의 신호등",
            status: .completed
        )
    }
}

#Preview(
    "Dynamic Island - Minimal",
    as: .dynamicIsland(.minimal),
    using: MissionActivityAttributes.preview
) {
    MissionWidgetLiveActivity()
} contentStates: {
    MissionActivityAttributes.ContentState.lockedPreview
    MissionActivityAttributes.ContentState.availablePreview
    MissionActivityAttributes.ContentState.completedPreview
}

#Preview(
    "Dynamic Island - Compact",
    as: .dynamicIsland(.compact),
    using: MissionActivityAttributes.preview
) {
    MissionWidgetLiveActivity()
} contentStates: {
    MissionActivityAttributes.ContentState.lockedPreview
    MissionActivityAttributes.ContentState.availablePreview
    MissionActivityAttributes.ContentState.completedPreview
}


