//
//  Category.swift
//  CheongamConan
//
//  Created by 정홍섭 on 7/13/26.
//

import Foundation

enum Category: String, CaseIterable, Identifiable, Hashable {
    case cafe
    case restaurant
    case landmark
    case random
    
    var id: Self {
        self
    }
    
    var title: String {
        switch self {
        case .restaurant:
            "식당"
        case .cafe:
            "카페"
        case .landmark:
            "명소"
        case .random:
            "랜덤"
        }
    }
    
    var imageName: String {
        switch self {
        case .cafe:
            "IconCafe"
        case .landmark:
            "IconLandmark"
        case .random:
            "IconRandom"
        case .restaurant:
            "IconRestaurant"
        }
    }
}
