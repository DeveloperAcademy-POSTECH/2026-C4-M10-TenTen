//
//  DSButtonStyle.swift
//  CheongamConan
//
//  Created by 정홍섭 on 7/21/26.
//

import SwiftUI

struct DSButtonStyle: ButtonStyle {
    let backgroundColor: Color
    let foregroundColor: Color
    let font: Font
    
    init(
        backgroundColor: Color = .main400,
        foregroundColor: Color = .neutralWhite,
        font: Font = DSTypography.B1
    ) {
        self.backgroundColor = backgroundColor
        self.foregroundColor = foregroundColor
        self.font = font
    }
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(.vertical, DSSpacing.spacing16)
            .font(font)
            .frame(maxWidth: .infinity)
            .background(backgroundColor)
            .foregroundStyle(foregroundColor)
            .cornerRadius(DSRadius.standard)
    }
}
