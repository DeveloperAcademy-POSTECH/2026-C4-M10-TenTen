//
//  ArrivalPlaceSelectionView.swift
//  CheongamConan
//
//  Created by 정홍섭 on 7/17/26.
//

import SwiftUI
import SwiftData

struct ArrivalPlaceSelectionView: View {
    @Environment(\.modelContext) private var modelContext
    
    @State private var model = ArrivalPlaceSelectionModel()
    
    var body: some View {
        VStack(spacing: DSSpacing.spacing16) {
            if let recommendedPlace = model.recommendedPlace {
                NavigationLink {
                    ArrivalPlaceConfirmView(place: recommendedPlace.name)
                } label: {
                    Text(recommendedPlace.name)
                        .padding(.vertical, DSSpacing.spacing16)
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
            }
            
            NavigationLink (destination: ArrivalPlaceSearchView()) {
                Text("다른 장소")
                    .padding(.vertical, DSSpacing.spacing16)
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.bordered)
        }
        .navigationBarBackButtonHidden()
        .padding(.horizontal, DSSpacing.contentHorizontal)
        .task {
            model.loadRecommendPlace(modelContext: modelContext)
        }
    }
}

#Preview {
    ArrivalPlaceSelectionView()
        .modelContainer(
            for: RecommendedPlace.self,
            inMemory: true
        )
}
