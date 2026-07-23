//
//  SubQuestCard.swift
//  CheongamConan
//
//  Created by Dayoon Lee on 7/17/26.
//

import SwiftUI

struct SubQuestCard: View {
    enum State {
        case locked
        case active(SubQuest)
        case completed(SubQuest)
    }
    
    let state: State
    let onCameraTap: (SubQuest) -> Void
    
    var body: some View {
        content
            .padding(contentInsets)
            .frame(maxWidth: .infinity, minHeight: 120)
            .background(.grey200)
            .clipShape(
                RoundedRectangle(cornerRadius: DSRadius.standard)
            )
    }
    
    @ViewBuilder
    private var content: some View {
        switch state {
        case .locked:
            VStack(spacing: 10) {
                Image(systemName: "lock.fill")
                    .foregroundStyle(.grey800)
                    .frame(width: 20, height: 24)
                
                Text("집 밖을 나서면\n첫 번째 미션이 공개됩니다.")
                    .font(DSTypography.C1)
                    .foregroundStyle(.grey600)
                    .multilineTextAlignment(.center)
            }
            
        case .active(let subQuest):
            missionContent(
                for: subQuest,
                isCompleted: false
            )
            
        case .completed(let subQuest):
            missionContent(
                for: subQuest,
                isCompleted: true
            )
        }
    }
    
    private func missionContent(
        for subQuest: SubQuest,
        isCompleted: Bool
    ) -> some View {
        HStack(alignment: .bottom) {
            VStack(alignment: .leading, spacing: 9) {
                Text("여행을 더 즐겁게 만들어줄 미션")
                    .font(DSTypography.C2)
                    .foregroundStyle(.neutralBlack)
                
                VStack(alignment: .leading, spacing: 3) {
                    Text(subQuest.title)
                        .font(DSTypography.H5)
                        .foregroundStyle(.main300)
                    
                    Text("사진 찍기")
                        .foregroundStyle(.neutralBlack)
                        .font(DSTypography.B1)
                }
            }
            
            Spacer()
            
            if isCompleted {
                actionLabel(icon: "checkmark.circle")
                    .foregroundStyle(.green500)
            } else {
                Button {
                    onCameraTap(subQuest)
                } label: {
                    actionLabel(icon: "camera.circle.fill")
                        .foregroundStyle(.neutralBlack)
                }
            }
        }
    }
    
    private func actionLabel(icon: String) -> some View {
        HStack(spacing: DSSpacing.spacing12) {
            Image(systemName: icon)
                .resizable()
                .scaledToFit()
                .frame(width: 80, height: 80)
                .accessibilityHidden(true)
        }
    }
    
    private var contentInsets: EdgeInsets {
        switch state {
        case .locked:
            EdgeInsets(
                top: 10,
                leading: DSSpacing.spacing8,
                bottom: 10,
                trailing: DSSpacing.spacing8
            )
        case .active, .completed:
            EdgeInsets(
                top: DSSpacing.spacing20,
                leading: DSSpacing.spacing16,
                bottom: DSSpacing.spacing20,
                trailing: DSSpacing.spacing16
            )
        }
    }
}

#Preview("Locked") {
    SubQuestCard(
        state: .locked,
        onCameraTap: { _ in }
    )
}

#Preview("Active") {
    SubQuestCard(
        state: .active(.previewExample()),
        onCameraTap: { _ in }
    )
}

#Preview("Completed") {
    let completedSubQuest: SubQuest = {
        var subQuest = SubQuest.previewExample()
        subQuest.isCompleted = true
        return subQuest
    }()
    
    SubQuestCard(
        state: .completed(completedSubQuest),
        onCameraTap: { _ in }
    )
}
