//
//  CategoryCheckModel.swift
//  CheongamConan
//
//  Created by Dayoon Lee on 7/22/26.
//
import SwiftData

@MainActor
@Observable
final class CategoryCheckModel {
    private(set) var isStartingJourney = false
    private(set) var errorMessage: String?
    
    private let destinationModel: DestinationModel
    
    init(destinationModel: DestinationModel? = nil) {
        self .destinationModel = destinationModel ?? DestinationModel()
    }
    /// 세션을 먼저 저장하면 RootView가 유일한 JourneyView를 생성한다.
    /// 이 화면에서 JourneyView를 직접 push하지 않아 추적 모델의 중복 생성을 막는다.
    func startJourney(
        area: String,
        category: Category,
        modelContext: ModelContext
    ) async -> JourneySession? {
        guard !isStartingJourney else { return nil }
        isStartingJourney = true
        
        isStartingJourney = true
        errorMessage = nil
        
        defer { isStartingJourney = false }
        
        
        await destinationModel.loadOrRecommend(
            area: area,
            category: category.rawValue,
            modelContext: modelContext
        )
        
        guard let destination = destinationModel.recommendedPlace else {
            errorMessage = destinationModel.errorMessage
            return nil
        }
        
        let session = JourneySession(
            area: area,
            category: category.rawValue,
            destination: destination
        )
        
        modelContext.insert(session)
        
        do {
            try modelContext.save()
            return session
        } catch {
            modelContext.delete(session)
            errorMessage = "여행을 시작하지 못했습니다"
            return nil
        }
    }
}
