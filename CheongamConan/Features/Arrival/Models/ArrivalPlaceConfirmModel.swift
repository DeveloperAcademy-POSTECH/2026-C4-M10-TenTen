//
//  ArrivalPlaceConfirmModel.swift
//  CheongamConan
//
//  Created by 정홍섭 on 7/23/26.
//

import Foundation
import SwiftData
import Observation

@Observable
final class ArrivalPlaceConfirmModel {
    @MainActor
    func endJourney(modelContext: ModelContext) throws {
        try deleteRecommendedPlace(modelContext: modelContext)
        
        try deleteJourneySession(modelContext: modelContext)
        
        try modelContext.save()
    }
    
    private func deleteJourneySession(modelContext: ModelContext) throws {
        let descriptor = FetchDescriptor<JourneySession>()
        
        let sessions = try modelContext.fetch(descriptor)
        
        sessions.forEach { session in
            modelContext.delete(session)
        }
    }
    
    private func deleteRecommendedPlace(
        modelContext: ModelContext
    ) throws {
        let placeDescriptor = FetchDescriptor<RecommendedPlace>(
            sortBy: [
                SortDescriptor(\.recommendedAt)
            ]
        )
        let missionDescriptor = FetchDescriptor<MissionRecord>()

        let recommendedPlaces = try modelContext.fetch(placeDescriptor)
        let missionRecords = try modelContext.fetch(missionDescriptor)

        guard !recommendedPlaces.isEmpty else {
            return
        }

        let finishedAt = ISO8601DateFormatter().string(from: .now)

        let newJourneys = recommendedPlaces.map { place in
            let mission = missionRecords.first {
                $0.recommendedPlaceID == place.id
            }

            return Journey(
                finishedAt: finishedAt,
                destination: place.name,
                latitude: place.latitude,
                longitude: place.longitude,
                isComplete: mission?.isCompleted ?? false,
                missionTitle: mission?.title ?? "",
                imageFileName: mission?.imageFileName
            )
        }

        let todayJourney = try findOrCreateTodayJourney(
            modelContext: modelContext
        )

        todayJourney.journeyList += newJourneys

        missionRecords.forEach { mission in
            modelContext.delete(mission)
        }

        recommendedPlaces.forEach { place in
            modelContext.delete(place)
        }
    }
    
    private func findOrCreateTodayJourney(modelContext: ModelContext) throws -> TodayJourney {
        let calendar = Calendar.current
        let now = Date()
        
        let startOfToday = calendar.startOfDay(for: now)
        
        let startOfTomorrow =
        calendar.date(
            byAdding: .day,
            value: 1,
            to: startOfToday
        ) ?? startOfToday.addingTimeInterval(86_400)
        
        var descriptor = FetchDescriptor<TodayJourney>(
            predicate: #Predicate<TodayJourney> { journey in
                journey.createdAt >= startOfToday &&
                journey.createdAt < startOfTomorrow
            }
        )
        
        if let savedTodayJourney =
            try modelContext.fetch(descriptor).first {
            return savedTodayJourney
        }
        
        let newTodayJourney = TodayJourney(
            createdAt: now
        )
        
        modelContext.insert(newTodayJourney)
        
        return newTodayJourney
    }
}
