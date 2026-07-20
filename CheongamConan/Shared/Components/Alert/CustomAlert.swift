//
//  CustomAlert.swift
//  CheongamConan
//
//  Created by 정홍섭 on 7/21/26.
//

import SwiftUI

struct CustomAlert: View {
    let title: String
    let content: String?
    
    let primaryButtonTitle: String
    let secondaryButtonTitle: String?
    
    let primaryAction: () -> Void
    let secondaryAction: (() -> Void)?
    
    init(
        title: String,
        content: String? = nil,
        primaryButtonTitle: String,
        secondaryButtonTitle: String? = nil,
        primaryAction: @escaping () -> Void,
        secondaryAction: (() -> Void)? = nil
    ) {
        self.title = title
        self.content = content
        self.primaryButtonTitle = primaryButtonTitle
        self.secondaryButtonTitle = secondaryButtonTitle
        self.primaryAction = primaryAction
        self.secondaryAction = secondaryAction
    }
    
    var body: some View {
        ZStack {
            Rectangle()
                .ignoresSafeArea()
                .foregroundStyle(.neutralBlack.opacity(0.6))
            
            VStack(alignment: .leading, spacing: DSSpacing.spacing24) {
                VStack(alignment: .leading, spacing: 11) {
                    Text(title)
                        .font(DSTypography.B2)
                        .foregroundStyle(.neutralBlack)
                    
                    if let content, !content.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                        Text(content)
                            .font(DSTypography.C2)
                            .foregroundStyle(.grey700)
                    }
                }
                
                HStack {
                    if let secondaryButtonTitle, let secondaryAction {
                        Button {
                            secondaryAction()
                        } label: {
                            Text(secondaryButtonTitle)
                                .font(DSTypography.B2)
                                .foregroundStyle(.neutralBlack)
                                .frame(maxWidth: .infinity)
                                .frame(height: 53)
                                .background(.grey200)
                                .clipShape(
                                    RoundedRectangle(
                                        cornerRadius: DSRadius.standard
                                    )
                                )
                        }
                    }
                    
                    Button {
                        primaryAction()
                    } label: {
                        Text(primaryButtonTitle)
                            .font(DSTypography.B2)
                    }
                    .frame(maxWidth: .infinity, maxHeight: 53)
                    .foregroundStyle(.neutralWhite)
                    .background(.main300)
                    .cornerRadius(DSRadius.standard)
                }
            }
            .padding(.horizontal, DSSpacing.spacing16)
            .padding(.vertical, DSSpacing.spacing24)
            .frame(maxWidth: .infinity)
            .background(
                RoundedRectangle(cornerRadius: DSRadius.standard)
                    .foregroundStyle(.neutralWhite)
            )
            .padding(.horizontal, DSSpacing.spacing16 * 2)
        }
    }
}

#Preview {
    CustomAlert(
        title: "위치 정보 권한에 대한 설정이 필요해요",
        content: "설정으로 이동해 권한을 허용해주세요.",
        primaryButtonTitle: "확인",
        secondaryButtonTitle: "취소",
        primaryAction: {},
        secondaryAction: {}
    )
}
