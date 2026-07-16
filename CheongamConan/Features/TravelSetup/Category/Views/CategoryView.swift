//
//  CategoryView.swift
//  CheongamConan
//
//  Created by 정홍섭 on 7/13/26.
//

import SwiftUI

struct CategoryView: View {
    let setupModel: TravelSetupModel
    
    private let colums = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        LazyVGrid(
            columns: colums,
            spacing: 10
        ) {
            ForEach(Category.allCases) { category in
                NavigationLink(
                    destination: CategoryCheckView(
                        category: category,
                        setupModel: setupModel
                    )
                ) {
                    Text(category.title)
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        .foregroundStyle(.white)
                        .bold()
                        .background(.blue)
                        .cornerRadius(8)
                }
            }
        }
        .padding()
    }
}

#Preview {
    CategoryView(setupModel: TravelSetupModel())
}
