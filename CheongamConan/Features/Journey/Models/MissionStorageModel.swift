//
//  MissionStorageModel.swift
//  CheongamConan
//
//  Created by Dayoon Lee on 7/20/26.
//

import Foundation
import Observation
import SwiftData

@MainActor
@Observable
final class MissionStorageModel {
    private(set) var missions: [MissionRecord] = []
    
    func fetch(
        id: UUID,
        modelContext: ModelContext
    ) throws -> MissionRecord? {
        let missionID = id
        
        var descriptor = FetchDescriptor<MissionRecord>(
            predicate: #Predicate{ mission in
                mission.id == missionID
            }
        )
        descriptor.fetchLimit = 1
        
        return try modelContext.fetch(descriptor).first
    }
    
    func save(
        _ mission: MissionRecord,
        modelContext: ModelContext
    ) throws {
        guard try fetch(
            id: mission.id,
            modelContext: modelContext
        ) == nil
        else {
            return
        }
        
        modelContext.insert(mission)
        
        do {
            try modelContext.save()
            missions.append(mission)
            sortMissions()
        } catch {
            modelContext.rollback()
            throw error
        }
    }
    
    // 저장된 미션을 잠금 해제 시각순으로 불러옴
    func loadMissions(
        modelContext: ModelContext
    ) throws {
        let descriptor = FetchDescriptor<MissionRecord>(
            sortBy: [
                SortDescriptor(
                    \MissionRecord.unlockedAt,
                     order: .forward
                )
            ]
        )
        missions = try modelContext.fetch(descriptor)
    }
    
    func completeMission(
        id: UUID,
        imageFileName: String,
        at date: Date = .now,
        modelContext: ModelContext
    ) throws {
        guard let mission = try fetch(
            id: id,
            modelContext: modelContext
        ) else {
            throw MissionStorageError.missionNotFound
        }
        guard !mission.isCompleted else {
            throw MissionStorageError.alreadyCompleted
        }
        
        mission.complete(
            imageFileName: imageFileName,
            at: date
        )
        
        do {
            try modelContext.save()
        } catch {
            modelContext.rollback()
            throw error
        }
    }
    
    private func sortMissions() {
        missions.sort {
            $0.unlockedAt < $1.unlockedAt
        }
    }
    
    enum MissionStorageError: Error {
        case missionNotFound
        case alreadyCompleted
    }
}
