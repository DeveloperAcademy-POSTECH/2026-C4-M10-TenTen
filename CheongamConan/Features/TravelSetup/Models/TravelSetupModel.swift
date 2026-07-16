//
//  TravelSetupModel.swift
//  CheongamConan
//
//  Created by 정홍섭 on 7/13/26.
//

import Observation

@MainActor
@Observable
final class TravelSetupModel {
    private(set) var selectedAreaName: String?
    private(set) var selectedCategory: Category?
    
    func selectArea(_ areaName: String) {
        selectedAreaName = areaName
    }
    
    
    func selectCategory(_ category: Category) {
        selectedCategory = category
    }
    
    func reset() {
        selectedAreaName = nil
        selectedCategory = nil
    }
    
    func cofirmCategory(_ category: Category) -> String? {
        guard let selectedAreaName else {
            return nil
        }
        
        selectedCategory = category
        return selectedAreaName
    }
}
