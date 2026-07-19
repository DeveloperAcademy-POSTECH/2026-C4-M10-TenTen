//
//  SearchResultPlace.swift
//  CheongamConan
//
//  Created by 정홍섭 on 7/20/26.
//

import Foundation

struct SearchResultPlaceResponse: Decodable {
    let documents: [SearchResultPlace]
}

struct SearchResultPlace: Decodable {
    let placeName: String
    let categoryName: String
    let addressName: String
    let roadAddressName: String
    let longitude: String
    let latitude: String
    let placeURL: String
    
    enum CodingKeys: String, CodingKey {
        case placeName = "place_name"
        case categoryName = "category_name"
        case addressName = "address_name"
        case roadAddressName = "road_address_name"
        case longitude = "x"
        case latitude = "y"
        case placeURL = "place_url"
    }
    
    func toDomain() -> Place? {
        guard let longitude = Double(longitude), let latitude = Double(latitude) else {
            return nil
        }
        
        return Place(
            name: placeName,
            category: categoryName,
            address: addressName,
            roadAddress: roadAddressName,
            latitude: latitude,
            longitude: longitude,
            link: URL(string: placeURL)
        )
    }
}
