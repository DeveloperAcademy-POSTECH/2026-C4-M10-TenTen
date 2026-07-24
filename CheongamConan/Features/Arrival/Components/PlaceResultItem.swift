//
//  PlaceResultItem.swift
//  CheongamConan
//
//  Created by 정홍섭 on 7/19/26.
//

import SwiftUI

struct PlaceResultItem: View {
    let place: SearchResultPlace
    
    var body: some View {
        VStack(alignment: .leading) {
            VStack(alignment: .leading, spacing: DSSpacing.spacing8) {
                Text(place.placeName)
                    .font(DSTypography.B1)
                    .foregroundStyle(.grey900)
                
                Text(place.roadAddressName)
                    .font(DSTypography.C2)
                    .foregroundStyle(.grey700)
            }
            .padding(.horizontal, DSSpacing.contentHorizontal)
            .foregroundStyle(.black)
            
            Rectangle()
                .frame(height: 1)
                .foregroundStyle(.grey400)
        }
    }
}

#Preview {
    PlaceResultItem(
        place: SearchResultPlace(
            placeName: "소디스커피 효자점",
            categoryName: "음식점 > 카페 > 커피전문점",
            addressName: "경북 포항시 남구 효자동 225-2",
            roadAddressName: "경북 포항시 남구 효자동길 12",
            longitude: "129.333273",
            latitude: "36.009731",
            placeURL: "https://localhost:3000"
        )
    )
}
