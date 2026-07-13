//
//  MapPolygon.swift
//  CheongamConan
//
//  Created by 정홍섭 on 7/13/26.
//

import Foundation

struct MapPolygon: Identifiable, Equatable {
    let id: String
    let name: String
    
    let exteriorRing: [MapCoordinate]
    
    let interiorRings: [[MapCoordinate]]
}

struct MapCoordinate: Equatable {
    let latitude: Double
    let longitude: Double
}
