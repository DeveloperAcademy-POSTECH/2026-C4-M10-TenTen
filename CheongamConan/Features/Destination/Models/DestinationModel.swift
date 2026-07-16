//
//  DestinationView.swift
//  CheongamConan
//
//  Created by 정홍섭 on 7/15/26.
//

import Foundation
import Observation

@MainActor
@Observable
final class DestinationModel {
    private(set) var recommendedPlace: Place?
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
        print(category)
        
        return randomCategories.randomElement() ?? "카페"
    }
    
    func recommend(area: String, category: String) async {
        guard !isLoading else {
            return
        }
        
        isLoading = true
        recommendedPlace = nil
        errorMessage = nil
        
        defer {
            isLoading = false
        }
        
        do {
            let searchCategory = randomCategory(from: category)
            print(searchCategory)

            let places = try await placeSearchService.search(query: "\(area) \(searchCategory)")
            
            let localPlaces = places.filter {
                !isExcludedPlace($0)
            }
            
            guard let place = localPlaces.randomElement() else {
                errorMessage = "추천할 장소를 찾지 못했습니다."
                return
            }
            
            recommendedPlace = place
        } catch {
            errorMessage = "장소를 불러오지 못했습니다."
        }
    }
}
