//
//  RootView.swift
//  CheongamConan
//
//  Created by 정홍섭 on 7/12/26.
//

import SwiftUI

struct RootView: View {
    
    @AppStorage("hasCompletedOnboarding")
    private var hasCompletedOnboarding: Bool = false
    
    var body: some View {
        NavigationStack {
            Group {
                if hasCompletedOnboarding {
                    HomeView()
                        .transition(
                            .move(edge: .trailing)
                            .combined(with: .opacity)
                        )
                        .zIndex(0)
                } else {
                    OnboardingView {
                        hasCompletedOnboarding = true
                    }
                    .transition(
                        .move(edge: .leading)
                        .combined(with: .opacity)
                    )
                    .zIndex(1)
                }
            }
            .animation(
                .easeInOut(duration: 0.6),
                value: hasCompletedOnboarding
            )
        }
    }
}
