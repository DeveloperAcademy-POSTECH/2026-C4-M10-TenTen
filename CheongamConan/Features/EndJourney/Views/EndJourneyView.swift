//
//  EndJourneyView.swift
//  CheongamConan
//
//  Created by 정홍섭 on 7/22/26.
//

import SwiftUI

struct Journey: Codable {
    let finishedAt: String
    let destination: String
    let latitude: Double
    let longitude: Double
    let isComplete: Bool
    let missionTitle: String
//    let missionImage: String?
}

struct EndJourneyView: View {
    let journeyList: [Journey] = [
        Journey(
            finishedAt: "2026-07-22T10:00:00",
            destination: "바르벳",
            latitude: 30.0,
            longitude: 45.0,
            isComplete: true,
            missionTitle: "하트 모양",
//            missionImage: "heartImage"
        ),
        Journey(
            finishedAt: "2026-07-22T11:00:00",
            destination: "청암공원",
            latitude: 35.0,
            longitude: 129.0,
            isComplete: false,
            missionTitle: "횡단보도의 신호등",
//            missionImage: nil
        )
    ]

    var body: some View {
        GeometryReader { geometry in
            let mapHeight = geometry.size.width * (437.0 / 402.0)
            
            VStack(spacing: 0) {
                Rectangle()
                    .fill(.blue100)
                    .frame(height: mapHeight)
                
                VStack(alignment: .leading) {
                    VStack(alignment: .leading, spacing: DSSpacing.spacing4) {
                        Text("오늘의 여정")
                            .font(DSTypography.H3)
                        
                        Text("\(journeyList.count)곳 방문")
                            .font(DSTypography.B2)
                    }
                    .foregroundStyle(.neutralBlack)
                    .padding(.bottom, 18)
                    
                    ScrollView(showsIndicators: false) {
                        VStack(spacing: 0) {
                            ForEach(Array(journeyList.enumerated()), id: \.offset) { index, journey in
                                TodayJourneyItem(
                                    showsLine: index != journeyList.count - 1,
                                    number: String(index + 1),
                                    isComplete: journey.isComplete,
                                    title: journey.missionTitle,
                                    destinationTitle: journey.destination
                                )
                            }
                        }
                    }
                    
                    Spacer()
                    
                    HStack {
                        Button {
                            
                        } label: {
                            Text("여행 종료하기")
                                .font(DSTypography.B2)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, DSSpacing.spacing16)
                                .foregroundStyle(.main300)
                        }
                        .overlay(
                            RoundedRectangle(cornerRadius: DSRadius.standard)
                                .inset(by: 1)
                                .stroke(.main300, lineWidth: 2)
                        )
                        
                        Button {
                            
                        } label: {
                            Text("공유하기")
                        }
                        .buttonStyle(DSButtonStyle(
                            backgroundColor: .main300,
                            foregroundColor: .neutralWhite
                        ))
                    }
                }
                .padding(.top, DSSpacing.spacing36)
                .padding(.bottom, 55)
                .padding(.horizontal, DSSpacing.contentHorizontal)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(.neutralWhite)
                .cornerRadius(DSRadius.standard)
                .padding(.top, -16)
            }
        }
        .ignoresSafeArea()
    }
}

#Preview {
    EndJourneyView()
}
