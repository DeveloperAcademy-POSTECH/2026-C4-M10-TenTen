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
            title: "신호등 사진 찍기",
            description: "지나가는 길에 보이는 신호등 사진을 찍어주세요",
            isCompleted: false,
            triggeredAt: triggeredAt
        )}
}
