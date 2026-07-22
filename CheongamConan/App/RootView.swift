//
//  RootView.swift
//  CheongamConan
//
//  Created by 정홍섭 on 7/12/26.
//

import SwiftUI
import SwiftData

struct RootView: View {
    @AppStorage("hasCompletedOnboarding")
    private var hasCompletedOnboarding = false

    @Query(
        filter: #Predicate<JourneySession> {
            !$0.isCompleted
        },
        sort: \JourneySession.updatedAt,
        order: .reverse
    )
    private var activeSessions: [JourneySession]

    var body: some View {
        ZStack {
            if hasCompletedOnboarding {
                NavigationStack {
                    mainContent
                }
                .transition(
                    .asymmetric(
                        insertion: .move(edge: .trailing)
                            .combined(with: .opacity),
                        removal: .move(edge: .leading)
                            .combined(with: .opacity)
                    )
                )
            } else {
                NavigationStack {
                    OnboardingView {
                        withAnimation(.easeInOut(duration: 0.45)) {
                            hasCompletedOnboarding = true
                        }
                    }
                }
                .transition(
                    .asymmetric(
                        insertion: .move(edge: .leading)
                            .combined(with: .opacity),
                        removal: .move(edge: .leading)
                            .combined(with: .opacity)
                    )
                )
            }
        }
        .animation(
            .easeInOut(duration: 0.45),
            value: hasCompletedOnboarding
        )
    }

    @ViewBuilder
    private var mainContent: some View {
        if let session = activeSessions.first {
            switch session.phase {
            case .journey:
                JourneyView(
                    area: session.area,
                    category: session.category,
                    journeySession: session,
                    initialDestination: session.destination
                )

            case .arrival:
                ArrivalPlaceSelectionView()
            }
        } else {
            HomeView()
        }
    }
}
