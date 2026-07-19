//
//  TravelSetupEntryView.swift
//  CheongamConan
//
//  Created by 정홍섭 on 7/19/26.
//

import SwiftUI

struct TravelSetupEntryView: View {
    @State private var isReady = false
    
    var body: some View {
        ZStack {
            if isReady {
                TravelSetupView()
            } else {
                ProgressView()
                    .frame(
                        maxWidth: .infinity,
                        maxHeight: .infinity
                    )
            }
        }
        .navigationBarBackButtonHidden()
        .onAppear {
            prepareTravelSetupView()
        }
    }
    
    private func prepareTravelSetupView() {
        Task { @MainActor in
            try? await Task.sleep(
                for: .milliseconds(450)
            )
            
            guard !Task.isCancelled else {
                return
            }
            
            isReady = true
        }
    }
}

#Preview {
    TravelSetupEntryView()
}
