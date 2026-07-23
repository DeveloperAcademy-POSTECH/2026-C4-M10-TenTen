//
//  ArrivalPlaceConfirmModel.swift
//  CheongamConan
//
//  Created by 정홍섭 on 7/23/26.
//

import Foundation
import SwiftData

@Observable
final class ArrivalPlaceConfirmModel {
    @MainActor
    func endJourney(modelContext: ModelContext) throws {
        try deleteJourneySession(modelContext: modelContext)
        try deleteRecommendedPlace(modelContext: modelContext)
        
        try modelContext.save()
    }
    
    private func deleteJourneySession(modelContext: ModelContext) throws {
        let descriptor = FetchDescriptor<JourneySession>()
        let sessions = try modelContext.fetch(descriptor)
        
        sessions.forEach { session in
            modelContext.delete(session)
        }
    }
    
    private func deleteRecommendedPlace(modelContext: ModelContext) throws {
        let descriptor = FetchDescriptor<RecommendedPlace>()
        let recommendedPlaces = try modelContext.fetch(descriptor)
        
        print("삭제 전 RecommendedPlace 개수:", recommendedPlaces.count)
        
        recommendedPlaces.forEach { place in
            modelContext.delete(place)
        }
        
        let remainingPlaces = try modelContext.fetch(descriptor)
        print("삭제 후 RecommendedPlace 개수:", remainingPlaces.count)
    }
}
