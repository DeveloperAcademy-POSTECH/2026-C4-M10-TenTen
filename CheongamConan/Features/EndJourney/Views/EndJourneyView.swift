//
//  EndJourneyView.swift
//  CheongamConan
//
//  Created by 정홍섭 on 7/22/26.
//

import SwiftUI

struct EndJourneyView: View {
    let journeyList: [Journey] = [
        Journey(
            finishedAt: "2026-07-22T10:00:00",
            destination: "바르벳",
            latitude: 36.010222,
            longitude: 129.296528,
            isComplete: true,
            missionTitle: "하트 모양",
        ),
        Journey(
            finishedAt: "2026-07-22T11:00:00",
            destination: "포항 순이",
            latitude: 36.002871,
            longitude: 129.33086,
            isComplete: false,
            missionTitle: "횡단보도의 신호등",
        )
    ]
    
    @State private var isPresentedHomeView: Bool = false
    @State private var shareImage: UIImage?
    @State private var isPresentedShareSheet: Bool = false
    @State private var buttonsTopY: CGFloat = .infinity
    
    var body: some View {
        GeometryReader { geometry in
            let mapHeight = geometry.size.width * (437.0 / 402.0)
            
            VStack(spacing: 0) {
                JourneyMapView(journeyList: journeyList)
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
                            shareJournal()
                        } label: {
                            Text("공유하기")
                        }
                        .buttonStyle(DSButtonStyle(
                            backgroundColor: .main300,
                            foregroundColor: .neutralWhite
                        ))
                    }
                    // 버튼 HStack의 실제 화면 Y좌표를 측정해 공유 이미지 crop 기준으로 사용하기 위해 추가
                    .background(
                        GeometryReader { proxy in
                            Color.clear
                                .preference(key: ButtonsTopYKey.self, value: proxy.frame(in: .global).minY)
                        }
                    )
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
        .onPreferenceChange(ButtonsTopYKey.self) { newValue in
                    buttonsTopY = newValue
                }
        .sheet(isPresented: $isPresentedShareSheet) {
                    if let shareImage {
                        ShareSheet(items: [shareImage])
                    }
                }
    }
}

// 공유기능
extension EndJourneyView {
    @MainActor
    func shareJournal() {
        guard let image = UIApplication.shared.captureCurrentScreen(excludingBelow: buttonsTopY) else { return }
        shareImage = image
        isPresentedShareSheet = true
    }
}

#Preview {
    EndJourneyView()
}

