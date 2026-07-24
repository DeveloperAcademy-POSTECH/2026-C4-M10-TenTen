//
//  JourneyTrackingModel.swift
//  CheongamConan
//
//  Created by Dayoon Lee on 7/13/26.
//
import CoreLocation
import Foundation
import Observation

enum JourneyTrackingState {
    case idle
    case waitingForStartLocation
    case tracking
    case completed
}

/// 한 번의 여정에서 발생하는 위치와 서브 퀘스트 상태를 관리한다.
///
/// 위치 권한과 Core Location 연동은 `LocationService`의 책임이다.
/// 서브 퀘스트 기록과 완료 상태의 Single Source of Truth는
/// `triggeredSubQuests`이다.
@MainActor
@Observable
final class JourneyTrackingModel {
    // MARK: - Journey State
    
    private(set) var state: JourneyTrackingState = .idle
    private(set) var startedAt: Date?
    private(set) var endedAt: Date?
    
    // MARK: - Location State
    
    private(set) var startLocation: CLLocation?
    private(set) var currentLocation: CLLocation?
    private(set) var routeLocations: [CLLocation] = []
    private(set) var distanceFromStart: CLLocationDistance = 0 // 서브 퀘스트 발생 조건으로 활용
    private(set) var totalDistance: CLLocationDistance = 0
    
    // MARK: - SubQuest State
    
    private let subQuestTriggerRule = SubQuestTriggerRule(distanceThreshold: 25)
    private let missionProvider: MissionProvider?
    private(set) var missionLoadingError: Error?
    
    /// 현재는 기존 동작을 유지하기 위해
    /// 한 Journey에서 서브 퀘스트를 한 번만 발생시킨다
    private var hasTriggeredSubQuest: Bool = false
    private var activeSubQuestID: SubQuest.ID? // 현재 사용자에게 표시 중인 퀘스트 지정
    
    private(set) var triggeredSubQuests: [SubQuest] = []

    var onSubQuestTriggered: ((SubQuest) -> Void)?
    var activeSubQuest: SubQuest? {
        guard let activeSubQuestID else { return nil }
        
        return triggeredSubQuests.first {
            $0.id == activeSubQuestID
        }
    }

    init(missionProvider: MissionProvider? = nil) {
        if let missionProvider {
            self.missionProvider = missionProvider
            missionLoadingError = nil
            return
        }

        do {
            self.missionProvider = try MissionProvider()
            missionLoadingError = nil
        } catch {
            self.missionProvider = nil
            missionLoadingError = error
        }
    }
    
    // MARK: - Journey Lifecycle
    
    // 여행을 시작할 준비를 하고, 첫 번째 유효 위치를 시작점으로 기다린다
    func beginJourney(at date: Date = .now) {
        resetJourneyData()
        startedAt = date
        state = .waitingForStartLocation
    }
    
    // LocationService가 전달한 위치 묶음을 시간 순서대로 처리한다
    func receive(_ locations: [CLLocation]) {
        guard state == .waitingForStartLocation || state == .tracking else {
            return
        }
        
        for location in locations where location.horizontalAccuracy >= 0 {
            accept(location)
        }
    }
    
    // 현재까지 기록한 경로를 유지한 채 여행 상태만 종료로 바꾼다.
    func endJourney(at date: Date = .now) {
        guard state == .waitingForStartLocation || state == .tracking else {
            return
        }
        
        endedAt = date
        state = .completed
    }
    
    // 여행 기록 초기화
    func reset() {
        resetJourneyData()
        state = .idle
    }
    
    // MARK: - SubQuest Actions
    
    // 퀘스트 완료 처리 (배열에서만 관리)
    func completeSubQuest(id: SubQuest.ID) {
        guard let index = triggeredSubQuests.firstIndex(
            where: { $0.id == id }
        ) else {
            assertionFailure(
                "완료할 서브 퀘스트가 기록에 존재하지 않습니다."
            )
            return
        }
        triggeredSubQuests[index].isCompleted = true
    }
    
    // MARK: - Location Processing
    
    // 유효한 위치 데이터를 여행 기록에 추가
    private func accept(_ location: CLLocation) {
        // 첫 번째 위치 추가
        if state == .waitingForStartLocation {
            startLocation = location
            currentLocation = location
            routeLocations = [location]
            state = .tracking
            return
        }
        
        guard state == .tracking,
              let startLocation,
              let previousLocation = routeLocations.last else {
            return
        }
        currentLocation = location
        routeLocations.append(location)
        distanceFromStart = startLocation.distance(from: location)
        totalDistance += previousLocation.distance(from: location)
        activateSubQuestIfNeeded()
    }
    
    // MARK: - SubQuest Processing
    
    // 서브 퀘스트 발생 조건을 만족하는지 검사한다
    private func activateSubQuestIfNeeded() {
        guard !hasTriggeredSubQuest else {
            return
        }
        guard subQuestTriggerRule.matches(
            distanceFromStart: distanceFromStart
        ) else {
            return
        }
        guard let subQuest = missionProvider?.makeRandomSubQuest() else {
            return
        }
        activate(subQuest)
        hasTriggeredSubQuest = true
    }
    
    // 퀘스트가 발생하면 배열에 추가하고 활성 ID를 설정한다
    private func activate(_ subQuest: SubQuest) {
        triggeredSubQuests.append(subQuest)
        activeSubQuestID = subQuest.id
        onSubQuestTriggered?(subQuest) // 퀘스트 발생 이벤트를 외부로 전달
    }
    
    // MARK: - Reset
    
    private func resetJourneyData() {
        startedAt = nil
        endedAt = nil
        startLocation = nil
        currentLocation = nil
        activeSubQuestID = nil
        routeLocations = []
        distanceFromStart = 0
        totalDistance = 0
        hasTriggeredSubQuest = false
        triggeredSubQuests = []
    }

    // MARK: - Debugging
    #if DEBUG
    func triggerSubQuestForDebug(after delay: Duration) {
        Task {
            @MainActor
            [weak self] in
            try? await Task.sleep(for: delay)

            guard let self, !hasTriggeredSubQuest else {
                return
            }
            guard let subQuest = missionProvider?.makeRandomSubQuest() else {
                return
            }
            activate(subQuest)
            hasTriggeredSubQuest = true
        }
    }

    func resetSubQuestForDebug() {
        activeSubQuestID = nil
        hasTriggeredSubQuest = false
        triggeredSubQuests = []
    }
    #endif

}

#if DEBUG
extension JourneyTrackingModel {
    static func preview(
        activeSubQuest: SubQuest? = nil
    ) -> JourneyTrackingModel {
        let model = JourneyTrackingModel()
        
        guard let activeSubQuest else {
            return model
        }
        
        model.triggeredSubQuests = [activeSubQuest]
        model.activeSubQuestID = activeSubQuest.id
        
        return model
    }
}
#endif
