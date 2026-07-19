    //
    //  DestinationView.swift
    //  CheongamConan
    //
    //  Created by 정홍섭 on 7/15/26.
    //

    import Foundation
    import Observation
    import SwiftData

    @MainActor
    @Observable
    final class DestinationModel {
        private(set) var recommendedPlace: RecommendedPlace?
        private(set) var isLoading = false
        private(set) var errorMessage: String?
        
        private let placeSearchService: NaverPlaceSearchService
        
        init() {
            self.placeSearchService = NaverPlaceSearchService()
        }
        
        init(placeSearchService: NaverPlaceSearchService) {
            self.placeSearchService = placeSearchService
        }
        
        private func isExcludedPlace(_ place: Place) -> Bool {
            let name = place.name
                .trimmingCharacters(in: .whitespacesAndNewlines)
                .replacingOccurrences(of: " ", with: "")
                .lowercased()
            
            let category = place.category
                .replacingOccurrences(of: " ", with: "")
                .lowercased()
            
            let franchiseSuffixes = [
                "지점",
                "호점",
                "직영점",
                "가맹점",
                "점"
            ]
            
            let isFranchise = franchiseSuffixes.contains {
                name.hasSuffix($0)
            }
            
            let isStudyCafe =
            name.contains("스터디카페") ||
            category.contains("스터디카페") ||
            category.contains("독서실")
            
            return isFranchise || isStudyCafe
        }
        
        private func randomCategory(from category: String) -> String {
            let randomCategories = [
                "카페",
                "맛집",
                "명소",
            ]
            
            guard category == "랜덤" else {
                return category
            }
            
            return randomCategories.randomElement() ?? "카페"
        }
        
        func loadOrRecommend(area: String, category: String, modelContext: ModelContext) async {
            guard !isLoading else { return }
            
            isLoading = true
            recommendedPlace = nil
            errorMessage = nil
            
            defer { isLoading = false}
            
            do {
                if let savedPlace = try fetchRecommendedPlace(modelContext: modelContext) {
                    recommendedPlace = savedPlace
                    return
                }
                
                let place = try await requestRecommendation(area: area, category: category)
                
                let savedPlace = try saveRecommendedPlace(place, modelContext: modelContext)
                
                recommendedPlace = savedPlace
            } catch {
                errorMessage = "장소를 불러오지 못했습니다."
            }
        }
        
        private func requestRecommendation(area: String, category: String) async throws -> Place {
            let searchCategory = randomCategory(from: category)
            let places = try await placeSearchService.search(query: "\(area) \(searchCategory)")
            let localPlaces = places.filter {
                !isExcludedPlace($0)
            }
            
            guard let place = localPlaces.randomElement() else {
                throw DestinationError.placeNotFound
            }
            
            return place
        }
        
        private func fetchRecommendedPlace(modelContext: ModelContext) throws -> RecommendedPlace? {
            var descriptor = FetchDescriptor<RecommendedPlace>()
            descriptor.fetchLimit = 1
            
            return try modelContext.fetch(descriptor).first
        }
        
        private func saveRecommendedPlace(_ place: Place, modelContext: ModelContext) throws -> RecommendedPlace {
            let recommendedPlace = RecommendedPlace(
                latitude: place.latitude, longitude: place.longitude, name: place.name, roadAddress: place.roadAddress
            )
            
            modelContext.insert(recommendedPlace)
            try modelContext.save()
            
            return recommendedPlace
        }
    }

    private enum DestinationError: Error {
        case placeNotFound
    }
