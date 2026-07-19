//
//  ArrivalPlaceSelectionModel.swift
//  CheongamConan
//
//  Created by 정홍섭 on 7/19/26.
//

import Foundation
import Observation
import SwiftData

@MainActor
@Observable
final class ArrivalPlaceSelectionModel {
    private(set) var recommendedPlace: RecommendedPlace?
    
    func loadRecommendPlace(modelContext: ModelContext) {
        var descriptor = FetchDescriptor<RecommendedPlace>()
        descriptor.fetchLimit = 1
        
        recommendedPlace = try? modelContext.fetch(descriptor).first
    }
}
