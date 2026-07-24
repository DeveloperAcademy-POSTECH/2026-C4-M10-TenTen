//
//  Journey.swift
//  CheongamConan
//
//  Created by 정홍섭 on 7/23/26.
//

import Foundation

struct Journey: Codable, Equatable {
    let finishedAt: String
    let destination: String
    let latitude: Double
    let longitude: Double

    let isComplete: Bool
    let missionTitle: String
    let imageFileName: String?

    init(
        finishedAt: String,
        destination: String,
        latitude: Double,
        longitude: Double,
        isComplete: Bool,
        missionTitle: String,
        imageFileName: String?
    ) {
        self.finishedAt = finishedAt
        self.destination = destination
        self.latitude = latitude
        self.longitude = longitude
        self.isComplete = isComplete
        self.missionTitle = missionTitle
        self.imageFileName = imageFileName
    }
}
