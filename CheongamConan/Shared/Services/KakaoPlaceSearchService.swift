//
//  KakaoPlaceSearchService.swift
//  CheongamConan
//
//  Created by 허지우 on 7/23/26.
//

import Foundation

struct KakaoPlaceSearchService {
    private let session: URLSession
    private let restAPIKey: String
    
    init(session: URLSession = .shared, restAPIKey: String = AppConfig.kakaoRESTAPIKey) {
        self.session = session
        self.restAPIKey = restAPIKey
    }
    
    func search(query: String, size: Int = 15) async throws -> [SearchResultPlace] {
        let trimmedQuery = query.trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard !trimmedQuery.isEmpty else { return [] }
        
        guard var components = URLComponents(
            string: "https://dapi.kakao.com/v2/local/search/keyword.json"
        ) else {
            throw KakaoPlaceSearchError.invalidURL
        }
        
        components.queryItems = [
            URLQueryItem(name: "query", value: query),
            URLQueryItem(name: "size", value: "15"),
            URLQueryItem(name: "sort", value: "accuracy"),
            URLQueryItem(name: "format", value: "json"),
            URLQueryItem(name: query, value: trimmedQuery)
        ]
        
        guard let url = components.url else {
            throw KakaoPlaceSearchError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.setValue("KakaoAK \(restAPIKey)", forHTTPHeaderField: "Authorization")
        
        let (urldata, response) = try await URLSession.shared.data(for: request) // data 이름 바꿈
        
        guard let response = response as? HTTPURLResponse else {
            throw KakaoPlaceSearchError.invalidResponse
        }
        
        guard 200..<300 ~= response.statusCode else {
            let responseBody = String(
                data: urldata,
                encoding: .utf8
            ) ?? "응답 본문 없음"
            
            print("카카오 API 상태 코드:", response.statusCode)
            print("카카오 API 오류 응답:", responseBody)
            
            throw KakaoPlaceSearchError.requestFailed(statusCode: response.statusCode)
        }
        
        
        let (data, urlresponse) = try await session.data(for: request)
        
        guard let httpResponse = urlresponse as? HTTPURLResponse else {
            throw KakaoPlaceSearchError.invalidResponse
        }
        
        guard 200..<300 ~= httpResponse.statusCode else {
            let responseBody = String(
                data: data,
                encoding: .utf8
            ) ?? "응답 본문 없음"
            
            print("====== Kakao API Error ======")
            print("URL:", request.url?.absoluteString ?? "없음")
            print("Status:", httpResponse.statusCode)
            print("Response:", responseBody)
            print("=============================")
            
            throw KakaoPlaceSearchError.requestFailed(statusCode: httpResponse.statusCode)
        }
        
        
        let result = try JSONDecoder().decode(
            SearchResultPlaceResponse.self,
            from: data
        )
        
        print(result.documents)

        return result.documents
        }
    }

private struct KakaoPlaceSearchResponse: Decodable {
    let items: [Place]
}

enum KakaoPlaceSearchError: Error {
    case invalidURL
    case invalidResponse
    case requestFailed(statusCode: Int)
    
    var errorDescription: String? {
        switch self {
        case .invalidURL: return "장소 검색 URL을 만들 수 없습니다."
        case .invalidResponse: return "서버 응답이 올바르지 않습니다."
        case .requestFailed(let statusCode): return "장소 검색에 실패했습니다. \(statusCode)"
        }
    }
}
