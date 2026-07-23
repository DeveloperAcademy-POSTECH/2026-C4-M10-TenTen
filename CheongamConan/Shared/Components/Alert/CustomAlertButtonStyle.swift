//
//  CustomAlertButtonStyle.swift
//  CheongamConan
//
//  Created by 정홍섭 on 7/21/26.
//

import SwiftUI

struct CustomAlertButtonStyle: ButtonStyle {
    enum Style {
        case primary
        case secondary
    }
    
    let style: Style
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(DSTypography.C1)
            .foregroundStyle(foregroundColor)
            .frame(maxWidth: .infinity)
            .frame(height: 53)
            .background(backgroundColor)
            .clipShape(
                RoundedRectangle(
                    cornerRadius: DSRadius.standard
                )
            )
    }
    
    private var foregroundColor: Color {
        switch style {
        case .primary:
            return .neutralWhite
            
        case .secondary:
            return .neutralBlack
        }
    }
    
    private var backgroundColor: Color {
        switch style {
        case .primary:
            return .main300
            
        case .secondary:
            return .grey200
        }
    }
}
