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
                locationService: locationService
            )
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
