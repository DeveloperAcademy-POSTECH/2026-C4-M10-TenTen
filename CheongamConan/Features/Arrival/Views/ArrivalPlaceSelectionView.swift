//
//  ArrivalPlaceSelectionView.swift
//  CheongamConan
//
//  Created by 정홍섭 on 7/17/26.
//

import SwiftUI
import SwiftData

struct ArrivalPlaceSelectionView: View {
    @Environment(\.modelContext) private var modelContext
    
    @State private var model = ArrivalPlaceSelectionModel()
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("도착한 목적지를\n선택해주세요")
                .font(DSTypography.H3)
                .foregroundStyle(.neutralBlack)
            
            Spacer()
            
            VStack(spacing: DSSpacing.spacing20) {
                if let recommendedPlace = model.recommendedPlace {
                    NavigationLink {
                        ArrivalPlaceConfirmView(place: recommendedPlace.name)
                    } label: {
                        VStack(alignment: .leading) {
                            Text(recommendedPlace.name)
                                .font(DSTypography.H4)
                                .foregroundStyle(.main100)
                            
                            Spacer()
                            
                            HStack {
                                Spacer()
                                
                                Image(systemName: "arrow.down.right.circle.fill")
                                    .font(.system(size: 54))
                                    .foregroundStyle(.main100)
                            }
                        }
                        .padding(.horizontal, DSSpacing.spacing32)
                        .padding(.vertical, DSSpacing.spacing24)
                        .frame(maxWidth: .infinity, maxHeight: 291)
                        .background(.main300)
                        .cornerRadius(DSRadius.standard)
                    }
                }
                
                NavigationLink (destination: ArrivalPlaceSearchView()) {
                    VStack(alignment: .leading) {
                        Text("다른 장소")
                            .font(DSTypography.H4)
                            .foregroundStyle(.main300)
                        
                        Spacer()
                        
                        HStack {
                            Spacer()
                            
                            Image(systemName: "arrow.down.right.circle.fill")
                                .font(.system(size: 54))
                                .foregroundStyle(.main300)
                        }
                    }
                    .padding(.horizontal, DSSpacing.spacing32)
                    .padding(.vertical, DSSpacing.spacing24)
                    .frame(maxWidth: .infinity, maxHeight: 291)
                    .background(.main100)
                    .cornerRadius(DSRadius.standard)
                }
            }
            .navigationBarBackButtonHidden()
            .task {
                model.loadRecommendPlace(modelContext: modelContext)
            }
        }
        .padding(.top, DSSpacing.spacing32)
        .padding(.bottom, 6)
        .padding(.horizontal, DSSpacing.contentHorizontal)
        .background(.grey50)
    }
}

#Preview {
    ArrivalPlaceSelectionView()
        .modelContainer(
            for: RecommendedPlace.self,
            inMemory: true
        )
}
