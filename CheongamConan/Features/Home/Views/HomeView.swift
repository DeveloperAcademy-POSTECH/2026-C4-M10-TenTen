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
            NavigationLink(destination: TravelSetupEntryView()) {
                Text("여행 시작하기")
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
}

#Preview {
    HomeView()
}
