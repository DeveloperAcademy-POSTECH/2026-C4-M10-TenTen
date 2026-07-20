//
//  ContentView.swift
//  CheongamConan
//
//  Created by 정홍섭 on 7/10/26.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        NavigationStack {
            ZStack {
                Image("Background")
                    .resizable()
                    .scaledToFill()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .clipped()
                    .ignoresSafeArea()
                
                VStack(alignment: .leading) {
                    VStack(alignment: .leading, spacing: DSSpacing.spacing12) {
                        Text("목적지를 정하는 과정이 복잡하고\n부담스러워서 망설이지 않으셨나요?")
                            .foregroundStyle(.neutralWhite)
                            .font(DSTypography.C2)
                        
                        Text("NAGAM 으로\n목적지를 추천 받고\n여행을 떠나보세요.")
                            .foregroundStyle(.neutralWhite)
                            .font(DSTypography.H3)
                    }
                    
                    Spacer()
                    
                    // TODO: 추후 버튼을 공통 컴포넌트로 분리
                    NavigationLink(destination: TravelSetupEntryView()) {
                        Text("여행 시작하기")
                            .padding(.vertical, DSSpacing.spacing16)
                            .font(DSTypography.B1)
                            .frame(maxWidth: .infinity)
                            .background(.main400)
                            .foregroundStyle(.neutralWhite)
                            .cornerRadius(DSRadius.standard)
                    }
                }
                .padding(.horizontal, DSSpacing.contentHorizontal)
                .padding(.bottom, DSSpacing.spacing56)
                .padding(.top, 193)
            }
        }
    }
}

#Preview {
    HomeView()
}
