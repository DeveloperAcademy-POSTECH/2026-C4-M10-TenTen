//
//  ContentView.swift
//  CheongamConan
//
//  Created by 정홍섭 on 7/10/26.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
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
                    
                    NavigationLink(destination: TravelSetupEntryView()) {
                        Text("여행 시작하기")
                    }
                    .buttonStyle(
                        DSButtonStyle(
                            backgroundColor: .main400,
                            foregroundColor: .neutralWhite
                        )
                    )
                }
                .padding(.horizontal, DSSpacing.contentHorizontal)
                .padding(.bottom, DSSpacing.spacing56)
                .padding(.top, 193)
            }
            #if DEBUG
            NavigationLink {
                MissionImageStorageDebugView()
            } label: {
                Text("이미지 저장 테스트")
            }
            #endif
    }
}

#Preview {
    HomeView()
}
