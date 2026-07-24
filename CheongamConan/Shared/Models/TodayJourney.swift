//
//  TodayJourney.swift
//  CheongamConan
//
//  Created by 정홍섭 on 7/24/26.
//

import Foundation
import SwiftData

@Model
final class TodayJourney {
    var createdAt: Date

    var journeyList: [Journey]

    init(
        createdAt: Date = .now,
        journeyList: [Journey] = []
    ) {
        self.createdAt = createdAt
        self.journeyList = journeyList
    }
}
