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
    @State private var isStartingJourney = false
    
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
                        await startJourney(area: area)
                    }
                } label: {
                    if isStartingJourney {
                        ProgressView()
                            .frame(maxWidth: .infinity)
                    } else {
                        Text("여행 떠나기")
                            .frame(maxWidth: .infinity)
                    }
                }
                .frame(height: 30)
                .buttonStyle(.borderedProminent)
                .disabled(isStartingJourney)
            }
            .padding(.horizontal)
        }
        .navigationBarBackButtonHidden()
    }
    
    /// 세션을 먼저 저장하면 RootView가 유일한 JourneyView를 생성한다.
    /// 이 화면에서 JourneyView를 직접 push하지 않아 추적 모델의 중복 생성을 막는다.
    private func startJourney(area: String) async {
        guard !isStartingJourney else { return }
        isStartingJourney = true
        defer { isStartingJourney = false }
        
        await destinationModel.loadOrRecommend(
            area: area,
            category: category.rawValue,
            modelContext: modelContext
        )
        
        guard let destination = destinationModel.recommendedPlace else {
            return
        }
        
        let session = JourneySession(
            area: area,
            category: category.rawValue,
            destination: destination
        )
        modelContext.insert(session)

        do {
            try modelContext.save()
            journeyRouter.showJourney(session)
        } catch {
            modelContext.delete(session)
        }
    }
}

#Preview {
    CategoryCheckView(category: .cafe, setupModel: TravelSetupModel())
        .environment(JourneyRouter())
}
