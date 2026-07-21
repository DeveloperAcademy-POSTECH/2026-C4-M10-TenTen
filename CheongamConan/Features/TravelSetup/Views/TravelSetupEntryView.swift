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
                VStack(spacing: 120) {
                    Text("NAGAM")
                        .font(DSTypography.H1)
                        .foregroundStyle(.main400)
                    
                    VStack(spacing: 28) {
                        ProgressView()
                            .tint(.main900)
                            .controlSize(.large)
                        
                        Text("잠시 후 여행이 시작돼요")
                            .font(DSTypography.B2)
                            .foregroundStyle(.main900)
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(.main250)
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
