//
//  ArrivalPlaceConfirmView.swift
//  CheongamConan
//
//  Created by 정홍섭 on 7/19/26.
//

import SwiftUI

struct ArrivalPlaceConfirmView: View {
    let place: String
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(place)
            Text("도착")
            
            Spacer()
            
            HStack(spacing: DSSpacing.spacing12) {
                Button {
                    
                } label: {
                    Text("여행 종료하기")
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, DSSpacing.spacing16)
                }
                .buttonStyle(.bordered)
                
                Button {
                    
                } label: {
                    Text("다음 목적지 받기")
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, DSSpacing.spacing16)
                }
                .buttonStyle(.borderedProminent)
            }
        }
        .padding(.horizontal, DSSpacing.contentHorizontal)
        .padding(.top, 20)
    }
}

#Preview {
    ArrivalPlaceConfirmView(place: "소디스")
}
