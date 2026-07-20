//
//  JourneyModel.swift
//  CheongamConan
//
//  Created by Dayoon Lee on 7/20/26.
//

import Observation

// 여행 화면의 목적지, 페이지와 위치 추적 시작 흐름을 관리한다
@MainActor
@Observable
final class JourneyModel {
    enum Page: Hashable {
        case destination
        case tracking
    }

    var destination: RecommendedPlace?
    var currentPage: Page? = .destination

    // 여행 진행 화면 재진입 시 위치 추적이 중복 시작되지 않도록 관리
    private(set) var hasStartedTracking = false

    let trackingModel: JourneyTrackingModel

    init(
        destination: RecommendedPlace? = nil,
        trackingModel: JourneyTrackingModel? = nil
    ) {
        self.destination = destination
        self.trackingModel = trackingModel ?? JourneyTrackingModel()
    }

    func updateDestination(_ destination: RecommendedPlace) {
        self.destination = destination
        // TODO: 목적지 진행 상태가 추가되면 추천 단계에서만 변경하도록 제한
        // 하나의 여행에서 목적지 도착 후 다음 목적지를 추천받는 흐름 고려
    }

    func moveToTracking() {
        guard destination != nil else {
            return
        }
        currentPage = .tracking
    }

    func startJourneyIfNeeded(
        locationService: LocationService
    ) {
        guard !hasStartedTracking else { return }
        guard locationService.isAuthorized else { return }

        hasStartedTracking = true

        connectLocationService(locationService)
        trackingModel.beginJourney()
        locationService.startUpdatingLocation()
    }

    private func connectLocationService(
        _ locationService: LocationService
    ) {
        let trackingModel = trackingModel

        locationService.onLocationsReceived = {
            [weak trackingModel] locations in
            trackingModel?.receive(locations)
        }
    }
}
