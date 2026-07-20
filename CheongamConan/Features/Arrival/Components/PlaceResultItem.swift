//
//  PlaceResultItem.swift
//  CheongamConan
//
//  Created by 정홍섭 on 7/19/26.
//

import SwiftUI

struct PlaceResultItem: View {
    let place: Place
    
    var body: some View {
        NavigationLink{ArrivalPlaceConfirmView(place: place.name)} label: {
            VStack(alignment: .leading) {
                Group {
                    Text(place.name)
                    Text(place.roadAddress)
                }
                .padding(.horizontal, DSSpacing.contentHorizontal)
                .foregroundStyle(.black)
                
                Rectangle()
                    .frame(height: 1)
                    .foregroundStyle(.black)
            }
        }
    }
}

#Preview {
    PlaceResultItem(
        place: Place(
            name: "소디스커피 효자점",
            category: "음식점 > 카페 > 커피전문점",
            address: "경북 포항시 남구 효자동 225-2",
            roadAddress: "경북 포항시 남구 효자동길 12",
            latitude: 36.009731,
            longitude: 129.333273,
            link: URL(string: "https://place.map.kakao.com/123456789")
        )
    )
}
