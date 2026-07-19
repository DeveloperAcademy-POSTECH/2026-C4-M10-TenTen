//
//  ArrivalPlaceSelectionView.swift
//  CheongamConan
//
//  Created by 정홍섭 on 7/17/26.
//

import SwiftUI

struct ArrivalPlaceSelectionView: View {
    private let model = ArrivalPlaceSelectionModel()
    
    var body: some View {
        if let recommendedPlace = model.recommendedPlace {
            VStack(spacing: DSSpacing.spacing16) {
                Button{
                    
                } label: {
                    Text(recommendedPlace.name)
                        .padding(.vertical, DSSpacing.spacing16)
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
                
                Button{
                    
                } label: {
                    Text("다른 장소")
                        .padding(.vertical, DSSpacing.spacing16)
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.bordered)
            }
            .padding(.horizontal, DSSpacing.contentHorizontal)
        }
    }
}

#Preview {
    ArrivalPlaceSelectionView()
}
