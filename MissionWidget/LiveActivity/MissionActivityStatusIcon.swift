//
//  MissionActivityStatusIcon.swift
//  MissionWidget
//
//  Created by Dayoon Lee on 7/23/26.
//

import SwiftUI

struct MissionActivityStatusIcon: View {
    let status: MissionActivityAttributes.Status
    
    var body: some View {
        Image(systemName: status.symbolName)
            .foregroundStyle(.main300)
    }
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
