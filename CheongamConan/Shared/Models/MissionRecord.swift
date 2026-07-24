//
//  MissionRecord.swift
//  CheongamConan
//
//  Created by Dayoon Lee on 7/20/26.
//

import Foundation
import SwiftData

@Model
final class MissionRecord {
    @Attribute(.unique)
    var id: UUID // SubQuest와 동일한 Id
    
    var recommendedPlaceID: UUID
    
    var title: String
    var unlockedAt: Date // 미션 발생 조건을 충족하여 미션이 사용자에게 공개된 시각
    
    private(set) var isCompleted: Bool
    private(set) var completedAt: Date? // 미션 완료 시각
    private(set) var imageFileName: String? // Application Support 내부에서 사용할 파일명
    
    init(
        id: UUID,
        recommendedPlaceID: UUID,
        title: String,
        unlockedAt: Date,
        isCompleted: Bool = false,
        completedAt: Date? = nil,
        imageFileName: String? = nil
    ) {
        self.id = id
        self.recommendedPlaceID = recommendedPlaceID
        self.title = title
        self.unlockedAt = unlockedAt
        self.isCompleted = isCompleted
        self.completedAt = completedAt
        self.imageFileName = imageFileName
    }
    
    func complete(
        imageFileName: String,
        at date: Date = .now
    ) {
        guard !isCompleted else { return } // 재촬영을 허용하지 않음
        
        self.imageFileName = imageFileName
        self.completedAt = date
        self.isCompleted = true
    }
}
