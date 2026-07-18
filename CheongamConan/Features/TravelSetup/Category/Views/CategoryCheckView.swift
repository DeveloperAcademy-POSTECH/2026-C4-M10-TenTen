//
//  CategoryCheckView.swift
//  CheongamConan
//
//  Created by 정홍섭 on 7/14/26.
//

import SwiftUI

struct CategoryCheckView: View {
    let category: Category
    let setupModel: TravelSetupModel
    
    @Environment(\.dismiss) private var dismiss

    @State private var destinationArea: String?
    
    var body: some View {
        VStack {
            Spacer()
            
            Text(category.title)
                .font(.largeTitle)
                .fontWeight(.heavy)
            
            Spacer()
            
            HStack(spacing: 20) {
                Button {
                    dismiss()
                } label: {
                    Text("뒤로 가기")
                        .foregroundStyle(.black)
                        .frame(maxWidth: .infinity)
                        .frame(height: 30)
                }
                .buttonStyle(.bordered)
                
                Button {
                    guard let area = setupModel.confirmCategory(category) else {
                        return
                    }
                    
                    destinationArea = area
                } label: {
                    Text("여행 떠나기")
                        .frame(maxWidth: .infinity)
                        .frame(height: 30)
                }
                .buttonStyle(.borderedProminent)
            }
            .padding(.horizontal)
        }
        .navigationBarBackButtonHidden()
        .navigationDestination(item: $destinationArea) { area in
            JourneyView(
                area: area,
                category: category.title
            )
        }
    }
}

#Preview {
    CategoryCheckView(category: .cafe, setupModel: TravelSetupModel())
}
