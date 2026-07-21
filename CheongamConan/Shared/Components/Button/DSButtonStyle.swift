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
    
    init(
        backgroundColor: Color = .main400,
        foregroundColor: Color = .neutralWhite
    ) {
        self.backgroundColor = backgroundColor
        self.foregroundColor = foregroundColor
    }
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(.vertical, DSSpacing.spacing16)
            .font(DSTypography.B1)
            .frame(maxWidth: .infinity)
            .background(backgroundColor)
            .foregroundStyle(foregroundColor)
            .cornerRadius(DSRadius.standard)
    }
}
