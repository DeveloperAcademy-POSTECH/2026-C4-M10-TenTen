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
    
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    @Environment(JourneyRouter.self) private var journeyRouter
    
    @State private var destinationModel = DestinationModel()
    @State private var model = CategoryCheckModel()
    
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
                            .frame(maxWidth: .infinity)
                    } else {
                        Text("여행 떠나기")
                            .frame(maxWidth: .infinity)
                    }
                }
                .frame(height: 30)
                .buttonStyle(.borderedProminent)
                .disabled(model.isStartingJourney)
            }
            .padding(.horizontal)
            
        }
        .navigationBarBackButtonHidden()
    }
}
 
#Preview {
    CategoryCheckView(category: .cafe, setupModel: TravelSetupModel())
        .environment(JourneyRouter())
}
