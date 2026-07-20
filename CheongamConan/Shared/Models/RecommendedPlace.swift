//
//  RecommendedPlace.swift
//  CheongamConan
//
//  Created by 정홍섭 on 7/17/26.
//

import Foundation
import SwiftData

@Model
final class RecommendedPlace {
    var latitude: Double
    var longitude: Double
    var name: String
    var roadAddress: String
    var recommendedAt: Date
    
    init(latitude: Double, longitude: Double, name: String, roadAddress: String, recommendedAt: Date = .now) {
        self.latitude = latitude
        self.longitude = longitude
        self.name = name
        self.roadAddress = roadAddress
        self.recommendedAt = recommendedAt
    }
}
#if DEBUG
extension RecommendedPlace {
    static var preview: RecommendedPlace {
        RecommendedPlace(
            latitude: 36.009731,
            longitude: 129.333273,
            name: "바르벳추천",
            roadAddress: "경북 포항시 남구 효자동 225-2"
        )
    }
}
#endif
