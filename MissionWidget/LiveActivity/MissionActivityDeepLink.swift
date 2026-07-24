//
//  MissionActivityDeepLink.swift
//  MissionWidget
//
//  Created by Dayoon Lee on 7/23/26.
//

import Foundation

enum MissionActivityDeepLink {
    static func camera(missionID: UUID) -> URL? {
        URL(
            string: "tenten://mission/\(missionID.uuidString)/camera"
        )
    }
}
