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
            .frame(maxWidth: .infinity, minHeight: 119)
            .background(.grey50)
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
                VStack(spacing: DSSpacing.spacing4) {
                    Text("집 밖을 나서면")
                        .foregroundStyle(.grey600)
                    Text("첫 번째 미션이 공개됩니다.")
                        .foregroundStyle(.grey600)
                }
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
        VStack(alignment: .leading, spacing: DSSpacing.spacing20) {
            Text("여행을 더 즐겁게 만들어줄 미션")
                .font(DSTypography.B2)
            HStack(alignment: .center, spacing: 0) {
                VStack(
                    alignment: .leading,
                    spacing: DSSpacing.spacing4
                ) {
                    Text(subQuest.title)
                        .foregroundStyle(.main300)
                        .font(DSTypography.C1)

                    Text("사진 찍기")
                        .font(DSTypography.C1)
                }
                .layoutPriority(1)

                Spacer(minLength: DSSpacing.spacing16)

                if isCompleted {
                    actionLabel(
                        icon: "checkmark.circle.fill",
                        title: "촬영 완료"
                    )
                } else {
                    Button {
                        onCameraTap(subQuest)
                    } label: {
                        actionLabel(
                            icon: "camera.fill",
                            title: "촬영하기"
                        )
                    }
                }
            }
        }
    }

    private func actionLabel(
        icon: String,
        title: String
    ) -> some View {
        HStack(spacing: DSSpacing.spacing12) {
            Image(systemName: icon)
                .resizable()
                .scaledToFit()
                .frame(width: 20, height: 16)
                .accessibilityHidden(true)

            Text(title)
                .font(DSTypography.C3)
        }
        .foregroundStyle(.white)
        .padding(DSSpacing.spacing12)
        .frame(minWidth: 100, minHeight: 46)
        .background(.black)
        .clipShape(
            RoundedRectangle(cornerRadius: DSRadius.standard)
        )
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
                top: DSSpacing.spacing16,
                leading: DSSpacing.spacing16,
                bottom: DSSpacing.spacing16,
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
        state: .active(.movementExample()),
        onCameraTap: { _ in }
    )
}

#Preview("Completed") {
    let completedSubQuest: SubQuest = {
        var subQuest = SubQuest.movementExample()
        subQuest.isCompleted = true
        return subQuest
    }()

    SubQuestCard(
        state: .completed(completedSubQuest),
        onCameraTap: { _ in }
    )
}
