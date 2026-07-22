//
//  ArrivalPlaceSearchModel.swift
//  CheongamConan
//
//  Created by 정홍섭 on 7/20/26.
//

import Foundation
import Observation

@MainActor
@Observable
final class ArrivalPlaceSearchModel {
    private(set) var places: [Place] = []
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
}
