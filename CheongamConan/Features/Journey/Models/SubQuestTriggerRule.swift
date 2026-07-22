//
//  SubQuestTriggerRule.swift
//  CheongamConan
//
//  Created by Dayoon Lee on 7/14/26.
//

import CoreLocation

/// 거리 기준 충족 여부 판단
struct SubQuestTriggerRule {
    let distanceThreshold: CLLocationDistance
    
    func matches(distanceFromStart: CLLocationDistance) -> Bool {
        distanceFromStart >= distanceThreshold
    }
}
