//
//  ArrivalPlaceSearchView.swift
//  CheongamConan
//
//  Created by 정홍섭 on 7/19/26.
//

import SwiftUI
import SwiftData

struct ArrivalPlaceSearchView: View {
    @Environment(\.modelContext) private var modelContext
    
    @State private var name = ""
    @State private var model = ArrivalPlaceSearchModel()
    
    @State private var selectedPlace: Place?
    @State private var isPresentedConfirmView = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: DSSpacing.spacing20) {
            searchField
            
            searchContent
        }
        .padding(.top, DSSpacing.spacing28)
        .background(.grey50)
        .onChange(of: name) { _, newValue in
            model.search(query: newValue)
        }
        .onDisappear {
            model.cancelSearch()
        }
        .navigationDestination(
            isPresented: $isPresentedConfirmView
        ) {
            if let selectedPlace {
                ArrivalPlaceConfirmView(
                    place: selectedPlace.name
                )
            }
        }
    }
    
    private var searchField: some View {
        VStack(alignment: .leading, spacing: DSSpacing.spacing24) {
            Text("어디에 도착하셨나요?")
                .font(DSTypography.H3)
                .foregroundStyle(.main300)
            
            CustomTextField(placeholder: "도착지를 입력해주세요.", text: $name)
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
                VStack(spacing: DSSpacing.spacing4) {
                    Image(systemName: "exclamationmark.circle.fill")
                        .font(.system(size: 54))
                        .foregroundStyle(.grey600)
                    
                    Text("검색 결과가 없습니다.")
                        .font(DSTypography.C1)
                        .foregroundStyle(.neutralBlack)
                }
                .padding(.top, 33)
            }
        } else {
            placeResults
        }
    }
    
    private var placeResults: some View {
        VStack(alignment: .leading, spacing: DSSpacing.spacing20) {
            Text("장소 결과")
                .font(DSTypography.C2)
                .foregroundStyle(.neutralBlack)
                .padding(.horizontal, DSSpacing.contentHorizontal)
            
            ScrollView(showsIndicators: false) {
                ForEach(model.places, id: \.placeURL) { place in
                    Button {
                        guard let domainPlace = place.toDomain() else {
                            return
                        }
                        
                        selectPlace(domainPlace)
                    } label: {
                        PlaceResultItem(place: place)
                    }
                }
            }
        }
    }
    
    private func selectPlace(_ place: Place) {
        do {
            try model.selectPlace(
                place,
                modelContext: modelContext
            )
            
            selectedPlace = place
            isPresentedConfirmView = true
        } catch {
            print(
                "RecommendedPlace 수정 실패:",
                error
            )
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
