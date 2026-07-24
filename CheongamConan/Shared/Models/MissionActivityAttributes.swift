//
//  MissionActivityAttributes.swift
//  CheongamConan
//
//  Created by Dayoon Lee on 7/21/26.
//

import ActivityKit
import Foundation


struct MissionActivityAttributes: ActivityAttributes {
    // 목적지가 바뀔 때까지 변경되지 않는 값
    let destinationID: UUID
    
    struct ContentState: Codable, Hashable {
        let missionID: UUID?
        let missionTitle: String?
        let status: Status
    }
    
    enum Status: String, Codable, Hashable {
        case locked
        case available
        case completed
    }
}
