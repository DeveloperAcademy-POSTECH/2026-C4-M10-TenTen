//
//  JourneySession.swift
//  CheongamConan
//
//  Created by 정홍섭 on 7/21/26.
//

import Foundation
import SwiftData

enum JourneyPhase: String, Codable {
    case journey
    case arrival
}

@Model
final class JourneySession {
    var phaseRawValue: String
    var isCompleted: Bool

    var area: String
    var category: String

    var createdAt: Date
    var updatedAt: Date

    var destination: RecommendedPlace?

    init(
        area: String,
        category: String,
        destination: RecommendedPlace
    ) {
        self.area = area
        self.category = category
        self.destination = destination

        self.phaseRawValue = JourneyPhase.journey.rawValue
        self.isCompleted = false

        self.createdAt = .now
        self.updatedAt = .now
    }
}

extension JourneySession {
    var phase: JourneyPhase {
        get {
            JourneyPhase(rawValue: phaseRawValue) ?? .journey
        }

        set {
            phaseRawValue = newValue.rawValue
            updatedAt = .now
        }
    }

    func arrive() {
        phase = .arrival
    }

    func complete() {
        isCompleted = true
        updatedAt = .now
    }
}
