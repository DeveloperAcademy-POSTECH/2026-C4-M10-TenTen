//
//  JourneyModel.swift
//  CheongamConan
//
//  Created by Dayoon Lee on 7/20/26.
//

import CoreLocation
import Observation
import SwiftData
import UIKit

// 여행 화면의 목적지, 위치 추적 및 미션 저장 흐름을 관리한다
@MainActor
@Observable
final class JourneyModel {
    var destination: RecommendedPlace?
    
    // 여행 진행 화면 재진입 시 위치 추적이 중복 시작되지 않도록 관리
    private(set) var hasStartedTracking = false
    
    private(set) var missionStorageError: Error? = nil
    
    private(set) var isCompletingMission = false // 비동기 완료 처리 중 동일 미션이 중복 제출되는 것을 방지
    private let missionImageStorageService: MissionImageStorageService
    
    let trackingModel: JourneyTrackingModel
    
    init(
        destination: RecommendedPlace? = nil,
        trackingModel: JourneyTrackingModel? = nil,
        missionImageStorageService: MissionImageStorageService? = nil
    ) {
        self.destination = destination
        self.trackingModel = trackingModel ?? JourneyTrackingModel()
        self.missionImageStorageService = missionImageStorageService ?? MissionImageStorageService()
    }
    
    func updateDestination(_ destination: RecommendedPlace) {
        self.destination = destination
        // TODO: 목적지 진행 상태가 추가되면 추천 단계에서만 변경하도록 제한
        // 하나의 여행에서 목적지 도착 후 다음 목적지를 추천받는 흐름 고려
    }
    
    func startJourneyIfNeeded(
        locationService: LocationService,
        notificationService: NotificationService,
        missionStorageModel: MissionStorageModel,
        modelContext: ModelContext
        
    ) {
        guard !hasStartedTracking else { return }
        guard locationService.isAuthorized else { return }
        
        hasStartedTracking = true
        
        connectLocationService(locationService)
        connectSubQuestHandling(
            notificationService: notificationService,
            missionStorageModel: missionStorageModel,
            modelContext: modelContext
        )
        trackingModel.beginJourney()
        
        JourneyRouteStorage.clear()
        
        locationService.startUpdatingLocation(
            allowsBackgroundUpdates: true
        )
        
        if locationService.authorizationStatus == .authorizedWhenInUse {
            locationService.requestAlwaysAuthorization()
        }
    }
    
    private func connectLocationService(
        _ locationService: LocationService
    ) {
        let trackingModel = trackingModel
        
        locationService.onLocationsReceived = {
            [weak trackingModel] locations in
            
            trackingModel?.receive(locations)
            
            JourneyRouteStorage.append(locations)
        }
    }
    
    private func connectSubQuestHandling(
        notificationService: NotificationService,
        missionStorageModel: MissionStorageModel,
        modelContext: ModelContext
    ) {
        trackingModel.onSubQuestTriggered = {
            [weak self] subQuest in
            
            guard let self,
                  let destination else {
                return
            }
            
            let missionRecord = MissionRecord(
                id: subQuest.id,
                recommendedPlaceID: destination.id,
                title: subQuest.title,
                unlockedAt: subQuest.triggeredAt
            )
            
            do {
                try missionStorageModel.save(
                    missionRecord,
                    modelContext: modelContext
                )
                missionStorageError = nil
            } catch {
                missionStorageError = error
            }
            
            Task {
                await notificationService.notifySubQuest(subQuest)
            }
        }
    }
    
    func completeSubQuest(
        _ subQuest: SubQuest,
        image: UIImage,
        missionStorageModel: MissionStorageModel,
        modelContext: ModelContext
    ) async throws {
        guard !isCompletingMission else {
            throw MissionCompletionError.alreadyInProgress
        }
        isCompletingMission = true
        defer {
            isCompletingMission = false
        }
        
        // 1. 인증 이미지 파일 저장
        let fileName = try await missionImageStorageService.save(
            image,
            missionID: subQuest.id
        )
        
        // 2. 저장된 미션 완료 정보 갱신
        do {
            try missionStorageModel.completeMission(
                id: subQuest.id,
                imageFileName: fileName,
                modelContext: modelContext
            )
        } catch {
            // 미션 완료 정보가 저장되지 않으면 참조되지 않는 이미지가 남으므로 삭제한다
            try? await missionImageStorageService.delete(
                fileName: fileName
            )
            throw error
        }
        // 3. 파일과 SwiftData 저장이 모두 성공한 뒤 화면 상태를 완료로 변경한다
        trackingModel.completeSubQuest(id: subQuest.id)
    }
}

enum MissionCompletionError: Error {
    case alreadyInProgress
}
