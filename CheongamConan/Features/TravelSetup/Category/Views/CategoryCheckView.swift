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
    
    @Environment(\.dismiss) private var dimiss
    
    var body: some View {
        VStack {
            Spacer()
            
            Text(category.title)
                .font(.largeTitle)
                .fontWeight(.heavy)
            
            Spacer()
            
            HStack(spacing: 20) {
                Button {
                    dimiss()
                } label: {
                    Text("뒤로 가기")
                        .foregroundStyle(.black)
                        .frame(maxWidth: .infinity)
                        .frame(height: 30)
                }
                .buttonStyle(.bordered)
                
                Button {
                    setupModel.selectCategory(category)
                    
                    // 추천페이지로 이동 로직 구현
                    // + 지역, 카테고리에서 프랜차이즈를 제외한 곳 추천
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
    }
}

#Preview {
    CategoryCheckView(category: .cafe, setupModel: TravelSetupModel())
}
