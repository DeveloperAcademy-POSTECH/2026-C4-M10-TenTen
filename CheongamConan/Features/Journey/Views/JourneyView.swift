//
//  JourneyView.swift
//  CheongamConan
//
//  Created by Dayoon Lee on 7/18/26.
//

import SwiftUI

struct JourneyView: View {
    let area: String
    let category: String

    @Environment(LocationService.self) private var locationService
    @Environment(NotificationService.self) private var notificationService

    @State private var model: JourneyModel

    init(
        area: String,
        category: String,
        initialDestination: RecommendedPlace? = nil
    ) {
        self.area = area
        self.category = category
        _model = State(
            initialValue: JourneyModel(
                destination: initialDestination
            )
        )
    }
    
    var body: some View {
        @Bindable var model = model

        ScrollView(.vertical) {
            VStack(spacing: 0) {
                DestinationView(
                    area: area,
                    category: category,
                    onDestinationLoaded: { place in
                        model.updateDestination(place)
                    },
                    onMoveToTracking: {
                        model.moveToTracking()
                    }
                )
                .containerRelativeFrame(.vertical)
                .id(JourneyModel.Page.destination)

                if let destination = model.destination {
                    JourneyTrackingView(
                        destination: destination,
                        trackingModel: model.trackingModel
                    )
                    .containerRelativeFrame(.vertical)
                    .id(JourneyModel.Page.tracking)
                }
            }
            .scrollTargetLayout()
        }
        .scrollTargetBehavior(.paging)
        .scrollPosition(id: $model.currentPage)
        .onChange(of: model.currentPage) { _, newPage in
            guard newPage == .tracking else {
                return
            }
            model.startJourneyIfNeeded(
                locationService: locationService,
                notificationService: notificationService
            )
        }
        #if DEBUG
        .overlay(alignment: .topTrailing) {
            debugSubQuestControls
        }
        #endif
    }

    #if DEBUG
    private var debugSubQuestControls: some View {
        VStack(alignment: .trailing) {
            Button("5초 후 퀘스트 발생") {
                model.trackingModel.triggerSubQuestForDebug(
                    after: .seconds(5)
                )
            }
            Button("10초 후 퀘스트 발생") {
                model.trackingModel.triggerSubQuestForDebug(
                    after: .seconds(10)
                )
            }
            Button("퀘스트 리셋") {
                model.trackingModel.resetSubQuestForDebug()
            }
        }
    }
    #endif
}

#Preview {
    JourneyView(
        area: "포항시 남구",
        category: "카페",
        initialDestination: .preview
    )
    .environment(LocationService())
    .environment(NotificationService())
}
