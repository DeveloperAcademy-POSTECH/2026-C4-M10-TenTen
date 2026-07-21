//
//  NaverPlaceSearchService.swift
//  CheongamConan
//
//  Created by 정홍섭 on 7/15/26.
//

import Foundation

struct NaverPlaceSearchService {
    func search(query: String, display: Int = 5) async throws -> [Place] {
        guard var components = URLComponents(
            string: "https://naverapihub.apigw.ntruss.com/search/v1/local"
        ) else {
            throw NaverPlaceSearchError.invalidURL
        }
        
        components.queryItems = [
            URLQueryItem(name: "query", value: query),
            URLQueryItem(name: "display", value: String(display)),
            URLQueryItem(name: "start", value: String(1)),
            URLQueryItem(name: "sort", value: "comment"),
            URLQueryItem(name: "format", value: "json")
        ]
        
        guard let url = components.url else {
            throw NaverPlaceSearchError.invalidURL
        }
        
        var request = URLRequest(url: url)
        
        request.setValue(
            AppConfig.searchClientID,
            forHTTPHeaderField: "X-NCP-APIGW-API-KEY-ID"
        )
        
        request.setValue(
            AppConfig.searchClientSecret,
            forHTTPHeaderField: "X-NCP-APIGW-API-KEY"
        )
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let response = response as? HTTPURLResponse else {
            throw NaverPlaceSearchError.invalidResponse
        }
        
        guard 200..<300 ~= response.statusCode else {
            let responseBody = String(
                data: data,
                encoding: .utf8
            ) ?? "응답 본문 없음"
            
            print("네이버 API 상태 코드:", response.statusCode)
            print("네이버 API 오류 응답:", responseBody)
            
            throw NaverPlaceSearchError.requestFailed(
                statusCode: response.statusCode
            )
        }
        
        let result = try JSONDecoder().decode(
            NaverPlaceSearchResponse.self,
            from: data
        )
        
        return result.items
    }
}

private struct NaverPlaceSearchResponse: Decodable {
    let items: [Place]
}



enum NaverPlaceSearchError: Error {
    case invalidURL
    case invalidResponse
    case requestFailed(statusCode: Int)
}
