//
//  CustomTextField.swift
//  CheongamConan
//
//  Created by 정홍섭 on 7/22/26.
//

import SwiftUI

struct CustomTextField: View {
    let placeholder: String
    @Binding var text: String
    
    var body: some View {
        HStack(spacing: DSSpacing.spacing12) {
            TextField(placeholder, text: $text)
                .font(DSTypography.B1)
                .foregroundStyle(.neutralBlack)
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled()
            
            if !text.isEmpty {
                Button {
                    text = ""
                } label: {
                    Image(systemName: "x.circle.fill")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundStyle(.neutralBlack)
                }
                .buttonStyle(.plain)
            }
        }
        .padding(.bottom, DSSpacing.spacing12)
        .overlay(alignment: .bottom) {
            Rectangle()
                .fill(.grey400)
                .frame(height: 1)
        }
    }
}

#Preview {
    CustomTextField(placeholder: "도착지를 입력해주세요.", text: .constant("dd"))
}
