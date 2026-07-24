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
    var isCompleted: Bool
    let triggeredAt: Date
}

#if DEBUG
extension SubQuest {
    static func previewExample(
        triggeredAt: Date = .now
    ) -> SubQuest {
        SubQuest(
            id: UUID(),
            title: "7월의 꽃, 능소화",
            isCompleted: false,
            triggeredAt: triggeredAt
        )}
}
#endif
