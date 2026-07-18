//
//  JourneyView.swift
//  CheongamConan
//
//  Created by Dayoon Lee on 7/18/26.
//

import SwiftUI

struct JourneyView: View {
    enum Page: Hashable {
        case destination
        case tracking
    }

    let area: String
    let category: String

    @Environment(LocationService.self) private var locationService

    @State private var destination: Place?
    @State private var currentPage: Page? = .destination
    @State private var hasEnteredTracking = false // Always Use
    @State private var trackingModel = JourneyTrackingModel()

    init(
        area: String,
        category: String,
        initialDestination: Place? = nil
    ) {
        self.area = area
        self.category = category
        _destination = State(initialValue: initialDestination)
    }

    var body: some View {
        ScrollView(.vertical) {
            VStack(spacing: 0) {
                DestinationView(
                    area: area,
                    category: category,
                    onDestinationLoaded: { place in
                        destination = place
                    },
                    onMoveToTracking: {
                        moveToTracking()
                    }
                )
                .containerRelativeFrame(.vertical)
                .id(Page.destination)

                if let destination {
                    JourneyTrackingView(
                        destination: destination,
                        trackingModel: trackingModel
                    )
                    .containerRelativeFrame(.vertical)
                    .id(Page.tracking)
                }
            }
            .scrollTargetLayout()
        }
        .scrollTargetBehavior(.paging)
        .scrollPosition(id: $currentPage)
        .onChange(of: currentPage) { _, newPage in
            guard newPage == .tracking else {
                return
            }
            startJourneyIfNeeded()
        }
    }

    private func moveToTracking() {
        guard destination != nil else {
            return
        }
        currentPage = .tracking
    }

    private func startJourneyIfNeeded() {
        guard !hasEnteredTracking else {
            return
        }

        guard locationService.isAuthorized else {
            return
        }

        hasEnteredTracking = true

        connectLocationService()
        trackingModel.beginJourney()
        locationService.startUpdatingLocation()

        // TODO: Always 위치 권한 요청
        // TODO: 백그라운드 위치 추적
    }

    private func connectLocationService() {
        let model = trackingModel

        locationService.onLocationsReceived = { [weak model] locations in
            model?.receive(locations)
        }
    }
}

#Preview {
    JourneyView(
        area: "포항시 남구",
        category: "카페",
        initialDestination: .preview
    )
    .environment(LocationService())
}
