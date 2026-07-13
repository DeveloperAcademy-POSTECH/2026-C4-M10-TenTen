//
//  JourneyTrackingModel.swift
//  CheongamConan
//
//  Created by Dayoon Lee on 7/13/26.
//
import CoreLocation
import Observation
import Foundation

enum JourneyTrackingState {
    case idle
    case waitingForStartLocation
    case tracking
    case completed
}

/// 여행이 시작된 시점부터 종료될 때까지의 위치와 이동 거리를 관리한다
/// Core Location 접근과 서브 퀘스트 발생 조건은 이 모델의 책임이 아니다
@MainActor
@Observable
final class JourneyTrackingModel {
    private(set) var state: JourneyTrackingState = .idle

    private(set) var startedAt: Date?
    private(set) var endedAt: Date?

    private(set) var startLocation: CLLocation?
    private(set) var currentLocation: CLLocation?
    private(set) var routeLocations: [CLLocation] = []

    private(set) var distanceFromStart: CLLocationDistance = 0 // 서브 퀘스트 발생 조건으로 활용
    private(set) var totalDistance: CLLocationDistance = 0

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

    // 유효한 위치 데이터를 여행 기록에 추가
    private func accept(_ location: CLLocation) {
        // 첫 번쨰 위치 추가
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
        // 현재 위치 갱신
        currentLocation = location
        routeLocations.append(location)
        distanceFromStart = startLocation.distance(from: location)
        totalDistance += previousLocation.distance(from: location)
    }

    private func resetJourneyData() {
        startedAt = nil
        endedAt = nil
        startLocation = nil
        currentLocation = nil
        routeLocations = []
        distanceFromStart = 0
        totalDistance = 0
    }
}
