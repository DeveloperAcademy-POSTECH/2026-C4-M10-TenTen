//
//  CategoryCard.swift
//  CheongamConan
//
//  Created by 정홍섭 on 7/21/26.
//

import SwiftUI

struct CategoryCard: View {
    let category: Category
    let isSelected: Bool
    let onTap: () -> Void
    
    var body: some View {
        Button {onTap()} label: {
            VStack(alignment: .leading) {
                VStack(alignment: .leading) {
                    Text(category.title)
                        .font(DSTypography.H4)
                        .foregroundStyle(isSelected ? .main300 : .neutralBlack)
                    
                    Text(category.rawValue.uppercased())
                        .font(DSTypography.C1)
                        .foregroundStyle(isSelected ? .main300 : .grey400)
                }
                
                Spacer()
                
                HStack {
                    Spacer()
                    
                    Image(category.imageName)
                        .resizable()
                        .frame(width: 91, height: 91)
                        .foregroundStyle(isSelected ? .main300 : .grey400)
                }
            }
        }
        .padding(.top, DSSpacing.spacing20)
        .padding(.bottom, DSSpacing.spacing28)
        .padding(.leading, DSSpacing.spacing20)
        .padding(.trailing, DSSpacing.spacing16)
        .frame(maxWidth: .infinity, minHeight: 236)
        .background(isSelected ? .main300.opacity(0.56) : .grey200)
        .cornerRadius(DSRadius.standard)
        .overlay {
            if isSelected {
                RoundedRectangle(cornerRadius: 16)
                    .inset(by: 2.48)
                    .stroke(
                        Color(
                            red: 0.96,
                            green: 0.52,
                            blue: 0.37
                        ),
                        lineWidth: 4.95349
                    )
            }
        }
    }
}

#Preview {
    CategoryCard(
        category: .cafe, isSelected: false, onTap: {}
    )
    .padding()
}
