//
//  MissionDefinition.swift
//  CheongamConan
//
//  Created by Codex on 7/24/26.
//

import Foundation

/// 앱 번들에 준비해 둔 미션의 정적 데이터
struct MissionDefinition: Decodable, Equatable {
    let title: String
}

/// Missions.json 최상위 구조
struct MissionCatalog: Decodable {
    let version: Int
    let missions: [MissionDefinition]
}
