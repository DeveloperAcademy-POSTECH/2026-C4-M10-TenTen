//
//  ArrivalPlaceSearchModel.swift
//  CheongamConan
//
//  Created by 정홍섭 on 7/20/26.
//

import Foundation
import Observation
import SwiftData

@MainActor
@Observable
final class ArrivalPlaceSearchModel {
    private(set) var places: [SearchResultPlace] = []
    private(set) var isLoading: Bool = false
    private(set) var errorMessage: String?
    
    private let placeSearchService: KakaoPlaceSearchService
    private var searchTask: Task<Void, Never>?
    
    init(placeSearchService: KakaoPlaceSearchService = KakaoPlaceSearchService()) {
        self.placeSearchService = placeSearchService
    }
    
    func search(query: String) {
        searchTask?.cancel()
        
        let trimmedQuery = query.trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard !trimmedQuery.isEmpty else {
            reset()
            return
        }
        
        searchTask = Task {
            do {
                try await Task.sleep(for: .milliseconds(500))
                
                try Task.checkCancellation()
                
                isLoading = true
                errorMessage = nil
                
                let searchedPlaces = try await placeSearchService.search(query: trimmedQuery)
                
                try Task.checkCancellation()
                
                places = searchedPlaces
                isLoading = false
            } catch is CancellationError {
                
            } catch {
                places = []
                isLoading = false
                errorMessage = error.localizedDescription
            }
        }
    }
    
    func cancelSearch() {
        searchTask?.cancel()
        isLoading = false
    }
    
    private func reset() {
        places = []
        errorMessage = nil
        isLoading = false
    }
    
    func selectPlace(
        _ place: Place,
        modelContext: ModelContext
    ) throws {
        var descriptor = FetchDescriptor<RecommendedPlace>(
            sortBy: [
                SortDescriptor(
                    \.recommendedAt,
                    order: .reverse
                )
            ]
        )

        descriptor.fetchLimit = 1

        guard let recommendedPlace =
            try modelContext.fetch(descriptor).first
        else {
            return
        }

        recommendedPlace.name = place.name
        recommendedPlace.latitude = place.latitude
        recommendedPlace.longitude = place.longitude

        recommendedPlace.roadAddress =
            place.roadAddress.isEmpty
            ? place.address
            : place.roadAddress

        try modelContext.save()
    }
}
