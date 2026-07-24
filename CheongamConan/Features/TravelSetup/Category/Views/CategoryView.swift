//
//  CategoryView.swift
//  CheongamConan
//
//  Created by 정홍섭 on 7/13/26.
//

import SwiftUI

struct CategoryView: View {
    let setupModel: TravelSetupModel
    
    @State private var selectedCategory: Category?
    
    private let columns = [
        GridItem(.flexible(), spacing: 18),
        GridItem(.flexible(), spacing: 18)
    ]
    
    var body: some View {
        VStack {
            VStack(alignment: .leading, spacing: DSSpacing.spacing8) {
                HStack(spacing: 0) {
                    Text("여행의 ")
                        .foregroundStyle(.neutralBlack)
                    Text("카테고리")
                        .foregroundStyle(.main300)
                    Text("를 선택해봐요")
                        .foregroundStyle(.neutralBlack)
                }
                .font(DSTypography.H4)
                
                Text("취향에 맞는 곳을 추천해 드릴게요.")
                    .font(DSTypography.C2)
                    .foregroundStyle(.grey400)
            }
            
            Spacer()
            
            VStack(spacing: DSSpacing.spacing52) {
                LazyVGrid(columns: columns, spacing: 18) {
                    ForEach(Category.allCases) { category in
                        let isSelected = selectedCategory == category
                        
                        CategoryCard(
                            category: category,
                            isSelected: isSelected
                        ) {
                            selectedCategory = isSelected ? nil : category
                        }
                    }
                }
                
                NavigationLink {
                    if let selectedCategory {
                        CategoryCheckView(
                            category: selectedCategory,
                            setupModel: setupModel
                        )
                    }
                } label: {
                  Text("다음")
                }
                .buttonStyle(
                    DSButtonStyle(
                        backgroundColor: .main300,
                        foregroundColor: .neutralWhite
                    )
                )
                .disabled(selectedCategory == nil)
            }
        }
        .padding(.top, 23)
        .padding(.horizontal, DSSpacing.contentHorizontal)
        .background(.grey50)
    }
}

#Preview {
    CategoryView(setupModel: TravelSetupModel())
}
