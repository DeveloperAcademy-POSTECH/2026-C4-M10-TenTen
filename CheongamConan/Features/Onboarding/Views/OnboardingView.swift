//
//  OnboardingView.swift
//  CheongamConan
//
//  Created by 정홍섭 on 7/11/26.
//

import SwiftUI

struct OnboardingView: View {
    @State private var isPermissionViewPresented: Bool = false
    
    let onCompleted: () -> Void

    var body: some View {
        ZStack {
            if isPermissionViewPresented {
                PermissionView(
                    onCompleted: onCompleted
                )
                    .transition(
                        .move(edge: .bottom)
                        .combined(with: .opacity)
                    )
            } else {
                IntroductionView()
                    .transition(
                        .move(edge: .top)
                        .combined(with: .opacity)
                    )
            }
        }
        .task {
            try? await Task.sleep(nanoseconds: 2_000_000_000)
            
            guard !Task.isCancelled else { return }
            
            withAnimation(.easeOut(duration: 1.5)) {
                isPermissionViewPresented = true
            }
        }
    }
}

#Preview {
    OnboardingView(onCompleted: {})
        .environment(LocationService())
}
