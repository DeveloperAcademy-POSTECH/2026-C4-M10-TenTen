//
//  TodayJourneyItem.swift
//  CheongamConan
//
//  Created by 정홍섭 on 7/22/26.
//

import SwiftUI

struct TodayJourneyItem: View {
    let showsLine: Bool
    let number: String
    let isComplete: Bool
    let title: String
    let destinationTitle: String
    let imageFileName: String
    
    private var missionImage: UIImage? {
        guard !imageFileName.isEmpty else {
            return nil
        }

        guard let applicationSupportURL = FileManager.default.urls(
            for: .applicationSupportDirectory,
            in: .userDomainMask
        ).first else {
            return nil
        }

        let imageURL = applicationSupportURL
            .appendingPathComponent(
                "MissionImages",
                isDirectory: true
            )
            .appendingPathComponent(imageFileName)

        return UIImage(contentsOfFile: imageURL.path)
    }
    
    var body: some View {
        HStack(alignment: .top, spacing: DSSpacing.spacing8) {
            VStack(alignment: .center, spacing: 0) {
                Text(number)
                    .font(DSTypography.B2)
                    .frame(width: 24, height: 24)
                    .background(.main300)
                    .foregroundStyle(.main50)
                    .cornerRadius(999)
                
                if showsLine {
                    Rectangle()
                        .frame(width: 2)
                        .foregroundStyle(.main300)
                }
            }
            
            VStack(alignment: .leading, spacing: DSSpacing.spacing8) {
                HStack {
                    Text(destinationTitle)
                        .font(DSTypography.B1)
                    
                    Spacer()
                }
                
                if !title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                    HStack {
                        VStack(alignment: .leading, spacing: DSSpacing.spacing4) {
                            Text(isComplete ? "완료한 미션" : "이런 미션이 있었어요")
                                .font(DSTypography.C1)
                                .foregroundStyle(.grey700)
                            
                            Text(title)
                                .font(DSTypography.B2)
                                .foregroundStyle(.neutralBlack)
                        }
                        
                        Spacer()
                        
                        if isComplete, let missionImage {
                            Image(uiImage: missionImage)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 65, height: 65)
                                .clipShape(
                                    RoundedRectangle(
                                        cornerRadius: DSRadius.standard
                                    )
                                )
                        }
                    }
                    .padding(DSSpacing.spacing16)
                    .background(.grey200)
                    .cornerRadius(DSRadius.standard)
                    .padding(.bottom, 28)
                }
            }
        }
    }
}

#Preview {
    TodayJourneyItem(
        showsLine: false,
        number: "1",
        isComplete: false,
        title: "미션 1",
        destinationTitle: "바르벳",
        imageFileName: ""
    )
}
