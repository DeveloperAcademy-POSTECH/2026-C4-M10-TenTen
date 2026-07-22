//
//  EndJourneyView.swift
//  CheongamConan
//
//  Created by 정홍섭 on 7/22/26.
//

import SwiftUI

struct EndJourneyView: View {
    var body: some View {
        GeometryReader { geometry in
            let mapHeight = geometry.size.width * (437.0 / 402.0)
            
            VStack(spacing: 0) {
                Rectangle()
                    .fill(.blue100)
                    .frame(height: mapHeight)
                
                VStack(alignment: .leading) {
                    VStack(alignment: .leading, spacing: DSSpacing.spacing4) {
                        Text("오늘의 여정")
                            .font(DSTypography.H3)
                        
                        Text("1곳 방문")
                            .font(DSTypography.B2)
                    }
                    .foregroundStyle(.neutralBlack)
                    
                    Spacer()
                }
                .padding(.top, DSSpacing.spacing36)
                .padding(.top, DSSpacing.spacing20)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(.red100)
                .padding(.top, -16)
            }
        }
        .ignoresSafeArea(edges: .top)
    }
}

#Preview {
    EndJourneyView()
}
