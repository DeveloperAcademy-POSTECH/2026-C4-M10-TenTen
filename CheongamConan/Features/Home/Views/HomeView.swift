//
//  ContentView.swift
//  CheongamConan
//
//  Created by 정홍섭 on 7/10/26.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        NavigationView {
            NavigationLink(destination: AreaPickerView()) {
                Text("여행 시작하기")
            }
        }
    }
}

#Preview {
    HomeView()
}
