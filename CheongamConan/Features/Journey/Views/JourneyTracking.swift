//
//  JourneyTracking.swift
//  CheongamConan
//
//  Created by Dayoon Lee on 7/13/26.
//

import SwiftUI
import CoreLocation

struct JourneyTrackingView: View {
    @Environment(LocationService.self) private var locationService
    
    @State private var trackingModel = JourneyTrackingModel()
    
    @State private var isSubQuestPresented: Bool = false
    var body: some View {
        NavigationStack {
            Form {
                permissionSection
                journeyControlSection
                trackingStatusSection
            }
            .navigationTitle("여행 추적 실험 | 서브 퀘스트 발생과 이동 위치 누적")
            .onAppear {
                connectLocationService()
            }
        }
    }
    
    private var permissionSection: some View {
        Section("위치 권한") {
            Text(authorizationText)
            
            if locationService.authorizationStatus == .notDetermined {
                Button("위치 권한 요청") {
                    locationService.requestAuthorization()
                }
            }
            
        }
    }
    
    private var journeyControlSection: some View {
        Section("여행 제어") {
            switch trackingModel.state {
            case .idle, .completed:
                Button("여행 시작") {
                    trackingModel.beginJourney()
                    locationService.startUpdatingLocation()
                }
                .disabled(!locationService.isAuthorized)
                
            case .waitingForStartLocation:
                Text("시작 위치 확인 중")
                
            case .tracking:
                Button("여행 종료하기") {
                    trackingModel.endJourney()
                    locationService.stopUpdatingLocation()
                }
            }
            Button("초기화", role: .destructive) {
                locationService.stopUpdatingLocation()
                trackingModel.reset()
            }
            .disabled(trackingModel.state == .idle)
        }
        
    }
    
    private var trackingStatusSection: some View {
        Section("추적 상태") {
            LabeledContent("상태", value: stateText)

            LabeledContent(
                "시작점에서 거리",
                value: "\(trackingModel.distanceFromStart.formatted(.number.precision(.fractionLength(1))))m"
            )

            LabeledContent(
                "누적 이동 거리",
                value: "\(trackingModel.totalDistance.formatted(.number.precision(.fractionLength(1))))m"
            )

            LabeledContent(
                "기록 위치 수",
                value: "\(trackingModel.routeLocations.count)개"
            )
        }
    }
    
    private var authorizationText: String {
        switch locationService.authorizationStatus {
        case .notDetermined:
            "권한 요청 전"
            
        case .authorizedWhenInUse:
            "앱 사용 중 허용"
            
        case .authorizedAlways:
            "항상 허용"
            
        case .denied:
            "권한 거절됨"
            
        case .restricted:
            "권한 제한됨"
            
        @unknown default:
            "알 수 없음"
        }
    }
    
    private var stateText: String {
        switch trackingModel.state {
        case .idle:
            "대기"
        case .waitingForStartLocation:
            "시작 위치 확인 중"
        case .tracking:
            "추적 중"
        case .completed:
            "종료됨"
        }
    }
    
    private func connectLocationService() {
        let model = trackingModel
        
        locationService.onLocationsReceived = { [weak model] locations in
            model?.receive(locations)
        }
    }
}


#Preview {
    JourneyTrackingView()
        .environment(LocationService())
}
