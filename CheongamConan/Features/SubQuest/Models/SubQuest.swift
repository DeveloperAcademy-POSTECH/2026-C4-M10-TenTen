//
//  SubQuest.swift
//  CheongamConan
//
//  Created by Dayoon Lee on 7/14/26.
//

import Foundation

/// 서브 퀘스트 데이터 모델
struct SubQuest: Identifiable, Equatable {
    let id: UUID
    let title: String
    let description: String
    var isCompleted: Bool
    let triggeredAt: Date
}

extension SubQuest {
    static func movementExample(
        triggeredAt: Date = .now
    ) -> SubQuest {
        SubQuest(
            id: UUID(),
            title: "7월의 꽃, 능소화",
            description: "능소화 사진을 찍어주세요",
            isCompleted: false,
            triggeredAt: triggeredAt
        )}
}
