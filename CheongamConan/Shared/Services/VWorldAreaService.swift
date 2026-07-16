//
//  VWorldAreaService.swift
//  CheongamConan
//
//  Created by 정홍섭 on 7/13/26.
//

import Foundation
import CoreLocation

struct VWorldAreaService {
    private let apiKey: String
    private let session: URLSession
    
    init(apiKey: String = AppConfig.vWorldAPIKey, session: URLSession = .shared) {
        self.apiKey = apiKey
        self.session = session
    }
    
    func fetchAreas(
        around coordinate: CLLocationCoordinate2D,
        radius: Int = 10_000
    ) async throws -> [MapPolygon] {
        let url = try makeURL(coordinate: coordinate, radius: radius)
        
        let (data, res) = try await session.data(from: url)
        
        guard let httpResponse = res as? HTTPURLResponse,
              200..<300 ~= httpResponse.statusCode else {
            throw VWorldAreaError.invalidResponse
        }
        
        let decodedResponse = try JSONDecoder().decode(
            VWorldResponse.self,
            from: data
        )
        
        guard decodedResponse.response.status == "OK" else {
            let message = decodedResponse.response.error?.text ?? "브이월드 API 요청에 실패했습니다."
            
            throw VWorldAreaError.apiError(message)
        }
        
        let features = decodedResponse.response.result?.featureCollection.features ?? []
        
        return features.flatMap { feature in
            makeMapPolygons(from: feature)
        }
    }
}

private extension VWorldAreaService {
    func makeURL(coordinate: CLLocationCoordinate2D, radius: Int) throws -> URL {
        var components = URLComponents(string: "https://api.vworld.kr/req/data")
        
        let point = "POINT(\(coordinate.longitude) \(coordinate.latitude))"
        
        components?.queryItems = [
            URLQueryItem(
                name: "service",
                value: "data"
            ),
            URLQueryItem(
                name: "version",
                value: "2.0"
            ),
            URLQueryItem(
                name: "request",
                value: "GetFeature"
            ),
            URLQueryItem(
                name: "key",
                value: apiKey
            ),
            URLQueryItem(
                name: "data",
                value: "LT_C_ADEMD_INFO"
            ),
            URLQueryItem(
                name: "format",
                value: "json"
            ),
            URLQueryItem(
                name: "crs",
                value: "EPSG:4326"
            ),
            URLQueryItem(
                name: "geometry",
                value: "true"
            ),
            URLQueryItem(
                name: "attribute",
                value: "true"
            ),
            URLQueryItem(
                name: "size",
                value: "1000"
            ),
            URLQueryItem(
                name: "page",
                value: "1"
            ),
            URLQueryItem(
                name: "geomFilter",
                value: point
            ),
            URLQueryItem(
                name: "buffer",
                value: String(radius)
            )
        ]
        
        guard let url = components?.url else {
            throw VWorldAreaError.invalidURL
        }
        
        return url
    }
    
    func makeMapPolygons(
        from feature: VWorldFeature
    ) -> [MapPolygon] {
        feature.geometry.polygons.enumerated().compactMap {
            index,
            rings in
            
            guard let exteriorRing = rings.first else {
                return nil
            }
            
            return MapPolygon(
                id: "\(feature.properties.code)-\(index)",
                name: feature.properties.fullName,
                exteriorRing: exteriorRing.compactMap(
                    makeCoordinate
                ),
                interiorRings: rings
                    .dropFirst()
                    .map { $0.compactMap(makeCoordinate) }
            )
        }
    }
    
    func makeCoordinate(
        from values: [Double]
    ) -> MapCoordinate? {
        guard values.count >= 2 else {
            return nil
        }
        
        return MapCoordinate(
            latitude: values[1],
            longitude: values[0]
        )
    }
}

enum VWorldAreaError: LocalizedError {
    case invalidURL
    case invalidResponse
    case apiError(String)
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "브이월드 API URL을 생성하지 못했습니다."
            
        case .invalidResponse:
            return "브이월드 API 응답이 올바르지 않습니다."
            
        case let .apiError(message):
            return message
        }
    }
}

private struct VWorldResponse: Decodable {
    let response: Response
    
    struct Response: Decodable {
        let status: String
        let result: Result?
        let error: APIError?
    }
    
    struct Result: Decodable {
        let featureCollection: FeatureCollection
    }
    
    struct FeatureCollection: Decodable {
        let features: [VWorldFeature]
    }
    
    struct APIError: Decodable {
        let code: String?
        let text: String?
    }
}

private struct VWorldFeature: Decodable {
    let properties: Properties
    let geometry: Geometry
    
    struct Properties: Decodable {
        let code: String
        let fullName: String
        let name: String
        
        enum CodingKeys: String, CodingKey {
            case code = "emd_cd"
            case fullName = "full_nm"
            case name = "emd_kor_nm"
        }
    }
    
    struct Geometry: Decodable {
        let type: GeometryType

        let polygons: [[[[Double]]]]
        
        enum CodingKeys: String, CodingKey {
            case type
            case coordinates
        }
        
        init(from decoder: Decoder) throws {
            let container = try decoder.container(
                keyedBy: CodingKeys.self
            )
            
            type = try container.decode(
                GeometryType.self,
                forKey: .type
            )
            
            switch type {
            case .polygon:
                let polygon = try container.decode(
                    [[[Double]]].self,
                    forKey: .coordinates
                )
                
                polygons = [polygon]
                
            case .multiPolygon:
                polygons = try container.decode(
                    [[[[Double]]]].self,
                    forKey: .coordinates
                )
            }
        }
    }
    
    enum GeometryType: String, Decodable {
        case polygon = "Polygon"
        case multiPolygon = "MultiPolygon"
    }
}
