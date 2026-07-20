//
//  DestinationView.swift
//  CheongamConan
//
//  Created by 정홍섭 on 7/14/26.
//

import SwiftUI
import SwiftData

struct DestinationView: View {
    let area: String
    let category: String

    let onDestinationLoaded: (RecommendedPlace) -> Void
    let onMoveToTracking: () -> Void

    @Environment(\.modelContext) private var modelContext
    
    @State private var destinationModel = DestinationModel()
    
    var body: some View {
        VStack {
            Spacer()
            
            if let place = destinationModel.recommendedPlace {
                Text(place.name)
                    .font(.largeTitle)
                    .fontWeight(.heavy)
                Text(place.roadAddress)
            }
            
            Spacer()
            
            Button{
                onMoveToTracking()
            } label: {
                Image(systemName: "arrow.down.circle.fill")
                    .font(.system(size: 44))
                    .foregroundStyle(.black)
            }
        }
        .task {
            await destinationModel.loadOrRecommend(
                area: area,
                category: category,
                modelContext: modelContext
            )
            if let place = destinationModel.recommendedPlace {
                onDestinationLoaded(place)
            }
        }
        .navigationBarBackButtonHidden()
    }
}
