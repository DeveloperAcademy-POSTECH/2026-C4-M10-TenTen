//
//  EndJourneyView.swift
//  CheongamConan
//
//  Created by 정홍섭 on 7/22/26.
//

import SwiftUI
import SwiftData

struct EndJourneyView: View {
    @Query(
        sort: \TodayJourney.createdAt,
        order: .reverse
    )
    private var todayJourneys: [TodayJourney]
    
    @Environment(\.modelContext) private var modelContext
    
    @State private var isPresentedHomeView: Bool = false
    @State private var isShowShareAlert: Bool = false
    
    @AppStorage(JourneyRouteStorage.key)
    private var journeyRouteData: Data = Data()
    
    private var journeyRoutePoints: [JourneyRoutePoint] {
        JourneyRouteStorage.decode(journeyRouteData)
    }
    
    private var journeyList: [Journey] {
        todayJourneys
            .first {
                Calendar.current.isDateInToday($0.createdAt)
            }?
            .journeyList ?? []
    }
    
    var body: some View {
        GeometryReader { geometry in
            let mapHeight = geometry.size.width * (437.0 / 402.0)
            
            VStack(spacing: 0) {
                JourneyMapView(
                    journeyList: journeyList,
                    routePoints: journeyRoutePoints
                )
                .id(journeyRouteData)
                .frame(height: mapHeight)
                .clipped()
                
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
                            clearTodayJourney()

                            isPresentedHomeView = true
                        } label: {
                            Text("홈으로 가기")
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
                            isShowShareAlert = true
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
                // MARK: 디자인과 동일은 -16이지만 네이버 지도의 규정을 위반해서 일단 내림 - 상의 필요
                .padding(.top, -11)
            }
        }
        .ignoresSafeArea()
        .navigationBarBackButtonHidden()
        .navigationDestination(isPresented: $isPresentedHomeView) {
            HomeView()
        }
        .customAlert(
            isPresented: $isShowShareAlert,
            title: "준비 중입니다.",
            primaryButtonTitle: "확인",
            primaryAction: {}
        )
    }
    
    private func clearTodayJourney() {
        do {
            let calendar = Calendar.current
            let startOfToday = calendar.startOfDay(for: .now)
            let startOfTomorrow = calendar.date(
                byAdding: .day,
                value: 1,
                to: startOfToday
            ) ?? startOfToday.addingTimeInterval(86_400)

            let descriptor = FetchDescriptor<TodayJourney>(
                predicate: #Predicate<TodayJourney> { journey in
                    journey.createdAt >= startOfToday &&
                    journey.createdAt < startOfTomorrow
                }
            )

            let todayJourneys = try modelContext.fetch(descriptor)

            todayJourneys.forEach { todayJourney in
                todayJourney.journeyList = []
            }

            try modelContext.save()
        } catch {
            print("TodayJourney 초기화 실패:", error)
        }
    }
}

#Preview {
    EndJourneyView()
}
