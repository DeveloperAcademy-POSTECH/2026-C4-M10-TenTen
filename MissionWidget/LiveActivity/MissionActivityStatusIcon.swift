//
//  MissionActivityStatusIcon.swift
//  MissionWidget
//
//  Created by Dayoon Lee on 7/23/26.
//

import SwiftUI

struct MissionActivityStatusIcon: View {
    enum Presentation {
        case minimal
        case expanded
    }
    let status: MissionActivityAttributes.Status
    let presentation: Presentation
    
    init(
        status: MissionActivityAttributes.Status,
        presentation: Presentation = .expanded
    ) {
        self.status = status
        self.presentation = presentation
    }
    
    @ViewBuilder
    var body: some View {
        switch (status, presentation) {
        case (.available, .minimal):
            activityIcon("MissionUnlocked")
        case (.locked, _):
            activityIcon("MissionLocked")
        case (.available, .expanded):
            activityIcon("Camera")
        case (.completed, _):
            activityIcon("MissionCompleted")
        }
    }
}

private func activityIcon(_ name: String) -> some View {
    Image(name)
        .resizable()
        .scaledToFit()
        .frame(width: 28, height: 28)
}

extension MissionActivityAttributes.Status {
    var symbolName: String {
        switch self {
        case .locked:
            "lock.fill"
        case .available:
            "camera.fill"
        case .completed:
            "checkmark"
        }
    }
}
