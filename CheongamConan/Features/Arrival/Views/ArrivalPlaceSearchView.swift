//
//  ArrivalPlaceSearchView.swift
//  CheongamConan
//
//  Created by 정홍섭 on 7/19/26.
//

import SwiftUI

struct ArrivalPlaceSearchView: View {
    @State private var name = ""
    @State private var model = ArrivalPlaceSearchModel()
    
    var body: some View {
        VStack(alignment: .leading) {
            searchField
            
            searchContent
        }
        .padding(.top, DSSpacing.spacing24)
        .onChange(of: name) { _, newValue in
            model.search(query: newValue)
        }
        .onDisappear {
            model.cancelSearch()
        }
    }
    
    private var searchField: some View {
        VStack(alignment: .leading) {
            Text("어디에 도착하셨나요?")
            
            TextField(
                "도착한 가게 이름을 입력해주세요.",
                text: $name
            )
            .textInputAutocapitalization(.never)
            .autocorrectionDisabled()
            .submitLabel(.search)
        }
        .padding(.horizontal, DSSpacing.contentHorizontal)
    }
    
    @ViewBuilder
    private var searchContent: some View {
        if name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            Spacer()
        } else if model.isLoading {
            centeredContent {
                ProgressView()
            }
        } else if model.places.isEmpty {
            centeredContent {
                Text("검색 결과가 없음")
            }
        } else {
            placeResults
        }
    }
    
    private var placeResults: some View {
        VStack(alignment: .leading) {
            Text("장소 결과")
                .padding(.horizontal, DSSpacing.contentHorizontal)
            
            ScrollView {
                ForEach(model.places) { place in
                    PlaceResultItem(place: place)
                }
            }
        }
    }
    
    private func centeredContent<Content: View>(
        @ViewBuilder content: () -> Content
    ) -> some View {
        VStack {
            content()
            
            Spacer()
        }
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    ArrivalPlaceSearchView()
}
