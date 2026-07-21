//
//  RootView.swift
//  CheongamConan
//
//  Created by 정홍섭 on 7/12/26.
//

import SwiftUI
import SwiftData
import Observation

@MainActor
@Observable
final class JourneyRouter {
    private(set) var session: JourneySession?

    func showJourney(_ session: JourneySession) {
        self.session = session
    }

    func dismissJourney() {
        session = nil
    }
}

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

    @State private var journeyRouter = JourneyRouter()

    var body: some View {
        NavigationStack {
            if hasCompletedOnboarding {
                mainContent
                    .transition(
                        .move(edge: .trailing)
                        .combined(with: .opacity)
                    )
            } else {
                OnboardingView {
                    withAnimation(.easeInOut(duration: 0.6)) {
                        hasCompletedOnboarding = true
                    }
                }
                .transition(
                    .move(edge: .leading)
                    .combined(with: .opacity)
                )
            }
        }
        .environment(journeyRouter)
        .fullScreenCover(isPresented: journeyPresentation) {
            NavigationStack {
                if let session = journeyRouter.session {
                    sessionContent(session)
                }
            }
            .environment(journeyRouter)
        }
    }

    @ViewBuilder
    private var mainContent: some View {
        // 새 여행을 시작한 동안에는 기존 설정 화면을 유지하고,
        // JourneyView는 fullScreenCover에서 단 한 번만 생성한다.
        if journeyRouter.session != nil {
            HomeView()
        } else if let session = activeSessions.first {
            sessionContent(session)
        } else {
            HomeView()
        }
    }

    @ViewBuilder
    private func sessionContent(_ session: JourneySession) -> some View {
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
    }

    private var journeyPresentation: Binding<Bool> {
        Binding(
            get: {
                guard let session = journeyRouter.session else {
                    return false
                }
                return !session.isCompleted
            },
            set: { isPresented in
                if !isPresented {
                    journeyRouter.dismissJourney()
                }
            }
        )
    }
}
