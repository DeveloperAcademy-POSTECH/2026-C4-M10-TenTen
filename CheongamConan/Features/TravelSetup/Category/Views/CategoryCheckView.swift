//
//  CategoryCheckView.swift
//  CheongamConan
//
//  Created by 정홍섭 on 7/14/26.
//

import SwiftUI
import SwiftData

struct CategoryCheckView: View {
    let category: Category
    let setupModel: TravelSetupModel
    
    @Environment(\.modelContext) private var modelContext
    @Environment(JourneyRouter.self) private var journeyRouter
    
    @State private var model = CategoryCheckModel()
    
    var body: some View {
        VStack(alignment: .center) {
            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    HStack(spacing: 0) {
                        Text("\(category.title)")
                            .foregroundStyle(.main300)
                        
                        Text(
                            category == .random || category == .restaurant
                            ? "으로 가는 길에서"
                            : "로 가는 길에서"
                        )
                        .foregroundStyle(.neutralBlack)
                    }
                    
                    Text("새로운 경험을 즐겨보세요")
                        .foregroundStyle(.neutralBlack)
                }
                .font(DSTypography.H4)
                
                Spacer()
            }
            
            Spacer()
            
            VStack(){
                VStack(alignment: .leading) {
                    VStack(alignment: .leading) {
                        Text(category.title)
                            .font(DSTypography.H3)
                            .foregroundStyle(.main300)
                        
                        Text(category.rawValue.uppercased())
                            .font(DSTypography.C1)
                            .foregroundStyle(.main300)
                    }
                    
                    Spacer()
                    
                    HStack {
                        Spacer()
                        
                        Image(category.imageName)
                            .resizable()
                            .frame(width: 120, height: 120)
                            .foregroundStyle(.main300)
                    }
                }
            }
            .padding(.top, DSSpacing.spacing20)
            .padding(.bottom, 23)
            .padding(.leading, DSSpacing.spacing20)
            .padding(.trailing, DSSpacing.spacing16)
            .frame(maxWidth: 196, maxHeight: 271)
            .background(.main300.opacity(0.56))
            .cornerRadius(DSRadius.standard)
            .overlay {
                RoundedRectangle(cornerRadius: 16)
                    .inset(by: 2)
                    .stroke(
                        .main300,
                        lineWidth: 4
                    )
            }
            
            Spacer()
            
            VStack {
                HStack(spacing: 0) {
                    Text("가는 길에 ")
                        .foregroundStyle(.grey700)
                    
                    Text("목적지가 바뀌더라도 괜찮아요")
                        .foregroundStyle(.main300)
                }
                .font(DSTypography.C2)
                
                Button {
                    guard let area = setupModel.confirmCategory(category) else {
                        return
                    }
                    
                    Task {
                        guard let session = await model.startJourney(
                            area: area,
                            category: category,
                            modelContext: modelContext
                        ) else { return }
                        journeyRouter.showJourney(session)
                    }
                } label: {
                    if model.isStartingJourney {
                        ProgressView()
                            .tint(.neutralWhite)
                            .frame(maxWidth: .infinity)
                    } else {
                        Text("여행 떠나기")
                    }
                }
                .buttonStyle(
                    DSButtonStyle(
                        backgroundColor: .main300,
                        foregroundColor: .neutralWhite
                    )
                )
                .disabled(model.isStartingJourney)
            }
        }
        .padding(.top, 23)
        .padding(.bottom, DSSpacing.spacing20)
        .padding(.horizontal, DSSpacing.contentHorizontal)
    }
}
 
#Preview {
    CategoryCheckView(category: .cafe, setupModel: TravelSetupModel())
        .environment(JourneyRouter())
}
